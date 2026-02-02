#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtDebug>
#include <QDir>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    qDebug() << "Current Directory:" << QDir::currentPath();

    QQmlApplicationEngine engine;
    engine.load(QUrl("qml/test-layouteditor.qml"));

    return app.exec();
}
