/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "ScanListModel.h"

#include <gm/util/qt/qtContinuation.h>

#ifndef Q_MOC_RUN
#include <gm/arch/ContainerCollection.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <boost/uuid/uuid_generators.hpp>
#include <boost/uuid/uuid_io.hpp>
#endif

ScanListModel::ScanListModel(
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    std::shared_ptr<gos::itf::scanmanager::IManualScanManager> scanManager,
    QObject* parent)
    : QAbstractListModel(parent)
    , m_scanManager(scanManager)
    , m_casesPropertySource(std::make_unique<CasesPropertySource>(parent))
    , m_patientDetailsPropertySource(
          std::make_unique<PatientDetailsPropertySource>(parent))
    , m_scanDetailsModel(nullptr)  // initialized in constructor body
{
    // no need to keep the alert manager here, just give it to the dependents
    auto alertManager = sys::alerts::AlertManagerFactory::createInstance();
    m_scanDetailsModel =
        new drive::scanimport::VolumeDetailsModel(alertManager, this);
    alertViewRegistry->addAlertView(alertManager);

    gm::util::connect(
        alertManager->clearRequested, alertManager,
        [](auto& alertManager_, sys::alerts::Alert const& alert,
           sys::alerts::Option const&) { alertManager_.clearAlert(alert); });

    connect(m_casesPropertySource.get(), &CasesPropertySource::scanIdsChanged,
            this, &ScanListModel::reloadCaseScans);
    connect(m_patientDetailsPropertySource.get(),
            &PatientDetailsPropertySource::scanIdsChanged, this,
            &ScanListModel::reloadPatientScans);
}

QHash<int, QByteArray> ScanListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ScanIdStr] = "role_scan_id";
    roles[ThumbnailPath] = "role_thumbnail_path";
    roles[ScanDescription] = "role_description";
    return roles;
}

int ScanListModel::rowCount(const QModelIndex&) const
{
    return count();
}

QVariant ScanListModel::data(const QModelIndex& index, int role) const
{
    int rowIndex = index.row();

    if (rowIndex < 0 || rowIndex >= m_scanDetailList.size())
        return QVariant();

    auto const& scanDetail = m_scanDetailList.at(index.row());

    switch (role)
    {
    case ScanIdStr: return QString::fromStdString(scanDetail.first);
    case ThumbnailPath:
        return QString::fromStdString(scanDetail.second.thumbnail.string());
    case ScanDescription:
    {
        if (std::holds_alternative<DicomScan>(scanDetail.second.info.scan))
        {
            auto ds = std::get<DicomScan>(
                scanDetail.second.info.scan);  // All are DICOM
            return QString::fromStdString(ds.description);
        }
        return QVariant();
    }
    default: return QVariant();
    }
}

int ScanListModel::count() const
{
    return m_scanDetailList.count();
}

void ScanListModel::reloadScans()
{
    if (m_selectedScanSource == ScanSource::UNKNOWN)
        return;

    std::vector<gos::itf::scanmanager::ScanId> scanIds;
    if (m_selectedScanSource == ScanSource::PATIENT)
    {
        scanIds = m_patientDetailsPropertySource->scanIds();
    }
    else if (m_selectedScanSource == ScanSource::CASE)
    {
        scanIds = m_casesPropertySource->scanIds();
    }

    m_scanManager->resolve(
        gm::arch::createCollection(std::move(scanIds)),
        gm::util::qt::trackedContinuation(
            this,
            [this](
                std::shared_ptr<gm::arch::IDictionary<
                    gos::itf::scanmanager::ScanId,
                    gos::itf::scanmanager::ManagedScan>> const& scanDetails) {
                resolvCallback(scanDetails);
            }));
}

void ScanListModel::setScanSource(ScanSource source)
{
    if (m_selectedScanSource != source)
    {
        m_selectedScanSource = source;
        reloadScans();
        scanSourceChanged();
    }
}

void ScanListModel::selectScanId(const QString& scanIdStr)
{
    gos::itf::scanmanager::FileInfo fileInfo;
    for (auto const& scanDetail : m_scanDetailList)
    {
        if (scanDetail.first == scanIdStr.toStdString())
        {
            fileInfo = scanDetail.second.info;
            m_selectedScanPath =
                QString::fromStdString(scanDetail.second.thumbnail.string());
            emit selectedScanPathChanged();
            break;
        }
    }

    m_scanDetailsModel->setScanData(scanIdStr, fileInfo);
}

void ScanListModel::reloadPatientScans()
{
    if (m_selectedScanSource != ScanSource::PATIENT)
        return;

    reloadScans();
}

void ScanListModel::reloadCaseScans()
{
    if (m_selectedScanSource != ScanSource::CASE)
        return;

    reloadScans();
}

void ScanListModel::resolvCallback(
    std::shared_ptr<IDictionary<ScanId, ManagedScan>> scanDetails)
{
    beginResetModel();
    m_scanDetailList.clear();
    for (const auto& [scanId, managedScan] : *scanDetails)
    {
        m_scanDetailList.push_back({to_string(scanId.id), managedScan});
    }
    endResetModel();
    emit countChanged();
}
