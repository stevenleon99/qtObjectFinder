import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import E3DImageStatesPage 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../imagesidebar"
import "../../../tracking"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    E3DImageViewModel {
        id: e3dImageViewModel
    }

    states: [
        State {
            when: e3dImageViewModel.pageState == E3DImageStatesPage.NoVolumeSelected
            PropertyChanges { target: detectRow; visible: true}
            PropertyChanges { target: detectText; text: qsTr("No Image Selected") }
            PropertyChanges { target: checkmark; source: "qrc:/icons/images.svg"; color: Theme.navyLight; visible: true }
        },
        State {
            when: e3dImageViewModel.pageState == E3DImageStatesPage.E3DVolume
            PropertyChanges { target: detectRow; visible: true}
            PropertyChanges { target: checkmark; source: "qrc:/icons/check.svg"; color: Theme.green; visible: true }
        },
        State {
            when: e3dImageViewModel.pageState == E3DImageStatesPage.NoE3DVolume
            PropertyChanges { target: detectRow; visible: true}
            PropertyChanges { target: checkmark; source: "qrc:/icons/x.svg"; color: Theme.red; visible: true }
        }
    ]

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Image")
            pageNumber: 2
            maxPageNumber: 4
            description: qsTr("Select image with E3D.")
        }

        ColumnLayout {
            Layout.fillHeight: false
            Layout.fillWidth: true
            spacing: 0
            Label {
                id: label
                Layout.fillWidth: true
                state: "body1"
                color: Theme.navyLight
                text: qsTr("Image Name")
                Layout.leftMargin: Theme.marginSize
                Layout.topMargin: Theme.marginSize/2
            }

            RowLayout {
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: Theme.margin(1)
                Layout.fillHeight: false
                Layout.topMargin: Theme.marginSize/4
                spacing: Theme.margin(1)

                OptionsDropdown {
                    id: comboBox
                    Layout.preferredHeight: Theme.margin(6)
                    Layout.preferredWidth: Theme.margin(35)
                    textRole: "role_label"
                    currentIndex: e3dImageViewModel.e3dVolumeIndex()
                    displayText: e3dImageViewModel.pageState == E3DImageStatesPage.NoVolumeSelected ? qsTr("Select Image") : currentText

                    model: e3dImageViewModel.e3dVolumeListModel

                    onActivated: {
                        var index = e3dImageViewModel.e3dVolumeListModel.index(index, 0)
                        e3dImageViewModel.selectVolume(model.data(index,256))
                    }
                }

                Button {
                    Layout.fillHeight: true
                    enabled: applicationViewModel.canImportVolume
                    Layout.alignment: Qt.AlignVCenter
                    icon.source: "qrc:/icons/image-add.svg"
                    state: "icon"

                    onClicked: importPopupLoader.item.open()
                }

                ImportPopupLoader {
                    id: importPopupLoader
                }
            }

            RowLayout {
                id: detectRow
                visible: false
                Layout.preferredHeight: Theme.margin(6)
               Layout.preferredWidth: Theme.margin(40)
               Layout.margins: Theme.marginSize
               spacing: Theme.marginSize

                IconImage {
                    id: checkmark
                    visible: false
                    source: "qrc:/icons/check.svg"
                    sourceSize: Theme.iconSize
                    color: Theme.green
                }

                Label {
                    id: detectText
                    Layout.fillWidth: true
                    state: "subtitle1"
                    text: "E3D Registered"
                }
            }
        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false
            backEnabled: true
            forwardEnabled: e3dImageViewModel.isE3DRegistered

            onBackClicked: applicationViewModel.switchToPage(AppPage.E3dSetup)

            onForwardClicked: applicationViewModel.switchToPage(e3dImageViewModel.nextPage)
        }
    }

    DividerLine { }
}
