#include <QGuiApplication>
#include <QDir>
#include "TestManipulator.h"
#include <QtQml>

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);
    app.addLibraryPath(QCoreApplication::applicationDirPath() + QDir::separator() + "plugins");

    qmlRegisterType<TestManipulator>("EpicQmlComponents", 1, 0, "TestManipulator");

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/qml/manipMain.qml"));

    return app.exec();
}
