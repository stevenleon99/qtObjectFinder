#pragma once

#ifndef Q_MOC_RUN
#include <lager/extra/struct.hpp>
#endif

#include <procd/spine/types/enums/ToolboxEnums.h>
#include <drive/model/datamodel/model.h>
#include <gm/util/qml/MapListModel.h>
#include <QSettings>

namespace spine::managers {
class ToolboxManager;
}  // namespace spine::managers

namespace surgeonsettings {
enum class ArrayType
{
    Unknown,
    LegacyFixation,
    LegacyInterbody,
    Excelsius,
};
}  // namespace surgeonsettings

//! UI checkbox for enabling a type of instrument pairing system for the user.
struct ArrayDisplayType
{
    //! enum representation of the array type
    surgeonsettings::ArrayType arrayType{surgeonsettings::ArrayType::Unknown};

    //! label for the checkbox
    QString displayName = "";  // paired instrument if swappable, refElement if GPS

    //! whether the checkbox is checked
    bool isSelected = false;

    LAGER_STRUCT_NESTED(ArrayDisplayType, arrayType, displayName, isSelected);
};
using ArrayTypeList = QMap<surgeonsettings::ArrayType, ArrayDisplayType>;
using ArrayTypeListModel = gm::util::qml::MapListModel<ArrayTypeList>;


class SurgeonSettingsViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool displayInvalidShots READ displayInvalidShots NOTIFY displayInvalidShotsChanged)
    Q_PROPERTY(bool displayIctUnstableAlert READ displayIctUnstableAlert NOTIFY
                   displayIctUnstableAlertChanged)
    Q_PROPERTY(
        bool reduceBackoffDistance READ reduceBackoffDistance NOTIFY reduceBackoffDistanceChanged)
    Q_PROPERTY(QAbstractListModel* arrayTypeList READ arrayTypeList CONSTANT)
    Q_PROPERTY(int minimumOpacity READ minimumOpacity CONSTANT)
    Q_PROPERTY(int maximumOpacity READ maximumOpacity CONSTANT)
    Q_PROPERTY(int minimumCadOpacity READ minimumCadOpacity CONSTANT)
    Q_PROPERTY(int crosshairsOpacity READ crosshairsOpacity NOTIFY crosshairsOpacityChanged)
    Q_PROPERTY(int implantCadOpacity READ implantCadOpacity NOTIFY implantCadOpacityChanged)
    Q_PROPERTY(
        int instrumentCadOpacity READ instrumentCadOpacity NOTIFY instrumentCadOpacityChanged)
    Q_PROPERTY(
        bool displayTrajectoryLine READ displayTrajectoryLine NOTIFY displayTrajectoryLineChanged)
    Q_PROPERTY(bool hideMergeScores READ hideMergeScores NOTIFY hideMergeScoresChanged)
    Q_PROPERTY(QVariantList volumeSetFourUpLayout READ volumeSetFourUpLayout NOTIFY
                   volumeSetFourUpLayoutChanged)

public:
    explicit SurgeonSettingsViewModel(::drive::model::SurgeonIdentifier surgeonId,
                                      QObject* parent = nullptr);

    // Q_INVOKABLEs
    Q_INVOKABLE void toggleInvalidShotsDisplay();
    Q_INVOKABLE void toggleIctUnstableAlertDisplay();
    Q_INVOKABLE void toggleReduceBackoffDistance();
    Q_INVOKABLE void toggleArrayType(surgeonsettings::ArrayType arrayType);
    Q_INVOKABLE void updateCrosshairsOpacity(int opacity);
    Q_INVOKABLE void updateimplantCadOpacity(int opacity);
    Q_INVOKABLE void updateinstrumentCadOpacity(int opacity);
    Q_INVOKABLE void toggleDisplayTrajectoryLine();
    Q_INVOKABLE void toggleHideMergeScores();
    Q_INVOKABLE void updateVolumeSetFourUpLayout(const QStringList& layoutList);

    // Q_PROPERTY READ
    bool displayInvalidShots() const;
    bool displayIctUnstableAlert() const;
    bool reduceBackoffDistance() const;
    QAbstractListModel* arrayTypeList() const { return m_arrayTypeListModel->abstractListModel(); }
    int minimumOpacity() const;
    int maximumOpacity() const;
    int minimumCadOpacity() const;
    int crosshairsOpacity() const;
    int implantCadOpacity() const;
    int instrumentCadOpacity() const;
    bool displayTrajectoryLine() const;
    bool hideMergeScores() const;
    QVariantList volumeSetFourUpLayout() const;

signals:
    void displayInvalidShotsChanged();
    void displayIctUnstableAlertChanged();
    void reduceBackoffDistanceChanged();
    void crosshairsOpacityChanged();
    void implantCadOpacityChanged();
    void instrumentCadOpacityChanged();
    void displayTrajectoryLineChanged();
    void hideMergeScoresChanged();
    void volumeSetFourUpLayoutChanged();

private:
    std::set<spine::types::enums::PairingSystemType> getEnabledPairingSystems();
    std::map<spine::types::enums::PairingSystemType, QString> getAllPairingSystemTypesAndNames();
    void updateArrayTypeList();

private:
    const std::shared_ptr<spine::managers::ToolboxManager> m_toolboxManager;
    QSettings m_settings;

    // Q_PROPERTY MEMBER
    std::shared_ptr<ArrayTypeListModel> m_arrayTypeListModel;
};

surgeonsettings::ArrayType toArrayType(spine::types::enums::PairingSystemType systemType);
std::set<spine::types::enums::PairingSystemType> toPairingSystemType(
    surgeonsettings::ArrayType arrayType);
QString toString(surgeonsettings::ArrayType arrayType);

Q_DECLARE_METATYPE(surgeonsettings::ArrayType)
