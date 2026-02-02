import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

ColumnLayout {
    spacing: 0

    property var distance;
    property var viewModel;

    signal landmarkClickedParent(var landmark);
    signal resetClickedParent(var landmark);
    signal setClickedParent(var landmark);

    SectionHeader {
        title: qsTr("LANDMARKS")
    }

    ColumnLayout {
        Layout.fillHeight: false
        Layout.leftMargin: Theme.marginSize
        Layout.rightMargin: Theme.marginSize
        spacing: Theme.marginSize / 2

        ColumnLayout {
            spacing: Theme.marginSize

            Repeater {
                model: ListModel {
                    ListElement { role_landmark: "AC"; role_source: "qrc:/icons/register.svg" }
                    ListElement { role_landmark: "PC"; role_source: "qrc:/icons/register.svg" }
                    ListElement { role_landmark: "Midline"; role_source: "qrc:/icons/measure-line.svg" }
                }

                delegate: ACPCLandmarksListDelegate {
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                    icon: role_source
                    text: role_landmark
                    set: switch (role_landmark) {
                         case "AC": return orientViewModel.acSet
                         case "PC": return orientViewModel.pcSet
                         case "Midline": return orientViewModel.midlineSet
                         default: return false
                         }

                    selected: switch (role_landmark) {
                                case "AC": return orientViewModel.isAcSelected
                                case "PC": return orientViewModel.isPcSelected
                                case "Midline": return orientViewModel.isMidlineSelected
                                default: return false
                                }

                    onLandmarkClicked: landmarkClickedParent(role_landmark)

                    onResetClicked: resetClickedParent(role_landmark)

                    onSetClicked: setClickedParent(role_landmark)
                }
            }
        }

        ACPCLandmarksDistance {
            Layout.fillHeight: false
            value: distance
        }
    }
}
