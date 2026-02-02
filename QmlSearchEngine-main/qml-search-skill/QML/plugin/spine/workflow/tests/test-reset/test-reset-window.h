#ifndef MAINWINDOW_H
#define MAINWINDOW_H
#include "ResetManager.h"

#include <QObject>
#include <QMainWindow>
#include <QList>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget* parent = 0);
    ~MainWindow();

private slots:
    void on_actionExit_triggered();

    void on_actionSoftware_triggered();

    void on_actionSystem_triggered();

    void on_actionSystem_with_GMAS_triggered();

    void on_actionSoftware_with_GMAS_triggered();

private:
    bool checkForService();
    QList<qint64> processIds();

private:
    Ui::MainWindow* ui;
    ResetManager* m_pResetManager;
    QStringList m_processNames;
};

#endif  // MAINWINDOW_H
