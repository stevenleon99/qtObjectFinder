#include "DrivePageViewModel.h"

#ifndef Q_MOC_RUN
#include <gos/gps/stabilizers/StabilizersProxyFactory.h>
#endif

#include <QApplication>

DrivePageViewModel::DrivePageViewModel(QObject* parent)
    : QObject(parent)
    , m_stabilizersItf(nullptr)
    , m_currentPage(DrivePage::Login)
    , m_previousPage(m_currentPage)
{
    m_systemType = sys::config::Config::instance()->platform.systemType();
    if (m_systemType == sys::config::SystemType::Egps)
    {
        auto glinkNode = glink::node::NodeFactory::createInstance();
        if (glinkNode)
        {
            m_stabilizersItf =
                gos::gps::stabilizers::StabilizersProxyFactory::createInstance(
                    glinkNode, gos::roles::gps::stabilizers::StabilizersRole);
        }
    }
}

void DrivePageViewModel::goToPreviousPage()
{
    setCurrentPage(m_previousPage);
}

void DrivePageViewModel::setCurrentPage(const DrivePageViewModel::DrivePage currentPage)
{
    if (m_currentPage == currentPage)
        return;

    m_previousPage = m_currentPage;
    m_currentPage = currentPage;

    // If the user is creating a new case, opening an existing case, or exiting
    // a case, and we are on a GPS and the stabilizers override is engage,
    // disengage the stabilizer override.
    //
    // The user must turn on the stabilizer override after moving to the
    // "Workflow" page.
    //
    if (((m_previousPage == DrivePage::Cases &&
          m_currentPage == DrivePage::Workflow) ||
         (m_previousPage == DrivePage::Workflow &&
          m_currentPage == DrivePage::Cases)) &&
        m_stabilizersItf)
    {
        if (m_stabilizersItf->stabilizerOverride())
        {
            m_stabilizersItf->setStabilizerOverride(false);
        }
    }

    emit currentPageChanged(m_currentPage);
}

void DrivePageViewModel::setWorkflowPluginName(const QString& workflowPluginName)
{
    if (m_workflowPluginName == workflowPluginName)
        return;

    m_workflowPluginName = workflowPluginName;
    emit workflowPluginNameChanged(m_workflowPluginName);
}

void DrivePageViewModel::onWorkflowQuit()
{
    setCurrentPage(DrivePage::Cases);
}
