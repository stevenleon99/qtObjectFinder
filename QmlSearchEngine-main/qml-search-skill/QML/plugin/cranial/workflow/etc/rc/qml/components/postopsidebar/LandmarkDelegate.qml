import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

import ".."


RowLayout {
    Layout.fillWidth: true
    spacing: Theme.margin(2)

    property real distanceFromTarget
    property real distanceFromTrajectory
    property bool isSetEnabled: true
    property bool isSelected: false

    signal landmarkClicked()
    signal setButtonClicked()

    Rectangle {
        id: landmark
        Layout.fillWidth: true
        height: detailsLayout.height
        radius: 4
        color: (isSetEnabled && isSelected)?Theme.foregroundColor:Theme.transparent
        border { width: 1; color: (isSetEnabled && isSelected)?Theme.blue:Theme.disabledColor }

        MouseArea {
            anchors { fill: parent }
            onClicked: landmarkClicked()
        }

        RowLayout {
            id: detailsLayout
            spacing: 0

            IconImage {
                Layout.margins: Theme.margin(1)
                source: "qrc:/icons/dbs-lead.svg"
                color: role_color
                sourceSize: Theme.iconSize
            }

            RowLayout {
                spacing: Theme.margin(1)

                RowLayout {
                    spacing: 0

                    IconImage {
                        source: "qrc:/icons/trajectory-measuretotarget.svg"
                        color: Theme.disabledColor
                        sourceSize: Theme.iconSize
                    }

                    Label {
                        state: "subtitle1"
                        text: distanceFromTarget.toFixed(1)
                        font.bold: true
                    }
                }

                RowLayout {
                    spacing: 0

                    IconImage {
                        source: "qrc:/icons/trajectory-measuretoline.svg"
                        color: Theme.disabledColor
                        sourceSize: Theme.iconSize
                    }

                    Label {
                        state: "subtitle1"
                        text: distanceFromTrajectory.toFixed(1)
                        font.bold: true
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }
    }

    Button {
        state: isSetEnabled?"active":"disabled"
        onClicked: setButtonClicked()
        text: qsTr("Set")
        leftPadding: Theme.margin(1)
        rightPadding: Theme.margin(1)
    }
}

