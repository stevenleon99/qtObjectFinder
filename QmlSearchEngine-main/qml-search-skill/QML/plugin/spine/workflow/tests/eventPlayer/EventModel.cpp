#include "EventModel.h"
#include <epicdb/EpicDbHelper.h>
#include <QJsonDocument>
#include <QJsonObject>
#include <algorithms/GMedMath.h>
#include "FluoroManager.h"
#include <QThread>
#include <fluororegistration/FluoroRegistration.h>
#include <tracking/TrackerManager.h>
#include <tracking/FluoroTracker.h>
#include <tracking/PatientTracker.h>
#include <tracking/TransformationManager.h>

EventModel::EventModel(QObject* parent)
    : QObject(parent)
{}

void EventModel::loadEvents()
{
    QSqlDatabase db = QSqlDatabase::database(EpicDbHelper::connectionName());

    QString qStr("SELECT * FROM events ORDER BY datetime ASC");

    QSqlQuery q(qStr, db);

    while (q.next())
    {
        EventData ed;

        ed.m_datetime = q.value("datetime").toDateTime();
        ed.m_event = q.value("event_type").toString();
        ed.m_dataType = q.value("data_type").toString();
        ed.m_scanUuid = q.value("scan_uuid").toString();
        ed.m_stringData = q.value("data_string").toString();
        ed.m_data = q.value("data").toByteArray();

        if (ed.m_dataType == "JSON")
        {
            ed.m_cameraXtool = activeTrackers(ed.m_data);
        }

        m_events += ed;
    }
}

QMap<QString, QMatrix4x4> EventModel::activeTrackers(const QByteArray& json)
{
    QMap<QString, QMatrix4x4> camera_X_elementList;

    QVariantMap v = QJsonDocument::fromBinaryData(json).toVariant().toMap();
    if (!v.contains("tracking"))
    {
        qDebug() << "Map invalid";
        return camera_X_elementList;
    }
    v = v["tracking"].toMap();

    if (!v.contains("elements"))
    {
        qDebug() << "Map invalid";
        return camera_X_elementList;
    }
    v = v["elements"].toMap();


    for (QString key : v.keys())
    {
        QVariantMap elMap = v[key].toMap();
        if (elMap["status"].toInt() == 0)
        {
            QVariantList st = elMap["cameraTelement"].toList();
            QVector3D t =
                QVector3D(st[0].toFloat(), st[1].toFloat(), st[2].toFloat());
            st = elMap["cameraRelement"].toList();
            QQuaternion q = QQuaternion(st[3].toFloat(), st[0].toFloat(),
                                        st[1].toFloat(), st[2].toFloat());

            camera_X_elementList[key] = GMedMath::xform(q, t);
        }
    }

    return camera_X_elementList;
}

QString EventModel::studyKey(const QString& scanUuid)
{
    QSqlDatabase db = QSqlDatabase::database(EpicDbHelper::connectionName());

    QString qStr("SELECT dicom_study_uid FROM scan where scan_uuid = '%1'");
    qStr = qStr.arg(scanUuid);

    QSqlQuery q(qStr, db);

    if (q.first())
    {
        return q.value(0).toString().trimmed();
    }

    return QString();
}

QVector3D EventModel::toolTip(const QString& toolUuid)
{
    QSqlDatabase db = QSqlDatabase::database(EpicDbHelper::connectionName());
    QString qStr(
        "SELECT x,y,z FROM instrumentlandmarks WHERE instrument_uuid = '%1' "
        "AND landmark_type = 'Tip_ROM';");
    qStr = qStr.arg(toolUuid);

    QSqlQuery q(qStr, db);

    if (q.first())
    {
        return QVector3D(q.value(0).toFloat(), q.value(1).toFloat(),
                         q.value(2).toFloat());
    }

    return QVector3D();
}

