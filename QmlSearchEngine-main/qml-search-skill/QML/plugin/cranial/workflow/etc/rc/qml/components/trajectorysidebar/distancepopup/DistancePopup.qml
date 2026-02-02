import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import "../.."

Popup {
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 1300
    height: 720

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.leftMargin: Theme.marginSize * 3 / 2
            Layout.rightMargin: Theme.marginSize / 2
            Layout.topMargin: Theme.marginSize
            Layout.bottomMargin: Theme.marginSize

            Label {
                state: "h6"
                font.bold: true
                text: qsTr("Edit Distance")
            }

            LayoutSpacer { }

            Button {
                icon.source: "qrc:/icons/x.svg"
                state: "icon"
                onClicked: close()
            }
        }

        DividerLine { }

        RowLayout {
            spacing: 0

            TrajectoryDistanceList { }

            DividerLine { }

            TrajectoryDistanceEditor { }
        }
    }
}
