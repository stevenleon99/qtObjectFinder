import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import GmQml 1.0

import ".."

RowLayout {
    spacing: 0
    Layout.preferredWidth: 360
    Layout.preferredHeight: 64

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            anchors { fill: parent }
            spacing: 0

            RowLayout {
                spacing: 0
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                IconImage {
                    scale: 0.6
                    source: "qrc:/icons/3d.svg"
                    color: applicationViewModel.currentPage == AppPage.PostOpCt?Theme.blue:Theme.headerTextColor
                }

                Label {
                    state: "subtitle1"
                    color: applicationViewModel.currentPage == AppPage.PostOpCt?Theme.blue:Theme.white
                    text: qsTr("CT")
                }
            }

            DividerLine {
                visible: applicationViewModel.currentPage == AppPage.PostOpCt
                color: Theme.blue
                lineThickness: 2
            }
        }

        MouseArea {
            anchors { fill: parent }
            onClicked: applicationViewModel.switchToPage(AppPage.PostOpCt)
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: !applicationViewModel.laptopTypeEnabled

        ColumnLayout {
            anchors { fill: parent }
            spacing: 0

            RowLayout {
                spacing: 0
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                IconImage {
                    scale: 0.6
                    source: "qrc:/icons/image-fluoro.svg"
                    color: applicationViewModel.currentPage == AppPage.PostOpFluoro?Theme.blue:Theme.headerTextColor
                }

                Label {
                    state: "subtitle1"
                    color: applicationViewModel.currentPage == AppPage.PostOpFluoro?Theme.blue:Theme.white
                    text: qsTr("Fluoro")
                }
            }

            DividerLine {
                visible: applicationViewModel.currentPage == AppPage.PostOpFluoro
                color: Theme.blue
                lineThickness: 2
            }
        }

        MouseArea {
            anchors { fill: parent }
            onClicked: applicationViewModel.switchToPage(AppPage.PostOpFluoro)
        }
    }
}