void EventModel::fluoroAccuracy()
{
    FluoroManager* fm = NULL;

    QString probeUuid =
        "66b9ce17-717f-4ffe-83e0-0b7649631812";  // Accuracy Probe

    QString probe2Uuid =
        "e59606ad-9fc9-4afa-93dd-179933447eb4";  // Pedical Probe

    QString fluoroTrackerUuid;
    QString drbUuid;

    //    QString fluoroTrackerUuid = "736131eb-3609-41b9-8eec-09cffd3defd1";
    //    QString fluoroTrackerUuid = "c3636d95-bffc-459a-af5c-3e156879dbfd";
    //    QString drbUuid = "171defab-d434-43ce-abb6-6a5caf3852db";

    QVector3D toolTip_rom1 = toolTip(probeUuid);
    QVector3D toolTip_rom2 = toolTip(probeUuid);

    QString currentPage;
    QMap<QString, QMatrix4x4> fluoroTracker_X_DrbMap;
    Tracking::TrackerManager* trkManager =
        Tracking::TrackerManagerSingleton::Instance();
    bool abortRun = false;

    for (const EventData& ed : m_events)
    {
        if (ed.m_event == "AppStart" && ed.m_stringData == "GPS-Client")
        {
            abortRun = false;
            qDebug() << "******************************************************"
                        "******************************************************"
                        "**********";
            qDebug() << "APP Started"
                     << ed.m_datetime.addSecs(7 * 60 * 60).toString();
            qDebug() << "******************************************************"
                        "******************************************************"
                        "**********";
            if (fm)
            {
                fm->deleteLater();
                currentPage.clear();
                // Need to offset logs
                QThread::sleep(1);
            }

            fm = new FluoroManager;
        }
        else if (ed.m_event == "FluoroCapture" && !abortRun)
        {
            //            fm->setActiveStudy(studyKey(ed.m_scanUuid));

            QStringList tKeys = ed.m_cameraXtool.keys();
            for (const QString& key : tKeys)
            {
                Tracking::Tracker* trk = trkManager->tracker(key);
                if (trk->className() == "Tracking::FluoroTracker")
                {
                    fluoroTrackerUuid = key;
                }
                if (trk->className() == "Tracking::PatientTracker")
                {
                    drbUuid = key;
                }
            }

            // qDebug() << ed.m_cameraXtool.keys();
            fluoroTracker_X_DrbMap[ed.m_scanUuid] =
                ed.m_cameraXtool[fluoroTrackerUuid].inverted() *
                ed.m_cameraXtool[drbUuid];
        }
        else if (ed.m_event == "CollectPointFluoro" &&
                 currentPage != "FluoroCapture" && !abortRun)
        {
            QString activeProbe;
            QVector3D toolTip_rom;
            if (ed.m_cameraXtool.contains(probeUuid))
            {
                activeProbe = probeUuid;
                toolTip_rom = toolTip_rom1;
            }
            else if (ed.m_cameraXtool.contains(probe2Uuid))
            {
                activeProbe = probe2Uuid;
                toolTip_rom = toolTip_rom2;
            }

            if (ed.m_cameraXtool.contains(drbUuid) && !activeProbe.isEmpty())
            {
                QMatrix4x4 trans;
                trans.translate(toolTip_rom);
                QMatrix4x4 mat = ed.m_cameraXtool[drbUuid].inverted() *
                                 ed.m_cameraXtool[activeProbe];

                QMatrix4x4 cMat = mat * trans;

                QVector3D probeTip_drb = cMat.column(3).toVector3D();
                fm->findCorrespondingLandmarkFromPointer(probeTip_drb);
            }
        }
        else if (ed.m_event == "ActivePage")
        {
            if (currentPage == "FluoroCapture" && !abortRun)
            {
                QString sUuid[2];
                sUuid[0] = fm->scanUuid(0);
                sUuid[1] = fm->scanUuid(1);
                bool rtn = true;

                fm->setAccuracyInfo("C:\\temp\\", "FluoroAccuracy");

                //                rtn =
                //                updateTransformWithPickedPnts(fm->activeStudy(),sUuid,fluoroTrackerUuid,drbUuid,fluoroTracker_X_DrbMap);
                //                rtn =
                //                updateTransformWithAlgorithm(fm->activeStudy(),sUuid,fluoroTrackerUuid,drbUuid,fluoroTracker_X_DrbMap);

                if (rtn)
                {
                    fm->findCorresponding3DLandmarks();
                }
                else
                {
                    //                    qDebug() << "Run Aborted:" <<
                    //                    fm->activeStudy();
                    abortRun = true;
                }
            }
            currentPage = ed.m_stringData;
        }
        else if (ed.m_event == "AppEnd")
        {
            abortRun = false;
        }
    }
}


