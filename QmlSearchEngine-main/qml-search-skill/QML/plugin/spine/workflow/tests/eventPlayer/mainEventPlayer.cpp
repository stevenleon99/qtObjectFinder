// Suppress all lint warnings for this test code.  Restore at end of this file.
// lint -save -e*
#include "AppController.h"
#include <QApplication>
#include <QDir>
#include <QMessageBox>
#include <QSettings>
#include <epicdb/EpicDbHelper.h>
#include "EventModel.h"
#include <tracking/TrackerManager.h>

/**
 * \defgroup eventplayer eventplayer
 * \ingroup TestCode
 * \brief \b eventplayer.exe: Utility for playing back events from db with
 * different algorithms parameters Code mainly in
 * gps-client/testcode/eventplayer subdirectory.
 */

int main(int argc, char* argv[])
{
    QApplication a(argc, argv);
    qApp->addLibraryPath(QCoreApplication::applicationDirPath() +
                         QDir::separator() + "plugins");

    EpicDbHelper::initializeDb();

    EventModel* eventModel = new EventModel(&a);
    eventModel->loadEvents();

    QStringList toolList = eventModel->toolList();
    qDebug().noquote() << toolList.join(";");
    Tracking::TrackerManager* trkManager =
        Tracking::TrackerManagerSingleton::Instance();
    trkManager->loadTrackers(toolList);

    eventModel->fluoroAccuracy();
}

// lint -restore
