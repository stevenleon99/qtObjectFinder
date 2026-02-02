/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#ifndef Q_MOC_RUN
#include <drive/itf/settings/ISystemSettings.h>
#include <drive/itf/plugin/IPluginShell.h>
#include <gos/itf/deviceio/IDeviceIO.h>
#include <gm/util/enum.h>
#include <gm/util/boost_signals2.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <sys/alerts/Alert.h>
#endif

#include <drive/archiving/LocationsViewModel.h>

#include <QObject>
#include <QThread>
#include <QPointer>

using PluginQuitSignal = boost::signals2::signal<void()>;
// namespace drive::systemsettings
class SystemSettingsImplementation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int audioVolume READ audioVolume WRITE setAudioVolume NOTIFY
                   audioVolumeChanged)
    Q_PROPERTY(
        int screenTimeout READ screenTimeout WRITE setScreenTimeout NOTIFY screenTimeoutChanged)
    Q_PROPERTY(QString videoFormat READ videoFormat WRITE setVideoFormat NOTIFY
                   videoFormatChanged)
    Q_PROPERTY(QString fluoroFixtureSize READ fluoroFixtureSize WRITE
                   setFluoroFixtureSize NOTIFY fluoroFixtureSizeChanged)
    Q_PROPERTY(QString fluoroSensitivity READ fluoroSensitivity WRITE
                   setFluoroSensitivity NOTIFY fluoroSensitivityChanged)
    Q_PROPERTY(
        QString aeTitle READ aeTitle WRITE setAeTitle NOTIFY aeTitleChanged)
    Q_PROPERTY(QAbstractListModel* locationList READ locationList CONSTANT)
    Q_PROPERTY(bool usingLaptop READ usingLaptop CONSTANT)
    Q_PROPERTY(QString licenseCode READ licenseCode WRITE setLicenseCode NOTIFY
                   licenseCodeChanged)

    using ISystemSettings = ::drive::itf::settings::ISystemSettings;

public:
    explicit SystemSettingsImplementation(
        std::shared_ptr<gos::itf::deviceio::IDeviceIO>,
        std::shared_ptr<sys::alerts::itf::IAlertManager> alertManager);
    ~SystemSettingsImplementation();

    void setPluginShell(
        std::shared_ptr<drive::itf::plugin::IPluginShell> shell);

    std::shared_ptr<drive::itf::settings::ISystemSettings> getSystemSettings();
    void setSystemSettings(const std::shared_ptr<ISystemSettings>& settings);

    void cleanupPlugin();
    PluginQuitSignal pluginQuit;  // boost signal
    Q_INVOKABLE void requestPluginQuit();

    Q_INVOKABLE void resetMotion();
    Q_INVOKABLE void resetSoftware();
    Q_INVOKABLE void exportLogs(const QString& exportLocation);
    Q_INVOKABLE void exportScreenshots();
    Q_INVOKABLE void applyLicenseCode(const QString& licenseCode);

    // Q_PROPERTY READ
    int audioVolume() const;
    int screenTimeout() const;
    QString videoFormat() const;
    QString fluoroFixtureSize() const;
    QString fluoroSensitivity() const;
    QString aeTitle() const;  ///< the configured application entity title
    QAbstractListModel* locationList() const { return m_exportLocations; }
    bool usingLaptop() const;
    QString licenseCode() const { return m_licenseCode; }

public slots:
    // Q_PROPERTY WRITE
    void setAudioVolume(const int systemVolume);
    void setScreenTimeout(const int screenTimeout);
    void setVideoFormat(const QString& videoFormat);
    void setFluoroFixtureSize(const QString& fluoroFixtureSize);
    void setFluoroSensitivity(const QString& fluoroSensitivity);
    void setAeTitle(const QString&);  ///< set the application entity title
    void setLicenseCode(const QString& licenseCode);

signals:
    // Q_PROPERTY CHANGED
    void audioVolumeChanged(const int systemVolume);
    void screenTimeoutChanged(const int screenTimeout);
    void videoFormatChanged(const QString& videoFormat);
    void fluoroFixtureSizeChanged(const QString& fluoroFixtureSize);
    void fluoroSensitivityChanged(const QString& fluoroSensitivity);
    void aeTitleChanged(const QString&);
    void licenseCodeChanged(const QString& licenseCode);

private slots:
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option&);
    void updateLocations(
        std::shared_ptr<
            gm::arch::ICollection<gos::itf::deviceio::LabeledLocation>> const&
            labeledLocations);

private:
    std::shared_ptr<drive::itf::settings::ISystemSettings> m_systemSettings;
    std::shared_ptr<drive::itf::plugin::IPluginShell> m_shell;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;
    std::shared_ptr<gos::itf::deviceio::IDeviceIO> m_deviceIo;
    std::shared_ptr<gm::arch::IObservable<std::shared_ptr<
        gm::arch::ICollection<gos::itf::deviceio::LabeledLocation>>>>
        m_archiveLocations;
    drive::archiving::LocationsViewModel* m_exportLocations;

    QPointer<QThread> m_exportThread;

    QString m_licenseCode = "";
};
