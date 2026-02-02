#pragma once

#include <drive/model/datamodel/model.h>

#include <QSettings>
namespace surgeonsettings {

class SurgeonSettingsViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int crosshairs3dOpacity READ crosshairs3dOpacity NOTIFY crosshairs3dOpacityChanged)
    Q_PROPERTY(bool isAcpcDisplayTarget READ isAcpcDisplayTarget NOTIFY isAcpcDisplayTargetChanged)
    Q_PROPERTY(
        bool isAcpcDisplayGeneral READ isAcpcDisplayGeneral NOTIFY isAcpcDisplayGeneralChanged)
    Q_PROPERTY(
        bool isOriginalDicomCoord READ isOriginalDicomCoord NOTIFY isOriginalDicomCoordChanged)
    Q_PROPERTY(bool isInterpolationMode READ isInterpolationMode NOTIFY isInterpolationModeChanged)

public:
    explicit SurgeonSettingsViewModel(::drive::model::SurgeonIdentifier surgeonId,
                                      QObject* parent = nullptr);
    // Q_PROPERTY READ
    int crosshairs3dOpacity() const;
    bool isAcpcDisplayTarget() const;
    bool isAcpcDisplayGeneral() const;
    bool isOriginalDicomCoord() const;
    bool isInterpolationMode() const;

public slots:
    void updateCrosshairs3dOpacity(int opacity);
    void updateIsAcpcDisplayTarget(bool autoACPCcoordinates);
    void updateIsAcpcDisplayGeneral(bool autoACPCcoordinates);
    void updateIsOriginalDicomCoord(bool originalDicomCoord);

    void toggleInterpolationMode();

signals:
    void crosshairs3dOpacityChanged();
    void isAcpcDisplayTargetChanged();
    void isAcpcDisplayGeneralChanged();
    void isOriginalDicomCoordChanged();
    void isInterpolationModeChanged();

private:
    QSettings m_settings;
};

}  // namespace surgeonsettings
