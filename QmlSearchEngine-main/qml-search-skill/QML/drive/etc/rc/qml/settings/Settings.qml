import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0
import DriveEnums 1.0

import "../components"

Item {

    ColumnLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize }
        spacing: 0

        RowLayout {
            Layout.fillHeight: false
            Layout.preferredHeight: Theme.margin(10)
            spacing: 0

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Settings"
                state: "h5"
                font.pixelSize: 28
                font.styleName: Theme.mediumFont.styleName
            }

            HeaderSelection {
                objectName: "autoGeneralSettingsObj"
                Layout.fillHeight: true
                icon.source: "qrc:/icons/tools.svg"
                text: qsTr("General")
                active: loader.state === "general"

                onSelected: loader.state = "general"
            }

            HeaderSelection {
                objectName: "autoUserSettingsObj"
                Layout.fillHeight: true
                icon.source: "qrc:/icons/man.svg"
                text: qsTr("User")
                active: loader.state === "user"

                onSelected: loader.state = "user"
            }

            HeaderSelection {
                objectName: "autoHipPluginSettingsObj"
                Layout.fillHeight: true
                visible: licenseManagerViewModel.licenseFileValid("apps_plugin_hip_old_settings")
                icon.source: "qrc:/icons/hip_old.svg"
                text: qsTr("Hip")
                active: loader.state === "hip"

                onSelected: loader.state = "hip"
            }

			HeaderSelection {
                objectName: "autoCranialPluginSettingsObj"
                Layout.fillHeight: true
                visible: licenseManagerViewModel.licenseFileValid("apps_plugin_cranial_settings")
                icon.source: "qrc:/icons/cranial.svg"
                text: qsTr("Cranial")
                active: loader.state === "cranial"

                onSelected: loader.state = "cranial"
            }

            HeaderSelection {
                objectName: "autoKneePluginSettingsObj"
                Layout.fillHeight: true
                visible: licenseManagerViewModel.licenseFileValid("apps_plugin_knee_settings")
                icon.source: "qrc:/icons/knee.svg"
                text: qsTr("Knee")
                active: loader.state === "knee"

                onSelected: loader.state = "knee"
            }

            HeaderSelection {
                objectName: "autoSpinePluginSettingsObj"
                Layout.fillHeight: true
                visible: licenseManagerViewModel.licenseFileValid("apps_plugin_spine_surgeonsettings")
                icon.source: "qrc:/icons/orientation/axial.svg"
                text: qsTr("Spine")
                active: loader.state === "spine"

                onSelected: loader.state = "spine"
            }

            HeaderSelection {
                objectName: "autoEgpsPluginSettingsObj"
                Layout.fillHeight: true
                visible: userViewModel.platformType === PlatformType.Egps
                icon.source: "qrc:/icons/robot-arm.svg"
                text: qsTr("ExcelsiusGPS")
                active: loader.state === "egps"

                onSelected: loader.state = "egps"
            }

            HeaderSelection {
                objectName: "autoEhubPluginSettingsObj"
                Layout.fillHeight: true
                visible: userViewModel.platformType === PlatformType.Ehub
                icon.source: "qrc:/icons/ehub.svg"
                text: qsTr("ExcelsiusHUB")
                active: loader.state === "ehub"

                onSelected: loader.state = "ehub"
            }

            HeaderSelection {
                objectName: "autoEflexPluginSettingsObj"
                Layout.fillHeight: true
                visible: userViewModel.platformType === PlatformType.Ehub &&
                            licenseManagerViewModel.licenseFileValid("apps_plugin_eflex_settings")
                icon.source: "qrc:/icons/eflex.svg"
                text: qsTr("EFlex")
                active: loader.state === "eflex"

                onSelected: loader.state = "eflex"
            }

            HeaderSelection {
                objectName: "autoLaptopPluginSettingsObj"
                Layout.fillHeight: true
                visible: userViewModel.platformType === PlatformType.Laptop
                icon.source: "qrc:/icons/laptop.svg"
                text: qsTr("Laptop")
                active: loader.state === "laptop"

                onSelected: loader.state = "laptop"
            }

            HeaderSelection {
                objectName: "autoServiceSettingsObj"
                Layout.fillHeight: true
                /*
                This page only displayed the system volume slider. The need
                for a service user to be able to adjust the system volume from
                here is not needed as they can adjust the system volumne from
                the "Admin" account desktop. Currently there are no other options
                on this page so no need to show the page.
                */
                visible: false /*userViewModel.activeUser.isServiceUser*/
                icon.source: "qrc:/icons/person-wrench.svg"
                text: qsTr("Service")
                active: loader.state === "service"

                onSelected: loader.state = "service"
            }

            HeaderSelection {
                objectName: "autoAboutSettingsObj"
                Layout.fillHeight: true
                icon.source: "qrc:/icons/info-circle-fill.svg"
                text: qsTr("About")
                active: loader.state === "about"

                onSelected: loader.state = "about"
            }

            LayoutSpacer { }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Label.AlignRight
                text: currentTime.toLocaleString(locale, "dd-MMM-yyyy hh:mm AP").toUpperCase()
                state: "body1"
                font.bold: true

                property date currentTime: new Date()

                Timer {
                    interval: 10*1000 //in milliseconds
                    running: true
                    repeat: true
                    onTriggered: parent.currentTime = new Date()
                }
            }
        }

        DividerLine { }

        RowLayout{
            Layout.leftMargin: Theme.margin(2)
            Layout.topMargin: Theme.margin(4)
            spacing:0
            Layout.fillWidth:true
            Layout.fillHeight:true

            SettingsMenu {
                id: settingsMenu
                Layout.alignment:  Qt.AlignTop | Qt.AlignLeft

                visible: menuModel != undefined
                containerItem: flickable
                model: menuModel
                animationTarget: flickable
            }


        Flickable {
            id: flickable
            objectName: "settingsFlickable"
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentHeight: loader.item.height + (Theme.marginSize * 2)

            ScrollBar.vertical: ScrollBar {
                visible: parent.contentHeight > parent.height
                Layout.preferredHeight: parent.height
                padding: Theme.marginSize
            }

            Loader {
                id: loader
                objectName: "settingsLoader"
                width: flickable.width / 2

                state: "general"
                source: "GeneralSettings.qml"

                    onItemChanged: {
                        flickable.contentY = 0;
                        settingsMenu.activeIndex = 0;
                    }


                states: [
                    State {
                        name: "general"
                        PropertyChanges { target: loader; source: "GeneralSettings.qml" }
                    },
                    State {
                        name: "user"
                        PropertyChanges { target: loader; source: "user/UserSettings.qml" }
                            PropertyChanges { target: settingsMenu; menuVisible: false}
                    },
                    State {
                        name: "hip"
                        PropertyChanges { target: loader; source: "HipSettings.qml" }
                    },
                    State {
                        name: "knee"
                        PropertyChanges { target: loader; source: "KneeSettings.qml" }
                    },
                    State {
                        name: "spine"
                        PropertyChanges { target: loader; source: "SpineSettings.qml" }
                    },
                    State {
                        name: "egps"
                        PropertyChanges { target: loader; source: "EgpsSettings.qml" }
                    },
                    State {
                        name: "ehub"
                        PropertyChanges { target: loader; source: "EhubSettings.qml" }
                    },
                    State {
                        name: "eflex"
                        PropertyChanges { target: loader; source: "EflexSettings.qml" }
                    },
                    State {
                        name: "cranial"
                        PropertyChanges { target: loader; source: "CranialSettings.qml" }
                    },
                    State {
                        name: "laptop"
                        PropertyChanges { target: loader; source: "LaptopSettings.qml" }
                            PropertyChanges { target: settingsMenu; menuVisible: false}
                    },
                    State {
                        name: "about"
                        PropertyChanges { target: loader; source: "About.qml" }
                            PropertyChanges { target: settingsMenu; menuVisible: false}
                    },
                    State {
                        name: "service"
                        PropertyChanges { target: loader; source: "service/ServiceSettings.qml" }
                            PropertyChanges { target: settingsMenu; menuVisible: false}
                    }
                ]
            }
        }
    }
    }
}
