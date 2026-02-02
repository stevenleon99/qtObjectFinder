#include "FpTracking.h"
#include "FluoroImage.h"
#include "FluoroManager.h"

#include <QTest>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>

#include <epicdb/EpicDbHelper.h>
#include <tracking/TransformationManager.h>
#include <tracking/TransformationObject.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<cranial::managers::TransformationObject>("EpicQmlComponents", 1, 0,
                                                             "CoordinateSystems");

    EpicDbHelper::initializeDb();

    FluoroManager *fluoroImageMgr = new FluoroManager;

    QString apImg = QFINDTESTDATA("Data/ap.png");
    QString apConf = QFINDTESTDATA("Data/ap.ini");
    QString latImg = QFINDTESTDATA("Data/lat.png");
    QString latConf = QFINDTESTDATA("Data/lat.ini");

    FluoroImage *apFI = new FluoroImage;
    apFI->load(apImg,apConf);
    fluoroImageMgr->registerImage(apFI);

    FluoroImage *latFI = new FluoroImage;
    latFI->load(latImg,latConf);
    fluoroImageMgr->registerImage(latFI);

    engine.addImageProvider(QLatin1String("FluoroImage"),fluoroImageMgr);


    FpTracking *tracking = new FpTracking();

    engine.rootContext()->setContextProperty("fluoroMgr", fluoroImageMgr);
    engine.rootContext()->setContextProperty("trackingMgr", tracking);
    engine.rootContext()->setContextProperty("transformManager",TransformationManagerSingleton::Instance());
    engine.rootContext()->setContextProperty("tracking", tracking);

    engine.load(QUrl("qrc:/fluoro/fpMain.qml"));

    fluoroImageMgr->initialize();
    tracking->connect("localhost");


    return app.exec();
}
