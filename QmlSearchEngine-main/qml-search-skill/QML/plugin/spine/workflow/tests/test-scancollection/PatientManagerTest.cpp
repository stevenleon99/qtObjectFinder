#include "PatientManagerTest.h"

#include <epicdb/EpicDbHelper.h>
#include <QtDebug>
#include <QFileDialog>
#include <QTcpSocket>
#include <QHostAddress>
#include <libQJsonRPC/qjsonrpcservicereply.h>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QHeaderView>
#include <QDir>
#include <QDateTime>
#include <epicfovia/TransferFunctionManager.h>
#include <QMetaObject>
#include <QMetaEnum>

PatientManager::PatientManager(QObject* parent)
    : QObject(parent)
    , m_jsonRpcService(NULL)
    , m_patientModel(new ScanCollectionModel(this))
    , m_itemToLoadCount(0)
    , m_usbStatus(USB_DISCONNECTED)
{
    EpicDbHelper::initializeDb();
    QSqlDatabase db = QSqlDatabase::database(EpicDbHelper::connectionName());


    db.driver()->subscribeToNotification("new_scan");
    db.driver()->subscribeToNotification("update_scan");
    connect(
        db.driver(),
        SIGNAL(notification(QString, QSqlDriver::NotificationSource, QVariant)),
        this,
        SLOT(notification(QString, QSqlDriver::NotificationSource, QVariant)));

    m_jsonRpcService = new GmQJsonRpcService();
    m_jsonRpcService->setObjectName("GPSClientControllerSocket");

    QObject::connect(m_jsonRpcService, &GmQJsonRpcService::messageReceived,
                     this, &PatientManager::dataIoMessageReceived);
    QObject::connect(m_jsonRpcService, &GmQJsonRpcService::isConnectedChanged,
                     this, &PatientManager::connectStateChanged);


    //    QJsonRpcMessage reply =
    //    m_client->invokeRemoteMethodBlocking("DataManagement.newPatients");
    //    m_newPatientList = reply.result().toVariant().toList();
    //    Q_EMIT newPatientListChanged(m_newPatientList);
}

PatientManager::~PatientManager() {}

void PatientManager::connectStateChanged()
{
    if (m_jsonRpcService->socket()->state() == QAbstractSocket::ConnectedState)
    {
        QJsonRpcMessage jsonMsg;
        QMetaObject::invokeMethod(m_jsonRpcService,
                                  "invokeRemoteMethodBlocking",
                                  Qt::BlockingQueuedConnection,
                                  Q_RETURN_ARG(QJsonRpcMessage, jsonMsg),
                                  Q_ARG(QString, "DataManagement.newPatients"));
        m_newPatientList = jsonMsg.result().toVariant().toList();
        Q_EMIT newPatientListChanged(m_newPatientList);
    }
    else
    {
        setUsbStatus(USB_DISCONNECTED);
    }
}


bool PatientManager::connectAndInitialize(const QString& host)
{
    // Initialize Model From Database
    m_patientModel->loadFromDb();

    // Start Connection to DataIoManager
    m_jsonRpcService->setServer(host, 6650);
    m_jsonRpcService->setRunningFrequency(5000);
    m_jsonRpcService->setStartupFrequency(5000);
    m_jsonRpcService->start();

    return true;
}


void PatientManager::scanDirectory(const QString& scandir)
{
    if (!scandir.isEmpty())
    {
        QUrl dirName(scandir);

        QJsonRpcServiceReply* reply;
        QMetaObject::invokeMethod(
            m_jsonRpcService, "invokeRemoteMethod",
            Qt::BlockingQueuedConnection,
            Q_RETURN_ARG(QJsonRpcServiceReply*, reply),
            Q_ARG(QString, "DataManagement.overrideUSBtoDirectory"),
            Q_ARG(QVariant, dirName.toLocalFile()));
        qDebug() << reply;
        reply->deleteLater();
    }
}

void PatientManager::notification(const QString& name,
                                  QSqlDriver::NotificationSource ns,
                                  const QVariant& payload)
{
    if ("new_scan" == name)
    {
        QString scanId = payload.toString();
        if (!scanId.isEmpty())
        {
            //            m_patientModel->addScanFromDb(scanId);
        }
    }
    else if ("update_scan" == name && ns != QSqlDriver::SelfSource)
    {
        qDebug() << "Database Update:" << name << payload.toString();
    }
}

