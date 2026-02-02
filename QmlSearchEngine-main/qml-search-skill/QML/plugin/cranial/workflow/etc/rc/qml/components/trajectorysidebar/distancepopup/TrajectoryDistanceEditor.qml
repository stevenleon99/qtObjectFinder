import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import "../.."

Item {
    Layout.preferredWidth: 839
    Layout.preferredHeight: 639

    Label {
        width: parent.width - Theme.marginSize * 3
        anchors { top: parent.top;
                  left: parent.left;
                  topMargin: Theme.marginSize * 3 / 2;
                  leftMargin: Theme.marginSize * 3 / 2; }
        state: "h6"
        text: qsTr(trajectoryViewModel.activeTrajectory.name + " Distance (mm)")
        elide: Text.ElideRight
    }

    Button {
        anchors { right: parent.right;
                  bottom: parent.bottom;
                  rightMargin: Theme.marginSize;
                  bottomMargin: Theme.marginSize; }
        state: "active"
        text: qsTr("Confirm")

        onClicked: close()
    }

    ColumnLayout {
        anchors { fill: parent }

        ColumnLayout {
            Layout.topMargin: Theme.marginSize * 4
            Layout.bottomMargin: Theme.marginSize * 4
            Layout.leftMargin: 250

            ColumnLayout {
                Layout.leftMargin: Theme.marginSize * 4

                Image {
                    source: "qrc:/images/ee.svg"
                }
            }

            LayoutSpacer { }

            Image {
                source: "qrc:/images/group-17.svg"
            }
        }
    }

    RowLayout {
        anchors { fill: parent }

        RowLayout {
            spacing: 205
            Layout.leftMargin: Theme.marginSize * 7
            Layout.bottomMargin: Theme.marginSize * 4

            DistanceElementEditor {
                state: "Implant Length"
            }

            ColumnLayout {
                spacing: 50
                Layout.bottomMargin: 100

                DistanceElementEditor {
                    state: "EE Top to Entry"
                }

                DistanceElementEditor {
                    state: "EE Bottom to Entry"
                }
            }
        }
    }
}
