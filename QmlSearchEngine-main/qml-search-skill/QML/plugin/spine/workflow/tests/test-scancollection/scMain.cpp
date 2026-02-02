#include "PatientManagerTest.h"
#include <QApplication>
#include <QDir>
#include <QMessageBox>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "PatientManagerTest.h"
#include <QtQml>
#include "ScanCollectionItem.h"

int main(int argc, char* argv[])
{
    qRegisterMetaType<QList<QVariantMap> >("QList<QVariantMap>");


    QApplication a(argc, argv);
    qApp->addLibraryPath(QCoreApplication::applicationDirPath() +
                         QDir::separator() + "plugins");

    qmlRegisterUncreatableType<PatientManager>("GpsClient", 1, 0, "ScanManager",
                                               "Registered for Enums");
    qmlRegisterUncreatableType<ScanCollectionItem>(
        "GpsClient", 1, 0, "ScanCollectionItem",
        "Only Registered Used From ScanStatus Enum");

    PatientManager w;
    w.connectAndInitialize("localhost");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("controller", &w);
    engine.addImageProvider(QLatin1String("patientDb"), w.patientModel());


    engine.load(QUrl("qrc:/qml/test.qml"));

    return a.exec();
}
