import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0

import ".."

RowLayout {
    height: Theme.marginSize * 4
    spacing: 0

    TopbarViewModel {
        id: topbarViewModel
    }

    Repeater {
        model: topbarViewModel

        PageButton {
            enabled: role_available
            Layout.fillHeight: true
            text: role_text
            source: role_iconSource
            active: role_isActive

            onClicked: {
                if (role_isClickable)
                    applicationViewModel.switchToPage(role_page)
            }
        }
    }
}
