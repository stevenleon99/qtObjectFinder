/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/scanimport/VolumeDetailsModel.h>
#include <drive/com/propertysource/CasesPropertySource.h>
#include <drive/com/propertysource/PatientDetailsPropertySource.h>

#ifndef Q_MOC_RUN
#include <gos/itf/scanmanager/IManualScanManager.h>
#include <sys/alerts/itf/IAlertAggregator.h>
#endif

#include <QAbstractListModel>

class ScanListModel : public QAbstractListModel
{
    Q_OBJECT

    using CasesPropertySource =
        ::drive::com::propertysource::CasesPropertySource;
    using PatientDetailsPropertySource =
        ::drive::com::propertysource::PatientDetailsPropertySource;

    Q_PROPERTY(QObject* scanDetails READ scanDetails CONSTANT)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString selectedScanId  //
                   READ selectedScanId NOTIFY selectedScanIdChanged)
    Q_PROPERTY(QString selectedScanPath  //
                   READ selectedScanPath NOTIFY selectedScanPathChanged)
    Q_PROPERTY(ScanSource scanSource  //
                   READ scanSource WRITE setScanSource NOTIFY scanSourceChanged)

public:
    enum class ScanSource
    {
        UNKNOWN = 0,
        PATIENT,
        CASE
    };
    Q_ENUMS(ScanSource)

    enum RoleNames
    {
        ScanIdStr = Qt::UserRole + 1,
        ThumbnailPath,
        ScanDescription
    };

    ScanListModel(
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        std::shared_ptr<gos::itf::scanmanager::IManualScanManager> scanManager,
        QObject* parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    int count() const;

    drive::scanimport::VolumeDetailsModel* scanDetails() const
    {
        return m_scanDetailsModel;
    }

    QString selectedScanId() const { return m_selectedScanId; }
    QString selectedScanPath() const { return m_selectedScanPath; }
    ScanSource scanSource() const { return m_selectedScanSource; }
    void setScanSource(ScanSource source);
    void reloadScans();

    Q_INVOKABLE void selectScanId(const QString& scanIdStr);

signals:
    void countChanged();
    void selectedScanIdChanged();
    void selectedScanPathChanged();
    void scanSourceChanged();

private:
    void reloadPatientScans();
    void reloadCaseScans();

    void resolvCallback(std::shared_ptr<gm::arch::IDictionary<
                            gos::itf::scanmanager::ScanId,
                            gos::itf::scanmanager::ManagedScan>> scanDetails);

    std::shared_ptr<gos::itf::scanmanager::IManualScanManager> m_scanManager;
    std::unique_ptr<CasesPropertySource> m_casesPropertySource;
    std::unique_ptr<PatientDetailsPropertySource>
        m_patientDetailsPropertySource;
    drive::scanimport::VolumeDetailsModel* m_scanDetailsModel;
    QList<std::pair<std::string, gos::itf::scanmanager::ManagedScan>>
        m_scanDetailList;
    QString m_selectedScanId;
    QString m_selectedScanPath;
    ScanSource m_selectedScanSource = ScanSource::UNKNOWN;
};
