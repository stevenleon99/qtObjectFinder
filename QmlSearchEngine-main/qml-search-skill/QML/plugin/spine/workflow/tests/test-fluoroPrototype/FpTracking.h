#ifndef FPTRACKING_H
#define FPTRACKING_H

#include <QObject>
#include <QTcpSocket>
#include <libQJsonRPC/qjsonrpcmessage.h>
#include <libQJsonRPC/QJsonRpcSocket.h>

class FpTracking : public QObject
{
    Q_OBJECT
public:
    explicit FpTracking(QObject* parent = 0);
    ~FpTracking();

    bool isConnected() const { return m_socket->isOpen(); }

signals:
    void socketDisconnected();
    void newFrame();

public slots:
    void connect(const QString& server);
    void disconnect();

    void messageReceived(const QJsonRpcMessage& message);
    void tcpStateChanged(QAbstractSocket::SocketState socketState);

private:
    QTcpSocket* m_socket;
    QJsonRpcSocket* m_client;
};

#endif  // FPTRACKING_H
