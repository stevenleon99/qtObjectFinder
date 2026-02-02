import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."

ColumnLayout {
    spacing: 0
    Layout.preferredWidth: parent.width

    RowLayout {
        Layout.margins: spacing
        spacing: Theme.margin(2)

        Label {
            Layout.fillWidth: false
            state: "caption"
            color: Theme.navyLight
            font.bold: true
            text: qsTr("FX")
        }

        LayoutSpacer {}

        Label {
            state: "caption"
            color: imageDetailsVM.edit2DWindowLevel ? Theme.blue : Theme.disabledColor
            text: qsTr("2D")

            Rectangle {
                anchors.centerIn: parent
                width: 28
                height: width
                radius: 5
                color: imageDetailsVM.edit2DWindowLevel ? Theme.blue : Theme.transparent
                opacity: 0.25

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (!imageDetailsVM.edit2DWindowLevel)
                        {
                            imageDetailsVM.toggleOn2DWindowLevel()
                        }
                    }
                }
            }
        }

        Label {
            state: "caption"
            color: imageDetailsVM.edit2DWindowLevel ? Theme.disabledColor : Theme.blue
            text: qsTr("3D")

            Rectangle {
                anchors.centerIn: parent
                width: 28
                height: width
                radius: 5
                color: imageDetailsVM.edit2DWindowLevel ? Theme.transparent : Theme.blue
                opacity: 0.25

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (imageDetailsVM.edit2DWindowLevel)
                        {
                            imageDetailsVM.toggleOn3DWindowLevel()
                        }
                    }
                }
            }
        }

        Button {
            id: resetId
            state: "icon"
            icon.source: "qrc:/icons/reset.svg"
            icon.color: Theme.white

            onClicked: {
                if (imageDetailsVM.edit2DWindowLevel)
                {
                    imageDetailsVM.resetWindowLevel2D()
                }
                else
                {
                    imageDetailsVM.resetWindowLevel3D()
                }
            }
        }
    }

    RowLayout {
        Layout.margins: spacing
        spacing: Theme.margin(2)

        Label {
            Layout.fillWidth: false
            state: "caption"
            color: Theme.disabledColor
            text: qsTr("Window")
        }

        LayoutSpacer {}

        Label {
            Layout.fillWidth: false
            state: "body1"
            color: Theme.white
            font.bold: true
            text: imageDetailsVM.edit2DWindowLevel ? imageDetailsVM.window2D.toFixed(0).toString() : imageDetailsVM.window3D.toFixed(0).toString()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (imageDetailsVM.edit2DWindowLevel)
                    {
                        windowLevelCalculator.setup(parent,
                                                    imageDetailsVM.window2D.toFixed(0),
                                                    "",
                                                    "",
                                                    "",
                                                    (value) => { imageDetailsVM.setWindow2D(value) })
                    }
                    else
                    {
                        windowLevelCalculator.setup(parent,
                                                    imageDetailsVM.window3D.toFixed(0),
                                                    "",
                                                    "",
                                                    "",
                                                    (value) => { imageDetailsVM.setWindow3D(value) })
                    }
                }

                CalculatorLPS {
                    id: windowLevelCalculator
                    positionAbove: true
                }
            }
        }
    }

    Slider {
        id: windowSlider
        width: parent.width - Theme.margin(1)
        Layout.alignment: Qt.AlignHCenter
        from: imageDetailsVM.windowMinLimit
        value: imageDetailsVM.edit2DWindowLevel ? imageDetailsVM.window2D : imageDetailsVM.window3D
        to: imageDetailsVM.windowMaxLimit
        handle: Rectangle {
            x: windowSlider.leftPadding + windowSlider.visualPosition * (windowSlider.availableWidth - width)
            y: windowSlider.topPadding + (windowSlider.availableHeight - height) / 2
            implicitWidth: Theme.marginSize * 2
            implicitHeight: width
            radius: width / 2
            color: windowSlider.pressed ? Theme.blue : Theme.white
        }

        onMoved: {
            if (imageDetailsVM.edit2DWindowLevel)
            {
                imageDetailsVM.setWindow2D(value)
            }
            else
            {
                imageDetailsVM.setWindow3D(value)
            }
        }
    }

    RowLayout {
        Layout.margins: spacing
        spacing: Theme.margin(2)

        Label {
            Layout.fillWidth: false
            state: "caption"
            color: Theme.disabledColor
            text: qsTr("Level")
        }

        LayoutSpacer {}

        Label {
            Layout.fillWidth: false
            state: "body1"
            color: Theme.white
            font.bold: true
            text: imageDetailsVM.edit2DWindowLevel ? imageDetailsVM.level2D.toFixed(0).toString() : imageDetailsVM.level3D.toFixed(0).toString()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (imageDetailsVM.edit2DWindowLevel)
                    {
                        windowLevelCalculator.setup(parent,
                                                    imageDetailsVM.level2D.toFixed(0),
                                                    "",
                                                    "",
                                                    "",
                                                    (value) => { imageDetailsVM.setLevel2D(value) })
                    }
                    else
                    {
                        windowLevelCalculator.setup(parent,
                                                    imageDetailsVM.level3D.toFixed(0),
                                                    "",
                                                    "",
                                                    "",
                                                    (value) => { imageDetailsVM.setLevel3D(value) })
                    }
                }
            }
        }
    }

    Slider {
        id: levelSlider
        width: parent.width - Theme.margin(1)
        Layout.alignment: Qt.AlignHCenter
        from: imageDetailsVM.levelMinLimit
        value: imageDetailsVM.edit2DWindowLevel ? imageDetailsVM.level2D : imageDetailsVM.level3D
        to: imageDetailsVM.levelMaxLimit
        handle: Rectangle {
            x: levelSlider.leftPadding + levelSlider.visualPosition * (levelSlider.availableWidth - width)
            y: levelSlider.topPadding + (levelSlider.availableHeight - height) / 2
            implicitWidth: Theme.marginSize * 2
            implicitHeight: width
            radius: width / 2
            color: levelSlider.pressed ? Theme.blue : Theme.white
        }

        onMoved: {
            if (imageDetailsVM.edit2DWindowLevel)
            {
                imageDetailsVM.setLevel2D(value)
            }
            else
            {
                imageDetailsVM.setLevel3D(value)
            }
        }
    }

}