void PatientManager::dataIoMessageReceived(const QJsonRpcMessage& message)
{
    if (message.type() != QJsonRpcMessage::Notification)
        return;

    QJsonObject val = message.params().toObject();
    QVariantMap vMap = val.toVariantMap();

    if (message.method() == "DicomImport.itemToLoadCount")
    {
        setItemToLoadCount(vMap["loadCnt"].toInt());
    }
    else if (message.method() == "DicomImport.newPatientScanEntryCount")
    {
        qDebug() << message.method() << vMap;

        for (int i = 0; i < m_newPatientList.size(); ++i)
        {
            QVariantMap vm = m_newPatientList[i].toMap();
            if (vm["uuid"].toString() == vMap.keys().first())
            {
                vm["entryCount"] = vMap[vMap.keys().first()].toInt();
                m_newPatientList[i] = vm;
                Q_EMIT newPatientListChanged(m_newPatientList);
            }
        }
    }
    else if (message.method() == "DicomImport.clearNewPatientList")
    {
        m_newPatientList.clear();
        Q_EMIT newPatientListChanged(m_newPatientList);
    }
    else if (message.method() == "DicomImport.newPatient")
    {
        m_newPatientList += vMap;
        Q_EMIT newPatientListChanged(m_newPatientList);
    }
    else if (message.method() == "DicomImport.usbStatus")
    {
        QMetaEnum metaEnum = PatientManager::staticMetaObject.enumerator(
            PatientManager::staticMetaObject.indexOfEnumerator("UsbStatus"));
        Q_ASSERT(metaEnum.isValid());
        setUsbStatus(static_cast<PatientManager::UsbStatus>(
            metaEnum.keyToValue(vMap["status"].toString().toLatin1())));
    }
}

void PatientManager::addPatientToDb(const QString& uuid)
{
    QJsonRpcMessage jsonMsg;
    QMetaObject::invokeMethod(
        m_jsonRpcService, "invokeRemoteMethodBlocking",
        Qt::BlockingQueuedConnection, Q_RETURN_ARG(QJsonRpcMessage, jsonMsg),
        Q_ARG(QString, "DataManagement.addPatient"), Q_ARG(QVariant, uuid));


    for (int i = 0; i < m_newPatientList.size(); i++)
    {
        QVariantMap vm = m_newPatientList[i].toMap();
        if (vm["uuid"] == uuid)
        {
            m_newPatientList.removeAt(i);
            Q_EMIT newPatientListChanged(m_newPatientList);
            return;
        }
    }
}

void PatientManager::setUsbStatus(UsbStatus arg)
{
    if (m_usbStatus == arg)
        return;

    m_usbStatus = arg;

    if (m_usbStatus == NO_DISK || m_usbStatus == USB_DISCONNECTED)
    {
        m_newPatientList.clear();
        Q_EMIT newPatientListChanged(m_newPatientList);
    }

    emit usbStatusChanged(arg);
}
void PatientManager::enableUSB()
{
    QJsonRpcServiceReply* reply;
    QMetaObject::invokeMethod(m_jsonRpcService, "invokeRemoteMethod",
                              Qt::BlockingQueuedConnection,
                              Q_RETURN_ARG(QJsonRpcServiceReply*, reply),
                              Q_ARG(QString, "DataManagement.enableUSB"));
    reply->deleteLater();
}

QString PatientManager::activePatientName() const
{
    if (!m_activePatientKey.isEmpty())
    {
        QModelIndex mIdx = m_patientModel->indexByUid(m_activePatientKey);
        if (mIdx.isValid())
        {
            QString firstName =
                m_patientModel->data(mIdx, ScanCollectionItem::FirstNameRole)
                    .toString();
            QString lastName =
                m_patientModel->data(mIdx, ScanCollectionItem::LastNameRole)
                    .toString();

            return firstName.trimmed() + lastName.trimmed();
        }
    }

    return QString("< Patient Not Loaded >");
}


void PatientManager::setActiveScanKey(QString activeScanKey)
{
    if (m_activeScanKey == activeScanKey)
    {
        EsElapsedTime("Loading Patient");

        QSqlDatabase db =
            QSqlDatabase::database(EpicDbHelper::connectionName());
        //
        //  Load last patient key from datamodel
        //
        if (!activeScanKey.isEmpty())
        {
            QString scanQ(
                "SELECT patient_uuid from Scan where scan_uuid = '%1'");
            scanQ = scanQ.arg(activeScanKey);
            QSqlQuery qFid(scanQ, db);
            if (qFid.next())
            {
                m_activePatientKey = qFid.value(0).toString();
            }
        }
        //
        //  Load Scan into Fovia
        //
        QString scanQ("SELECT file_uuid from Scan where scan_uuid = '%1'");
        scanQ = scanQ.arg(activeScanKey);
        QSqlQuery qFid(scanQ, db);
        QString fileUuid;
        if (qFid.next())
        {
            fileUuid = qFid.value(0).toString();
        }
        // Temp db Fix....
        QString examQ(
            "SELECT path, file_name from DataFile where file_uuid = '%1'");
        examQ = examQ.arg(fileUuid);
        QSqlQuery q0(examQ, db);
        if (q0.size() != 1)
            return;
        q0.next();
        QString dFile = q0.value(0).toString().trimmed() + QDir::separator() +
                        q0.value(1).toString().trimmed();

        Q_UNUSED(dFile)
        //        {
        //            EsElapsedTime("Loading DICOM");
        //            if (dFile.isEmpty() ||
        //            !FoviaClientSingleton::Instance()->OpenDICOMFolderOnServer(dFile))
        //            {
        //                qDebug() << "Failed to Load Dicom:" << dFile;
        //            }
        //        }

        m_activeScanKey = activeScanKey;

        EpicDbHelper::updateLiveSettings("ActiveScan", m_activeScanKey);

        Q_EMIT activeScanKeyChanged(activeScanKey);
    }
}
