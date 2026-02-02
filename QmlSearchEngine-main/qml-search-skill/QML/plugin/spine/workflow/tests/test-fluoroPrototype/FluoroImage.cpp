#include "FluoroImage.h"
#include <QSettings>
#include <QtMath>
#include <tracking/TransformationObject.h>
#include <tracking/TransformationManager.h>
#include <algorithms/GMedMath.h>
#include <QTest>

FluoroImage::FluoroImage(QObject* parent)
    : QObject(parent)
    , m_ringControlPnts_img(NUMBER_RING_CNTR_PNTS * 2)
    , m_fluoroReg(new FluoroRegistration())
{
    m_ringControlPnts_img[0] = QVector2D(500, 0);
    m_ringControlPnts_img[1] = QVector2D(100, 0);
    m_ringControlPnts_img[2] = QVector2D(0, 100);
    m_ringControlPnts_img[3] = QVector2D(0, 500);
    m_ringControlPnts_img[4] = QVector2D(441.42f, 441.42f);

    m_ringControlPnts_img[5] = QVector2D(500, 0);
    m_ringControlPnts_img[6] = QVector2D(100, 0);
    m_ringControlPnts_img[7] = QVector2D(0, 100);
    m_ringControlPnts_img[8] = QVector2D(0, 500);
    m_ringControlPnts_img[9] = QVector2D(441.42f, 441.42f);
}

FluoroImage::~FluoroImage()
{
    delete m_fluoroReg;
    m_fluoroReg = NULL;
}

QMatrix4x4 stringListToMatrix(const QStringList& sList)
{
    QMatrix4x4 mat;

    if (sList.count() == 16)
    {
        float* mData = mat.data();
        for (int i = 0; i < 16; i++)
        {
            mData[i] = sList[i].toFloat();
        }

        //  mat = mat.transposed();
    }
    else
    {
        qDebug() << "Not enough points to construct matrix" << sList.count();
    }

    return mat;
}

