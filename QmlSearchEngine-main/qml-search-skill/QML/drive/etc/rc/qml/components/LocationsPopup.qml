import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.impl 2.5
import QtQuick.Templates 2.4 as T

import DriveEnums 1.0
import ViewModels 1.0
import Theme 1.0
import GmQml 1.0

T.Popup {
    id: popup
    width: Theme.margin(26)
    height: Theme.margin(8) * locationsList.count
    dim: false

    property alias model: locationsList.model
    property bool count: locationsList.count

    signal locationSelected(string location)

    property var locationIcons: {
        "USB": "qrc:/icons/usb.svg",
        "CDROM": "qrc:/icons/cd.svg",
        "HDD": "qrc:/icons/drive.svg"
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: Theme.foregroundColor
        radius: 5

        ListView {
            id: locationsList
            width: parent.width
            height: parent.height

            delegate: Item {
                width: Theme.margin(26)
                height: Theme.margin(8)

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: Theme.margin(1)
                        rightMargin: Theme.margin(1)
                    }
                    spacing: Theme.margin(1)

                    IconImage {
                        sourceSize: Theme.iconSize
                        source: locationIcons[role_type]
                    }

                    Label {
                        Layout.fillWidth: true
                        state: "button1"
                        text: role_name
                        elide: Text.ElideRight
                        verticalAlignment: Label.AlignVCenter
                    }

                    LayoutSpacer {}
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: locationSelected(role_location)
                }
            }
        }
    }
}


