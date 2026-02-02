/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include "HeadsetFeedProvider.h"

#ifndef Q_MOC_RUN
#include <gos/nav/SensorHubProxyFactory.h>
#include <service/glink/node/NodeFactory.h>
#include <gm/util/qt/qt_boost_signals2.h>
#endif

#include <QObject>

#include <atomic>

namespace drive::viewmodel {

class HeadsetCalibrationViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(ehubsettings::types::HeadsetFeedType headsetType READ headsetType WRITE
                   setHeadsetType NOTIFY headsetTypeChanged)

    Q_PROPERTY(bool showCalPopup READ showCalPopup NOTIFY showCalPopupChanged)

    Q_PROPERTY(bool calInProgress READ calInProgress NOTIFY calInProgressChanged)

    Q_PROPERTY(
        bool successfulCompletion READ successfulCompletion NOTIFY successfulCompletionChanged)

    Q_PROPERTY(QStringList headsetTypeStrs MEMBER m_headsetTypeStrs READ headsetTypeStrs NOTIFY
                   headsetTypeStrsChanged)

    Q_PROPERTY(int numImgSaved READ numImgSaved NOTIFY numImgSavedChanged)

    Q_PROPERTY(QString curCalPlate MEMBER m_curCalPlate READ curCalPlate NOTIFY curCalPlateChanged)

    Q_PROPERTY(QList<QVariant> calPlateStrs MEMBER m_calPlateStrs READ calPlateStrs NOTIFY
                   calPlateStrsChanged)

    Q_PROPERTY(QString curHeadsetTypeStr READ curHeadsetTypeStr WRITE setCurHeadsetTypeStr NOTIFY
                   curHeadsetTypeStrChanged)

    Q_PROPERTY(QString calStatus READ calStatus NOTIFY calStatusChanged)
    Q_PROPERTY(QString calState READ getCalState NOTIFY calStatusChanged)
    Q_PROPERTY(QString exportStatusMessage READ getCalState NOTIFY exportStatusChanged)
    Q_PROPERTY(QString exportMessage READ getExportMessage NOTIFY exportStatusChanged)
    Q_PROPERTY(bool allowExport READ shouldAllowExport NOTIFY exportStatusChanged)
    Q_PROPERTY(bool canExtendCalibration READ shouldExtendCalibration NOTIFY calStatusChanged)

    Q_PROPERTY(
        int reqdNumImages MEMBER m_reqdNumImages READ reqdNumImages NOTIFY reqdNumImagesChanged)

public:
    const std::filesystem::path m_calFileBaseDir = R"(globus\field_plate)";

    const QString m_defaultCalPlateStr = R"(Push from USB)";

    inline void status_to_string(const gos::itf::nav::OpticalCalibrationEvent::Status& status)
    {
        using namespace gos::itf::nav;
        m_calStatus = status;
        emit calStatusChanged();
    }

    QStringList m_headsetTypeStrs{
        ehubsettings::types::to_string(ehubsettings::types::HeadsetFeedType::HeadsetA_Stereo),
        ehubsettings::types::to_string(ehubsettings::types::HeadsetFeedType::HeadsetB_Stereo)};

    explicit HeadsetCalibrationViewModel(
        std::shared_ptr<ehubsettings::imageprovider::HeadsetFeedProvider> headsetFeedProvider,
        QObject* parent = nullptr);

    ehubsettings::types::HeadsetFeedType headsetType() { return m_headsetType; };
    void setHeadsetType(ehubsettings::types::HeadsetFeedType type);
    void setCurHeadsetTypeStr(QString headsetTypeStr);
    bool showCalPopup() { return m_showCalPopup; };
    bool calInProgress() { return m_calInProgress; };
    bool successfulCompletion() { return m_successfulCompletion; };
    Q_INVOKABLE void startCalibration();
    Q_INVOKABLE void cancelCalibration();
    Q_INVOKABLE void extendCalibration();
    Q_INVOKABLE void exportResults();
    QStringList headsetTypeStrs() { return m_headsetTypeStrs; }
    int numImgSaved() { return m_numImgSaved; }
    QList<QVariant> calPlateStrs();
    QString curCalPlate() { return m_curCalPlate; }
    QString curHeadsetTypeStr() { return m_curHeadsetTypeStr; };
    QString calStatus() const { return to_string(m_calStatus).data(); }
    QString getCalState() const;
    QString getExportMessage() const;
    bool shouldAllowExport() const;
    bool shouldExtendCalibration() const;
    int reqdNumImages() { return m_reqdNumImages; }
    void resetVars();
    Q_INVOKABLE void calActionButton(bool forceClose);
signals:
    void headsetTypeChanged();
    void showCalPopupChanged();
    void calInProgressChanged();
    void successfulCompletionChanged();
    void numImgSavedChanged();
    void headsetTypeStrsChanged();
    void calPlateStrsChanged();
    void curCalPlateChanged();
    void curHeadsetTypeStrChanged();
    void calStatusChanged();
    void reqdNumImagesChanged();
    void exportStatusChanged();

public slots:
    QVariantList getVideoFeedsVariantList(ehubsettings::types::HeadsetFeedType feedType);

private:
    enum class ExportStatus
    {
        NotStarted,
        InProgress,
        Failure,
        Success
    };
    // Q_PROPERTY MEMBER
    ehubsettings::types::HeadsetFeedType m_headsetType;
    bool m_showCalPopup;
    bool m_calInProgress;
    bool m_successfulCompletion;
    bool m_closeWhenComplete;
    int m_numImgSaved;
    std::shared_ptr<glink::node::INode> m_node;
    std::shared_ptr<gos::itf::nav::ISensorHub> m_sensorhub;
    std::shared_ptr<ehubsettings::imageprovider::HeadsetFeedProvider> m_headsetFeedProvider =
        nullptr;
    void onOpticalCalEventReceived(
        std::shared_ptr<const gos::itf::nav::OpticalCalibrationEvent> event);
    void onExportEventReceived(bool success);

    QList<QVariant> m_calPlateStrs;
    QString m_curCalPlate;
    std::future<void> m_calFilesFutr;
    std::mutex m_calFilesMutex;
    QString m_curHeadsetTypeStr;
    gos::itf::nav::OpticalCalibrationEvent::Status m_calStatus;
    std::atomic<ExportStatus> m_exportStatus = ExportStatus::NotStarted;
    int m_reqdNumImages;
    void scanCalFilesDir();
};

}  // namespace drive::viewmodel
