import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import GmQml 1.0


Popup {
    id: popup
    width: 250
    height: 300

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    SkinMeshViewModel {
        id: skinMeshViewModel
    }

    Connections
    {
        target:skinMeshViewModel

        onIsTaskRunningChanged: {
            if (!skinMeshViewModel.isTaskRunning && popup.opened)
            {
                popup.close();
            }
        }
    }

    function setup(positionItem) {
        var bottomLeft = positionItem.mapToItem(null, 0, positionItem.height)
        x = bottomLeft.x
        y = bottomLeft.y - 200

        open()
    }

    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: parent.height
        spacing: 5

        RowLayout {
            //Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            spacing: Theme.marginSize / 2

            Label {
                state: "body1"
                text: qsTr("Mesh")
                color: Theme.white
            }

            Button {
                state: "icon"
                icon.source: skinMeshViewModel.isMeshVisible ? "qrc:/icons/visibility-on.svg"
                                                                          : "qrc:/icons/visibility-off.svg"

                onClicked: skinMeshViewModel.toggleMeshVisibility()
            }

            LayoutSpacer {}

            Button {
                icon.source: "qrc:/images/x.svg"
                state: "icon"

                onClicked: skinMeshPopup.visible = false
            }

        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            Label {
                Layout.preferredHeight: 21
                Layout.fillWidth: true
                Layout.alignment: Layout.left
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Threshold (intensity)")
                color: Theme.navyLight
            }
            Label {
                Layout.preferredHeight: 21
                Layout.alignment: Layout.right
                //Layout.fillWidth: true
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: skinMeshViewModel.threshold
                color: Theme.white
            }
        }

        Slider {
            visible: true
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize *2
            Layout.rightMargin: Theme.marginSize
            orientation: Qt.Horizontal
            from: skinMeshViewModel.minThreshold
            value: skinMeshViewModel.threshold
            to: skinMeshViewModel.maxThreshold

            onValueChanged: skinMeshViewModel.threshold = value
        }

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize

            Label {
                Layout.fillWidth: true
                Layout.preferredHeight: 21
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Smoothing (pixels)")
                color: Theme.navyLight
            }
            Label {
                Layout.preferredHeight: 21
                Layout.alignment: Layout.right
                //Layout.fillWidth: true
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: skinMeshViewModel.smoothing
                color: Theme.white
            }
        }

        Slider {
            visible: true
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize *2
            Layout.rightMargin: Theme.marginSize
            orientation: Qt.Horizontal
            from: 0
            value: skinMeshViewModel.smoothing
            to: 5

            onValueChanged: skinMeshViewModel.smoothing = value
        }


        Button {
            Layout.topMargin: Theme.marginSize
            visible: true
            enabled: !skinMeshViewModel.isTaskRunning
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            state: !skinMeshViewModel.isTaskRunning?"active":"hinted"
            text: "Generate"

            onClicked: {
                if (enabled)
                    skinMeshViewModel.runSkinExtraction();
            }
        }

//        LayoutSpacer {}


    }
}