void EventModel::updateFluoroTransforms(const QString scanUuid,
                                        const QString drbUuid,
                                        const QString fluoroTrackerUuid,
                                        const QMatrix4x4& image_X_Fixture,
                                        const QMatrix4x4& fluoroTracker_X_drb,
                                        const QMatrix4x4& fixture_X_Image_1,
                                        const QMatrix4x4& fixture_X_Image_2)
{
    TransformationManagerSingleton::Instance()->removeReferencedXforms(
        scanUuid);

    //  Image_X_FluoroTracker
    TransformationObject* t1 = new TransformationObject();
    t1->setMetaData(TransformationObject::Computed, TransformationObject::Image,
                    scanUuid, TransformationObject::ROM, fluoroTrackerUuid);
    t1->setMatrix(image_X_Fixture);
    t1->setInvertible(false);
    TransformationManagerSingleton::Instance()->registerXform(t1);

    //  Image_X_DRB
    TransformationObject* t2 = new TransformationObject();
    t2->setMetaData(TransformationObject::Computed, TransformationObject::Image,
                    scanUuid, TransformationObject::ROM, drbUuid);
    t2->setMatrix(image_X_Fixture * fluoroTracker_X_drb);
    t2->setInvertible(false);
    TransformationManagerSingleton::Instance()->registerXform(t2);

    //  DRB_X_Image (1)
    QMatrix4x4 drb_X_fluoroTracker = fluoroTracker_X_drb.inverted();
    TransformationObject* t3 = new TransformationObject();
    t3->setMetaData(TransformationObject::Computed, TransformationObject::ROM,
                    drbUuid, TransformationObject::Image, scanUuid);
    t3->setMatrix(drb_X_fluoroTracker * fixture_X_Image_1);
    t3->setInvertible(false);
    TransformationManagerSingleton::Instance()->registerXform(t3);

    //  DRB_X_Image (2)
    TransformationObject* t4 = new TransformationObject();
    t4->setMetaData(TransformationObject::Computed, TransformationObject::ROM,
                    drbUuid, TransformationObject::Image, scanUuid);
    t4->setMatrix(drb_X_fluoroTracker * fixture_X_Image_2);
    t4->setInvertible(false);
    TransformationManagerSingleton::Instance()->registerXform(t4);
}


bool EventModel::updateTransformWithPickedPnts(
    const QString studyUuid,
    const QString scanUuid[2],
    const QString& fluoroTrackerUuid,
    const QString& drbUuid,
    const QMap<QString, QMatrix4x4>& fluoroTracker_X_DrbMap)
{
    Tracking::TrackerManager* trkManager =
        Tracking::TrackerManagerSingleton::Instance();

    FluoroRegistration fluoroRegistration;
    Tracking::FluoroTracker* fluoroTracker =
        qobject_cast<Tracking::FluoroTracker*>(
            trkManager->tracker(fluoroTrackerUuid));
    fluoroRegistration.setFixture(fluoroTracker->orientation_markers_rom(),
                                  fluoroTracker->registration_markers_rom(),
                                  fluoroTracker->grid_markers_rom());
    fluoroRegistration.setUseRMSToEvaluateRegistration(false);

    QSqlDatabase db = QSqlDatabase::database(EpicDbHelper::connectionName());

    for (int idx = 0; idx < 2; idx++)
    {
        fluoroRegistration.setImage(
            EpicDbHelper::getLatestImageData("CapturedImage", scanUuid[idx]));

        QString qS(
            "SELECT * FROM pickpoints WHERE scan_uuid='%1' AND "
            "pick_status='good'");
        qS = qS.arg(scanUuid[idx]);
        QSqlQuery q(qS, db);

        QList<QVector2D> gridPoints;
        QList<QVector2D> lmkPoints;
        while (q.next())
        {
            QVector2D pickedPnt =
                QVector2D(q.value("x").toFloat(), q.value("y").toFloat());
            if (q.value("landmark_type").toString().trimmed() == "Grid")
            {
                gridPoints += pickedPnt;
            }
            else
                lmkPoints += pickedPnt;
        }

        if (gridPoints.isEmpty() || lmkPoints.isEmpty())
            return false;

        fluoroRegistration.setManualGridPoints(gridPoints);
        fluoroRegistration.setManualLandmarkPoints(lmkPoints);

        fluoroRegistration.calculateRegistration();

        QMatrix4x4 image_X_Fixture = fluoroRegistration.image_X_Fixture();
        QMatrix4x4 fixture_X_Image_1 = fluoroRegistration.fixture_X_Image_1();
        QMatrix4x4 fixture_X_Image_2 = fluoroRegistration.fixture_X_Image_2();


        QString sUuid = scanUuid[idx];
        updateFluoroTransforms(sUuid, drbUuid, fluoroTrackerUuid,
                               image_X_Fixture, fluoroTracker_X_DrbMap[sUuid],
                               fixture_X_Image_1, fixture_X_Image_2);
    }

    return true;
}

