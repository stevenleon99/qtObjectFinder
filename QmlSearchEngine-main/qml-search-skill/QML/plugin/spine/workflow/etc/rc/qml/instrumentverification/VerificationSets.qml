import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import "../instrumentpairing"

ColumnLayout {
    spacing: Theme.margin(1)

    property var activeRefElementSetViewModel

    Repeater {
        model: activeRefElementSetViewModel.verifyDropdowns

        delegate: ExpandableVerificationPanel {
            objectName: "expandableVerificationPanel_"+role_displayName
            title: role_displayName
            expanded: role_key === activeRefElementSetViewModel.activeRefElementSet

            editButtonVisible: role_setType == VerificationSetType.Excelsius || role_setType == VerificationSetType.InterbodyImplantSystem
            adapterSelectionVisible: role_useSwappableAdapterVisible
            adapterEnabled: role_useSwappableAdapterChecked
            activeStatus: role_activeStatus

            contentItem: ColumnLayout {
                Repeater {
                    model: activeRefElementSetViewModel.activeRefElementList

                    delegate: InstrumentVerificationDelegate {
                        objectName: "instrumentVerification_"+role_displayName
                        color: role_color
                        name: role_displayName
                        subName: role_partNumber
                        verificationStatus: role_verificationStatus
                        instrumentVisible: role_isVisible
                        arrayIndexStr: role_arrayIndexStr
                        displayArrayIndex: role_displayArrayIndex
                        iconSource: role_iconPath
                        calibratedStatus: ToolCalibratedStatus.NotRequired

                        tapSwitchVisible: role_awlTipTapSelectorVisible
                        tapSwitchChecked: role_isAwlTipTap
                        isPowerTool: role_isPowerTool

                        onToggleTapSwitchClicked: {
                            activeRefElementSetViewModel.toggleAwlTipTap();
                        }

                        onIconClicked: {
                            if (role_setType == VerificationSetType.Excelsius || role_setType == VerificationSetType.InterbodyImplantSystem)
                            {
                                activeRefElementSetViewModel.selectRefElementWithType(role_key);
                                pairingsPopup.open()
                            }
                        }
                    }
                }
            }

            onClicked: {
                activeRefElementSetViewModel.setActiveRefElementSet(role_key)
            }

             onEditButtonClicked: {
                pairingsPopup.open()
            }

            onAdapterSelectionClicked: {
                activeRefElementSetViewModel.toggleSwappableAdapterEnabled()
            }
        }
    }

    PairingsPopup {
        id: pairingsPopup
    }
}