void FluoroImage::load(const QString& imgF, const QString& setF)
{
    Q_UNUSED(setF)
    Q_UNUSED(imgF)
    /*    m_settingsFile = setF;

        QSettings qSettings(setF, QSettings::IniFormat);
        m_uuid = qSettings.value("uuid","Unset").toString();

        m_image = QImage(imgF);

        m_fluoroReg->setImage(m_image);
        if(m_uuid == "LatImage")
            m_fluoroReg->setImageType(FluoroRegistration::FluoroImageLat);
        else if(m_uuid == "APImage")
            m_fluoroReg->setImageType(FluoroRegistration::FluoroImageAP);
        else
            qDebug() << "Image Type not found";

        int sz = qSettings.beginReadArray("Rings");
        for(int i=0;i<sz;i++)
        {
            qSettings.setArrayIndex(i);
            QStringList st = qSettings.value("point").toStringList();
            m_ringControlPnts_img[i] =
       QVector2D(st[0].toFloat(),st[1].toFloat());
        }
        qSettings.endArray();


        mFidLandmarks_fig.clear();
        sz = qSettings.beginReadArray("FiducialLandMarks");
        for(int i=0;i<sz;i++)
        {
            qSettings.setArrayIndex(i);
            QStringList st = qSettings.value("point").toStringList();
            mFidLandmarks_fig +=
       QVector3D(st[0].toFloat(),st[1].toFloat(),st[2].toFloat());
        }
        qSettings.endArray();

        QStringList img_X_fixture =
       qSettings.value("img_X_fixture").toStringList(); QStringList
       fixture1_X_img = qSettings.value("fixture1_X_img").toStringList();
        QStringList fixture2_X_img =
       qSettings.value("fixture2_X_img").toStringList(); if(img_X_fixture.size()
       == 16 && fixture1_X_img.size() == 16 && fixture1_X_img.size() == 16 )
        {
            for(int i=0;i<16;i++)
            {
                m_img_T_fixture.data()[i] = img_X_fixture[i].toFloat();
                m_wFixture1_T_img.data()[i] = fixture1_X_img[i].toFloat();
                m_wFixture2_T_img.data()[i] = fixture2_X_img[i].toFloat();
            }
        }

        m_fixtureUuid = qSettings.value("fluoro_fixture","Unset
       fixture").toString(); m_drbUuid = qSettings.value("active_drb","Unset
       drb").toString();

        //
        QStringList fixRom_X_drbRom_str =
       qSettings.value("fixRom_X_drbRom").toStringList();
        if(fixRom_X_drbRom_str.size() == 16)
        {
            TransformationObject *fixRom_X_drbRom =
       TransformationManagerSingleton::Instance()->transform(
                            TransformationObject::ROM,m_fixtureUuid,TransformationObject::ROM,m_drbUuid);

            QMatrix4x4 mat;
            for(int i=0;i<16;i++)
            {
                mat.data()[i] = fixRom_X_drbRom_str[i].toFloat();
            }
            fixRom_X_drbRom->setType(TransformationObject::Computed);
            fixRom_X_drbRom->setMatrix(mat);
            fixRom_X_drbRom->setValid(true);
            fixRom_X_drbRom->setWeight(1.0);
            TransformationManagerSingleton::Instance()->resetReferencedXforms();
        }

        //-------------------------------------------------------------------------
        // LandMarks
        //-------------------------------------------------------------------------
        QString landFile = QFINDTESTDATA("Data/landmarks.ini");
        QSettings landmarkSettings(landFile, QSettings::IniFormat);
        m_landmarksRomUuid = landmarkSettings.value("rom_uuid","").toString();
        if(!m_landmarksRomUuid.isEmpty())
        {
            QStringList quat =
       landmarkSettings.value("rom_R_fixture").toStringList(); QStringList trans
       = landmarkSettings.value("rom_T_fixture").toStringList();

            QMatrix4x4 mat = GMedMath::xform(
                        QQuaternion(quat[0].toFloat(),quat[1].toFloat(),quat[2].toFloat(),quat[3].toFloat()),
                        QVector3D(trans[0].toFloat(),trans[1].toFloat(),trans[2].toFloat()));


            sz = landmarkSettings.beginReadArray("Landmarks");
            for(int i=0;i<sz;i++)
            {
                landmarkSettings.setArrayIndex(i);
                QStringList st = landmarkSettings.value("point").toStringList();
                QVector3D pnt =
       QVector3D(st[0].toFloat(),st[1].toFloat(),st[2].toFloat());

                pnt = mat * pnt;

                m_genericLandmarks += pnt;
            }
            landmarkSettings.endArray();

        }
        //-------------------------------------------------------------------------
        updateRings();
        updateTransformManager();
        */
}

void FluoroImage::imgToFixture(const QVector2D& imgPt, GmLine& fixLine)
{
    QVector4D p_wFixture1 = m_wFixture1_T_img * QVector4D(imgPt, 0, 1);
    QVector3D fixtureP0 = p_wFixture1.toVector3DAffine();

    QVector4D p_wFixture2 = m_wFixture2_T_img * QVector4D(imgPt, 0, 1);
    QVector3D fixtureP1 = p_wFixture2.toVector3DAffine();

    fixLine.setLine(fixtureP0, fixtureP1);
}

QVariantList FluoroImage::imgToFixture(const QVector2D& pImg)
{
    QVariantList vec;

    GmLine ln;

    imgToFixture(pImg, ln);

    vec += ln.p1();
    vec += ln.p2();
    return vec;
}

QVector2D FluoroImage::fixtureToImg(const QVector3D& pnt)
{
    QVector4D p4d = QVector4D(pnt, 1);

    QVector4D pImg = m_img_T_fixture * p4d;

    QVector4D pout = pImg / pImg.w();

    return pout.toVector2D();
}

