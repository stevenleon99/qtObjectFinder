/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/model/common.h>
#include <drive/scanimport/ImportViewModelSource.h>
#include <QObject>


using ScanImportSuccessSignal = boost::signals2::signal<void(std::pair<ScanId, ManagedScan>)>;

using DriveCaseDataUpdateSignal = boost::signals2::signal<void(drive::model::DriveCaseData)>;


class CranialImportModel : public QObject, public std::enable_shared_from_this<CranialImportModel>
{
    Q_OBJECT

public:
    explicit CranialImportModel(drive::scanimport::ImportViewModelSource* importViewModelSource,
                                QObject* parent = nullptr);

    ScanImportSuccessSignal scanImportSuccessSignal;

    DriveCaseDataUpdateSignal driveCaseDataUpdateSignal;

public slots:
    void onScanImported(const FileInfo& fileInfo,
                        const std::variant<ScanId, ScanError>& importStatus);

private slots:
    void onScanImportSuccess(const std::pair<ScanId, ManagedScan>& volumeWithId);

private:
    drive::scanimport::ImportViewModelSource* m_importViewModelSource;
};
