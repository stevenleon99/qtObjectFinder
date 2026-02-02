#pragma once

#ifndef Q_MOC_RUN
#include <service/glink/node/NodeFactory.h>
#include <gos/itf/gps/IStabilizers.h>
#include <sys/config/config.h>
#endif

#include <QObject>

class DrivePageViewModel final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(DrivePage currentPage READ currentPage WRITE setCurrentPage NOTIFY currentPageChanged)
    Q_PROPERTY(QString workflowPluginName READ workflowPluginName WRITE setWorkflowPluginName NOTIFY workflowPluginNameChanged)

public:
    enum class DrivePage {
        Login = 0,
        Cases,
        Patients,
        Workflow,
        Settings
    };
    Q_ENUM(DrivePage)

    Q_INVOKABLE void goToPreviousPage();

    explicit DrivePageViewModel(QObject* parent = nullptr);

    DrivePage currentPage() const { return m_currentPage; }
    QString workflowPluginName() const { return m_workflowPluginName; }

public slots:
    void setCurrentPage(const DrivePage currentPage);
    void setWorkflowPluginName(const QString& workflowPluginName);

    void onWorkflowQuit();

signals:
    void currentPageChanged(const DrivePage currentPage);
    void workflowPluginNameChanged(const QString& workflowPluginName);

private:
    std::shared_ptr<gos::itf::gps::IStabilizers> m_stabilizersItf;
    sys::config::SystemType m_systemType = sys::config::SystemType::None;

    DrivePage m_currentPage;
    DrivePage m_previousPage;
    QString m_workflowPluginName;
};
