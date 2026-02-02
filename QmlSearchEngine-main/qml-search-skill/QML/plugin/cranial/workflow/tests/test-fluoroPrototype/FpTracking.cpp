#include "FpTracking.h"
#include <tracking/TransformationManager.h>
#include <tracking/TrackingFrame.h>
#include <tracking/TrackerManager.h>
#include <qtest.h>
#include <QSettings>

FpTracking::FpTracking(QObject *parent) : QObject(parent)
{
    m_socket = new QTcpSocket(this);
    QObject::connect(m_socket,&QTcpSocket::stateChanged,this,&FpTracking::tcpStateChanged);

    m_client = new QJsonRpcSocket(m_socket, this);
    QObject::connect(m_client, &QJsonRpcSocket::messageReceived , this, &FpTracking::messageReceived);


    Tracking::TrackerManagerSingleton::Instance()->setInstrumentSet("default");

}

FpTracking::~FpTracking()
{

}

void FpTracking::connect(const QString &server)
{
    if(m_socket->state() == QAbstractSocket::UnconnectedState)
    {
        m_socket->connectToHost(server, 7778);
        if (!m_socket->waitForConnected(1000)) {
            qDebug() << "Trouble connecting to gps-controller: " << m_socket->errorString();
        }

        // Create Database...

    }
}

void FpTracking::disconnect()
{
    m_socket->close();

}

void FpTracking::messageReceived(const QJsonRpcMessage &message)
{
    if(message.type() != QJsonRpcMessage::Notification)
        return;

    QJsonObject val = message.params().toObject();

    Tracking::TrackingFrame frame;
    QVariantMap vMap = val.toVariantMap();
    frame.setFrame(vMap);

    QStringList keys = frame.elements();
    for (const QString &key : keys)
    {
        Tracking::ReferenceElement &trkElement = frame.referenceElement(key);
        Tracking::Tracker *trkr = Tracking::TrackerManagerSingleton::Instance()->tracker(key);

        if(trkr)
        {
            QString xfmKey = trkr->camera_X_rom_uuid();
            TransformationObject *camera_X_rom = TransformationManagerSingleton::Instance()->transform(xfmKey);
            bool displayed = trkElement.elementStatus() == TrackingEnums::Visible || trkElement.elementStatus() == TrackingEnums::PartialView;
            trkr->setAccuracyStatus(trkElement.accCheckStatus());

            if(!displayed && camera_X_rom)
            {
                TransformationManagerSingleton::Instance()->removeReferencedXforms(xfmKey);
            }
            else if(trkElement.elementStatus() == TrackingEnums::Disabled && camera_X_rom)
            {
                TransformationManagerSingleton::Instance()->removeReferencedXforms(xfmKey);
            }
            else if(displayed)
            {
                if(!camera_X_rom)
                {
                    camera_X_rom = TransformationManagerSingleton::Instance()->TransformationManager::transform(
                                TransformationObject::Camera, frame.localizerUuid(),TransformationObject::ROM,key);
                    camera_X_rom->setType(TransformationObject::Live);
                    trkr->setCamera_X_rom_uuid(camera_X_rom->uuid());
                    TransformationManagerSingleton::Instance()->resetReferencedXforms();
                }
            }
            if(camera_X_rom)
            {
                // Update Transform
                camera_X_rom->setWeight(trkElement.rmsError());
                camera_X_rom->setMatrix(trkElement.camera_X_element());
                camera_X_rom->setValid(displayed);
            }
        }
        else
        {
            qDebug() << "ERROR: Tracker not defined!!";
        }
    }

    Q_EMIT newFrame();
}

void FpTracking::tcpStateChanged(QAbstractSocket::SocketState socketState)
{
    if(socketState == QAbstractSocket::UnconnectedState)
    {
        qDebug() << "Disconnected from gps-controller";
        Q_EMIT socketDisconnected();
    }
    else if(socketState == QAbstractSocket::ConnectedState)
    {
        qDebug() << "Connected to gps-controller";
    }
}