void FluoroImage::updateRings()
{
    /*
    m_fluoroReg->setManualRegistrationPoints(0,
            m_ringControlPnts_img[0],
            m_ringControlPnts_img[1],
            m_ringControlPnts_img[2],
            m_ringControlPnts_img[3],
            m_ringControlPnts_img[4]);

    m_fluoroReg->setManualRegistrationPoints(1,
            m_ringControlPnts_img[5],
            m_ringControlPnts_img[6],
            m_ringControlPnts_img[7],
            m_ringControlPnts_img[8],
            m_ringControlPnts_img[9]);

    QSettings qSettings(m_settingsFile, QSettings::IniFormat);
    qSettings.beginWriteArray("Rings");

    int i=0;
    for (const QVector2D &vec : m_ringControlPnts_img)
    {
        qSettings.setArrayIndex(i);
        QStringList st;
        st += QString::number(vec.x());
        st += QString::number(vec.y());

        qSettings.setValue("point",st);
        i++;
    }
    qSettings.endArray();
*/
    Q_EMIT ringsChanged();
}

void FluoroImage::updateTransformManager()
{
    TransformationObject* img_X_fixture =
        TransformationManagerSingleton::Instance()->transform(
            TransformationObject::Image, m_uuid, TransformationObject::CAD,
            m_fixtureUuid);

    img_X_fixture->setType(TransformationObject::Computed);
    img_X_fixture->setInvertible(false);
    img_X_fixture->setMatrix(m_img_T_fixture);
    img_X_fixture->setValid(true);
    img_X_fixture->setWeight(10.0);

    TransformationManagerSingleton::Instance()->resetReferencedXforms();
}

void FluoroImage::setRingControlPnt(int ring, int idx, const QVector2D pnt)
{
    m_ringControlPnts_img[ring * NUMBER_RING_CNTR_PNTS + idx] = pnt;
    updateRings();
}

void FluoroImage::captureFixtureXdrb()
{
    TransformationObject* fixRom_X_drbRom =
        TransformationManagerSingleton::Instance()->transform(
            TransformationObject::ROM, m_fixtureUuid, TransformationObject::ROM,
            m_drbUuid);

    QSettings qSettings(m_settingsFile, QSettings::IniFormat);
    if (fixRom_X_drbRom->valid())
    {
        fixRom_X_drbRom->setType(TransformationObject::Computed);
        TransformationManagerSingleton::Instance()->resetReferencedXforms();


        QStringList fixRom_X_drbRom_str;
        QMatrix4x4 mat = fixRom_X_drbRom->matrix();
        for (int i = 0; i < 16; i++)
        {
            fixRom_X_drbRom_str += QString::number(mat.data()[i]);
        }
        qSettings.setValue("fixRom_X_drbRom", fixRom_X_drbRom_str);
    }
    else
    {
        TransformationManagerSingleton::Instance()->removeReferencedXforms(
            fixRom_X_drbRom->uuid());
        qSettings.remove("fixRom_X_drbRom");
    }
}


QVariantList FluoroImage::ringEllipse(int ring)
{
    Q_UNUSED(ring)
    //    DetectedRing dr = m_fluoroReg->detectedRing(ring);

    QVariantList vl;

    //    vl += dr.eCenter;
    //    vl += dr.eMajorDia;
    //    vl += dr.eMinorDia;
    //    vl += dr.ePhi; //qRadiansToDegrees(dr.ePhi);

    return vl;
}

void FluoroImage::calculateRingRegistration()
{
    qDebug() << "Start FluoroImage::calculateRingRegistration()" << m_uuid;
    m_fluoroReg->calculateRegistration();
    qDebug() << "End FluoroImage::calculateRingRegistration()" << m_uuid;

    m_img_T_fixture = m_fluoroReg->image_X_Fixture();
    m_wFixture1_T_img = m_fluoroReg->fixture_X_Image_1();
    m_wFixture2_T_img = m_fluoroReg->fixture_X_Image_2();

    QSettings qSettings(m_settingsFile, QSettings::IniFormat);

    QStringList img_X_fixture, fixture1_X_img, fixture2_X_img;
    for (int i = 0; i < 16; i++)
    {
        img_X_fixture += QString::number(m_img_T_fixture.data()[i]);
        fixture1_X_img += QString::number(m_wFixture1_T_img.data()[i]);
        fixture2_X_img += QString::number(m_wFixture2_T_img.data()[i]);
    }
    qSettings.setValue("img_X_fixture", img_X_fixture);
    qSettings.setValue("fixture1_X_img", fixture1_X_img);
    qSettings.setValue("fixture2_X_img", fixture2_X_img);


    updateTransformManager();
}
