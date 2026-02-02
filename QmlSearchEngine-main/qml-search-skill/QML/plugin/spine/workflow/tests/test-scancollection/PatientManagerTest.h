#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QObject>
#include <libQJsonRPC/qjsonrpcsocket.h>
#include <QSqlDriver>
#include "ScanCollectionModel.h"
#include "GmQJsonRpcService.h"

class PatientManager : public QObject
{
    Q_OBJECT
    Q_ENUMS(UsbStatus)
    Q_PROPERTY(QVariantList newPatientList READ newPatientList WRITE
                   setNewPatientList NOTIFY newPatientListChanged)
    Q_PROPERTY(int itemToLoadCount READ itemToLoadCount WRITE setItemToLoadCount
                   NOTIFY itemToLoadCountChanged)
    Q_PROPERTY(UsbStatus usbStatus READ usbStatus WRITE setUsbStatus NOTIFY
                   usbStatusChanged)
    Q_PROPERTY(
        QObject* patientModel READ patientModel NOTIFY patientModelChanged)

    Q_PROPERTY(QString activeScanKey READ activeScanKey WRITE setActiveScanKey
                   NOTIFY activeScanKeyChanged)
    Q_PROPERTY(QString activePatientKey READ activePatientKey NOTIFY
                   activeScanKeyChanged)
    Q_PROPERTY(QString activePatientName READ activePatientName NOTIFY
                   activeScanKeyChanged)


public:
    enum UsbStatus
    {
        NO_DISK,
        DISK_ACTIVE,
        DISK_IDLE,
        USB_DISABLED,
        USB_DISCONNECTED
    };

    explicit PatientManager(QObject* parent = 0);
    ~PatientManager();

    QVariantList newPatientList() const { return m_newPatientList; }

    int itemToLoadCount() const { return m_itemToLoadCount; }

    UsbStatus usbStatus() const { return m_usbStatus; }

    ScanCollectionModel* patientModel() const { return m_patientModel; }

    QString activePatientName() const;
    QString activePatientKey() const { return m_activePatientKey; }
    QString activeScanKey() const { return m_activeScanKey; }

    bool connectAndInitialize(const QString& host);

public slots:
    void scanDirectory(const QString& scandir);

    void setNewPatientList(QVariantList arg)
    {
        if (m_newPatientList == arg)
            return;

        m_newPatientList = arg;
        emit newPatientListChanged(arg);
    }

    void setItemToLoadCount(int arg)
    {
        if (m_itemToLoadCount == arg)
            return;

        m_itemToLoadCount = arg;
        emit itemToLoadCountChanged(arg);
    }

    void addPatientToDb(const QString& uuid);

    void setUsbStatus(UsbStatus arg);
    void enableUSB();

    void setActiveScanKey(QString activeScanKey);

signals:
    void newPatientListChanged(QVariantList arg);
    void itemToLoadCountChanged(int arg);

    void usbStatusChanged(UsbStatus arg);

    void patientModelChanged(QObject* patientModel);

    void activeScanKeyChanged(QString activePatientName);

private slots:
    void notification(const QString& name,
                      QSqlDriver::NotificationSource source,
                      const QVariant& payload);
    void dataIoMessageReceived(const QJsonRpcMessage&);
    void connectStateChanged();

private:
    GmQJsonRpcService* m_jsonRpcService;
    ScanCollectionModel* m_patientModel;

    QVariantList m_newPatientList;
    int m_itemToLoadCount;
    UsbStatus m_usbStatus;

    QString m_activePatientKey;
    QString m_activeScanKey;
};

#endif  // MAINWINDOW_H
