import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

ExpandableVerificationPanel {
    title: qsTr("Navigation")
    selectable: false
    activeStatus: "Always Active"
    objectName: "standardNavigationVerificaitonPanel"

    StandardNavVerificationPanelViewModel {
        id: standardNavVerificationPanelViewModel
    }

    contentItem: ColumnLayout {
        spacing: Theme.margin(1)

        Repeater {
            model: standardNavVerificationPanelViewModel.verificationList

            delegate: InstrumentVerificationDelegate {
                objectName: "instrumentVerificaiton_"+role_name
                color: role_color
                name: role_name
                iconSource: role_iconPath
                verificationStatus: role_verificationStatus
                instrumentVisible: role_isVisible
                mleeVerifyVisible: role_isMlee
                mleeVerifyEnabled: standardNavVerificationPanelViewModel.verifyMleeEnabled
                eeIs15: standardNavVerificationPanelViewModel.eeIs15
                ee15Vs17Visible: standardNavVerificationPanelViewModel.ee15vs17Enabled && role_isEe15Or17
                calibratedStatus: role_calibratedStatus
                serialNumbers: role_serialNumbers
                selectedSerialNumber: role_selectedSerialNumber

                onVerifyClicked: {
                    standardNavVerificationPanelViewModel.verifyMlee();
                }

                onToggleEe15vs17Clicked: {
                    standardNavVerificationPanelViewModel.toggleEe15vs17();
                }

                onSerialNumbersClicked: {
                    standardNavVerificationPanelViewModel.selectSerialNumber(role_key, serialNumber);
                }
            }
        }
    }
}
