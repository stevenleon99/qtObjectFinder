import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../components"

ColumnLayout {
    Layout.topMargin: Theme.margin(17)
    spacing: Theme.margin(4)

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(10)

        RowLayout {
            anchors {
                left: parent.left;
                leftMargin: Theme.margin(3);
                verticalCenter: parent.verticalCenter
            }
            spacing: Theme.marginSize
            Button {
                state: "icon"
                icon.source: "qrc:/icons/arrow.svg"
                icon.width: Theme.iconSize.width * 2
                icon.height: Theme.iconSize.height * 2

                onClicked: loader.state = "pinpad"
            }

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                state: "h5"
                font.bold: true
                text: qsTr("Login")
            }
        }

        DividerLine {
            anchors { bottom: parent.bottom }
            orientation: Qt.Horizontal
            lineThickness: 2
            color: Theme.white
            opacity: 0.5
        }
    }

    Flickable {
        id: flickable
        Layout.preferredWidth: Theme.margin(226)
        Layout.preferredHeight: Theme.margin(81)
        Layout.leftMargin: Theme.margin(3)
        contentHeight: userContainer.height
        clip: true

        ScrollBar.vertical: ScrollBar {
            id: scrollbar
            visible: parent.contentHeight > parent.height
            Layout.preferredHeight: parent.height
            padding: Theme.marginSize
        }

        ColumnLayout {
            id: userContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Theme.margin(3)
            Layout.rightMargin: Theme.margin(11)
            spacing: Theme.margin(4)

            Loader {
                visible: active
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(10)
                active: serviceUserList.count
                sourceComponent: Item {
                    width: parent.width
                    height: parent.height

                    Label {
                        anchors { verticalCenter: parent.verticalCenter }
                        state: "h5"
                        font.bold: true
                        text: qsTr("Service Users")
                    }

                    DividerLine {
                        anchors { bottom: parent.bottom }
                        orientation: Qt.Horizontal
                        lineThickness: 2
                        color: Theme.white
                        opacity: 0.5
                    }
                }
            }

            UserList {
                id: serviceUserList
                visible: serviceUserList.count
                model: SortFilterProxyModel {
                    sourceModel: activeUsers
                    Component.onCompleted: {
                        filterRoleName = "role_serviceAccess";
                        filterRegExp = /^true$/;
                    }
                }
            }

            Loader {
                visible: active
                Layout.fillWidth: true
                active: serviceUserList.count
                Layout.preferredHeight: Theme.margin(10)
                sourceComponent: Item {
                    width: parent.width
                    height: parent.height

                    Label {
                        anchors { verticalCenter: parent.verticalCenter }
                        state: "h5"
                        text: qsTr("Clinical Users")
                    }

                    DividerLine {
                        anchors { bottom: parent.bottom }
                        orientation: Qt.Horizontal
                        lineThickness: 2
                        color: Theme.white
                        opacity: 0.5
                    }
                }
            }

            UserList {
                id: clinicalUserList
                visible: clinicalUserList.count
                model: SortFilterProxyModel {
                    sourceModel: activeUsers
                    Component.onCompleted: {
                        filterRoleName = "role_serviceAccess";
                        filterRegExp = /^false$/;
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: Theme.margin(223)
                Layout.preferredHeight: Theme.margin(70)
                Layout.bottomMargin: Theme.margin(11)
                spacing: 0
                visible: (serviceUserList.count === 0) &&
                              (clinicalUserList.count === 0)

                LayoutSpacer {}

                IconImage {
                    Layout.alignment: Qt.AlignHCenter
                    color: Theme.navyLight
                    sourceSize: Qt.size(72, 72)
                    source: "qrc:/icons/man.svg"
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    state: "h6"
                    color: Theme.navyLight
                    text: qsTr("No Users Added")
                }

                LayoutSpacer {}
            }
        }
    }

    Item { Layout.fillWidth: true; Layout.preferredHeight: Theme.marginSize * 4.75 }

    Button {      
        objectName: "autoNewUserBtnObj"
        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: Theme.marginSize
        text: qsTr("New User")
        icon.source: "qrc:/icons/plus.svg"
        state: "available"

        onClicked: userActivationPopup.open()
    }

    UserActivationPopup {
        id: userActivationPopup

        onCreateUser: {
            if (userViewModel.isServiceUserKey(email, key)) {
                createServiceUserDialog.email = email
                createServiceUserDialog.activationKey = key
                createServiceUserDialog.open()
            }
            else {
                createUserDialog.email = email
                createUserDialog.activationKey = key
                createUserDialog.open()
            }
        }
    }

    SortFilterProxyModel {
        id: activeUsers
        sourceModel: userViewModel.userList
        Component.onCompleted: {
            filterRoleName = "role_active";
            filterRegExp = /^true$/;
        }
    }

    CreateUserDialog { id: createUserDialog }

    CreateServiceUserDialog { id: createServiceUserDialog }

    ServiceUserPopup { id: serviceUserPopup }
}
