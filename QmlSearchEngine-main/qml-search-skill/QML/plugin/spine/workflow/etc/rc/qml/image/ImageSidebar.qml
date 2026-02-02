import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

import "../components"

Item {
    Layout.preferredWidth: Theme.margin(45)
    Layout.fillHeight: true

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.margin(1)
            spacing: Theme.margin(1)

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                state: "subtitle2"
                font.bold: true
                font.letterSpacing: 1
                color: Theme.navyLight
                text: qsTr("IMAGES")
            }

            Button {
                objectName: "imagesPlusButton"  
                enabled: imageList.count <= 0
                icon.source: "qrc:/icons/plus"
                state: "icon"

                onClicked: importPopupLoader.item.open()
            }
        }

        ImageList {
            id: imageList

            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            PageControls {
                anchors { verticalCenter: parent.verticalCenter }
                width: parent.width
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }

    DescriptiveBackground {
        visible: !imageList.count
        anchors { centerIn: parent }
        z: 1
        source: "qrc:/icons/image-single.svg"
        text: qsTr("No Image Imported")

        Button {
            objectName: "noImageImportButton"
            Layout.topMargin: Theme.marginSize
            Layout.alignment: Qt.AlignHCenter
            state: "available"
            text: qsTr("Import")
            icon.source: "qrc:/icons/image-add.svg"

            onClicked: importPopupLoader.item.open()
        }
    }

    DividerLine {
        orientation: Qt.Vertical
        anchors { left: parent.left }
    }

    ImportPopupLoader {
        id: importPopupLoader
    }
}
