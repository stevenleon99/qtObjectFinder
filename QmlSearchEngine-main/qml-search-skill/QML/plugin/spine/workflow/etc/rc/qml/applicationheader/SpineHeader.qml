import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import PageEnum 1.0

import ".."
import "../viewports"
import "../registration"

RowLayout {
    width: parent.width
    height: Theme.marginSize * 4
    spacing: 0

    TopbarViewModel {
        id: topbarViewModel
    }

    Repeater {
        model: topbarViewModel

        PageButton {
            objectName: "spineHeaderBtn_"+role_text
            enabled: role_enabled
            Layout.fillHeight: true
            text: role_text
            source: role_iconSource
            active: role_isActive

            onClicked: {
                applicationViewModel.switchToPage(role_page)
            }
        }
    }

    LayoutSpacer {}
    
    Button {
        visible: applicationViewModel.labModeEnabled || applicationViewModel.testModeEnabled
        icon.source: "qrc:/icons/tools.svg"
        state: "icon"
        onClicked: applicationViewModel.openDebugWindow(true)
    }

    RegistrationResetButton { }
}