bool EventModel::updateTransformWithAlgorithm(
    const QString studyUuid,
    const QString scanUuid[2],
    const QString& fluoroTrackerUuid,
    const QString& drbUuid,
    const QMap<QString, QMatrix4x4>& fluoroTracker_X_DrbMap)
{
    QList<QList<QVector3D>> objectPointsMultiAngles;
    QList<QList<QVector3D>> imagePointsMultiAngles;

    FluoroRegistration fluoroRegistration;
    Tracking::TrackerManager* trkManager =
        Tracking::TrackerManagerSingleton::Instance();

    Tracking::FluoroTracker* fluoroTracker =
        qobject_cast<Tracking::FluoroTracker*>(
            trkManager->tracker(fluoroTrackerUuid));
    fluoroRegistration.setFixture(fluoroTracker->orientation_markers_rom(),
                                  fluoroTracker->registration_markers_rom(),
                                  fluoroTracker->grid_markers_rom());
    fluoroRegistration.setUseRMSToEvaluateRegistration(false);

    for (int idx = 0; idx < 2; idx++)
    {
        fluoroRegistration.displayDebug(QString("C:/temp/event_") + studyUuid +
                                        (idx ? "_LAT" : "_AP"));
        fluoroRegistration.setImage(
            EpicDbHelper::getLatestImageData("CapturedImage", scanUuid[idx]));
        bool imageFlipped = false;
        if (fluoroRegistration.autoDetect(imageFlipped) &&
            fluoroRegistration.calculateRegistration())
        {
            objectPointsMultiAngles.push_back(
                fluoroRegistration.finalUsedObjectPoints());
            imagePointsMultiAngles.push_back(
                fluoroRegistration.finalUsedImagePoints());
        }
        else
        {
            qDebug() << "************ Registration Fails";
        }
    }
    QList<QList<QMatrix4x4>> multiAnlgeFluoroRegMatrices;
    multiAnlgeFluoroRegMatrices =
        fluoroRegistration.multiAngleCameraCalibration(objectPointsMultiAngles,
                                                       imagePointsMultiAngles);

    for (int idx = 0; idx < 2; idx++)
    {
        QMatrix4x4 image_X_Fixture = multiAnlgeFluoroRegMatrices[idx][0];
        QMatrix4x4 fixture_X_Image_1 = multiAnlgeFluoroRegMatrices[idx][1];
        QMatrix4x4 fixture_X_Image_2 = multiAnlgeFluoroRegMatrices[idx][2];

        //                    QMatrix4x4 image_X_Fixture =
        //                    fluoroRegistration.image_X_Fixture(); QMatrix4x4
        //                    fixture_X_Image_1 =
        //                    fluoroRegistration.fixture_X_Image_1(); QMatrix4x4
        //                    fixture_X_Image_2 =
        //                    fluoroRegistration.fixture_X_Image_2();

        QString sUuid = scanUuid[idx];
        updateFluoroTransforms(sUuid, drbUuid, fluoroTrackerUuid,
                               image_X_Fixture, fluoroTracker_X_DrbMap[sUuid],
                               fixture_X_Image_1, fixture_X_Image_2);
    }

    return true;
}


QStringList EventModel::toolList() const
{
    QStringList toolList;
    for (const EventData& ed : m_events)
    {
        toolList += ed.m_cameraXtool.keys();
    }
    toolList.removeDuplicates();
    return toolList;
}
