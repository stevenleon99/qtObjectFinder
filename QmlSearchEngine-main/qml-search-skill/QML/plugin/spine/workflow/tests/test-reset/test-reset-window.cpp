#include "test-reset-window.h"
#include "ui_test-reset-window.h"

#include <QApplication>
#include <QMessageBox>
#include <QDebug>
#include <QThread>
#include <QVector>
#include <QSettings>
#include <QString>

#include <utilities/ConfigSettings.h>

#include "WindowsProcesses.h"

MainWindow::MainWindow(QWidget* parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    setCentralWidget(ui->statusDisplay);
    ui->statusDisplay->setReadOnly(true);
    m_processNames << "gps-controller.exe"
                   << "gps-fluoro-capture.exe"
                   << "dataiomanager.exe";

    QSettings qSettings(ConfigSettings::configFileLocation(),
                        QSettings::IniFormat);
    QString fServer = qSettings.value("Server", "localhost").toString();

    m_pResetManager = new ResetManager(this);
    m_pResetManager->connectToRpcServer(fServer.toLocal8Bit());
}

MainWindow::~MainWindow()
{
    delete ui;
    delete m_pResetManager;
}

bool MainWindow::checkForService()
{
    if (::WindowsProcesses::findProcessId("watchdogService.exe") == -1)
    {
        QMessageBox::warning(NULL, "Cannot continue",
                             "Watchdog Service Must Be Alive");
        return false;
    }

    return true;
}

QList<qint64> MainWindow::processIds()
{
    QList<qint64> pIds;

    for (auto pName : m_processNames)
    {
        pIds << ::WindowsProcesses::findProcessId(pName);
    }

    return pIds;
}

void MainWindow::on_actionExit_triggered()
{
    QApplication::quit();
}

void MainWindow::on_actionSoftware_triggered()
{
    bool pass = true;

    if (checkForService())
    {
        QList<qint64> originalPids = processIds();
        ui->statusDisplay->insertPlainText(
            "\nShutting down and restarting components\n");
        m_pResetManager->resetSoftware(false);
        QThread::msleep(2000);
        QList<qint64> newPids = processIds();
        for (int i = 0; i < originalPids.size(); i++)
        {
            QString displayMsg;
            displayMsg = QString("<b>%1</b> original pid %2 new %3\n")
                             .arg(m_processNames.at(i))
                             .arg(originalPids.at(i))
                             .arg(newPids.at(i));
            ui->statusDisplay->appendHtml(displayMsg);

            if ((originalPids.at(i) == newPids.at(i)) || (newPids.at(i) == -1))
            {
                QString msg = QString("Process %1 failed to restart")
                                  .arg(originalPids.at(i));
                QMessageBox::information(this, "fail", msg);
                ;
                pass = false;
            }
        }

        if (pass)
        {
            QMessageBox::information(this, "Pass", "All processes restarted");
        }
    }
    else
        QApplication::exit(-1);
}

void MainWindow::on_actionSystem_triggered()
{
    ui->statusDisplay->insertPlainText("About to reboot the system...\n");
    // You'll know if this works, it causes a reboot.
    if (checkForService())
        m_pResetManager->resetSystem(false);
    else
        QApplication::exit(-1);
}

void MainWindow::on_actionSystem_with_GMAS_triggered()
{
    ui->statusDisplay->insertPlainText("About to reboot the system...\n");
    if (checkForService())
        m_pResetManager->resetSystem(true);
    else
        QApplication::exit(-1);
}

void MainWindow::on_actionSoftware_with_GMAS_triggered()
{
    bool pass = true;
    if (checkForService())
    {
        ui->statusDisplay->insertPlainText(
            "\nResetting components and GMAS, this may take a while...\n");
        QApplication::processEvents();
        QList<qint64> originalPids = processIds();

        m_pResetManager->resetSoftware(true);
        QThread::msleep(2000);
        QList<qint64> newPids = processIds();
        for (int i = 0; i < originalPids.size(); i++)
        {
            QString displayMsg;
            displayMsg = QString("<b>%1</b> original pid %2 new %3\n")
                             .arg(m_processNames.at(i))
                             .arg(originalPids.at(i))
                             .arg(newPids.at(i));
            ui->statusDisplay->appendHtml(displayMsg);

            if ((originalPids.at(i) == newPids.at(i)) || (newPids.at(i) == -1))
            {
                QString msg = QString("Process %1 failed to restart")
                                  .arg(originalPids.at(i));
                QMessageBox::information(this, "fail", msg);
                ;
                pass = false;
            }
        }

        if (pass)
        {
            QMessageBox::information(this, "Pass", "All processes restarted");
        }
    }
    else
        QApplication::exit(-1);
}
