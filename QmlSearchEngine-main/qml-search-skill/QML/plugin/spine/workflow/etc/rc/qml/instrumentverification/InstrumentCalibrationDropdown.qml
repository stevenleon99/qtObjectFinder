import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.4 as T
import QtQuick.Window 2.3

import Theme 1.0
import GmQml 1.0
import Enums 1.0

ComboBox {
    id: comboBox
    visible: calibratedStatus != ToolCalibratedStatus.NotRequired

    rightPadding: Theme.margin(2.5)
    spacing: Theme.marginSize / 2
    popupWidth: Theme.margin(27)

    property var calibratedStatus
    property string selectedSerialNumber: ""

    onCountChanged: comboBox.enabled = count > 0

    function colorVal(status) {
        if (calibratedStatus == ToolCalibratedStatus.Failed)
            return Theme.red
        else if (calibratedStatus == ToolCalibratedStatus.Required)
            return Theme.disabledColor
        else if (calibratedStatus == ToolCalibratedStatus.Passed)
            return Theme.green
        else
            return Theme.blue
    }

    background: Rectangle {
        anchors.fill: parent
        border.color: colorVal()
        color: Theme.backgroundColor
        radius: 4
    }

    indicator: ColorImage {
        x: comboBox.mirrored ? comboBox.padding : comboBox.width - width - 4
        y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
        color: comboBox.pressed || comboBox.popup.visible ? Theme.blue : Theme.navyLight
        source: "qrc:/icons/caret-down.svg"
        sourceSize: Theme.iconSize
    }

    contentItem: Text {
        leftPadding: Theme.marginSize
        rightPadding: 0
        text: selectedSerialNumber
        color: colorVal()
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    delegate: ItemDelegate {
        enabled: index != (comboBox.count - 1)
        opacity: enabled ? 1.0 : .32
        width: comboBox.popupWidth
        height: Theme.marginSize * 3
        highlighted: selectedSerialNumber == modelData
        text: modelData
        palette.text: highlighted ? Theme.blue : Theme.white

        background: Rectangle { radius: 4;  opacity: 0.16; color: selectedSerialNumber == modelData ? Theme.blue : Theme.transparent }

        onClicked: {
            if (!parent.highlighted) {
                serialNumbersClicked(modelData);
            }
            comboBox.popup.close();
        }
    }

    popup: T.Popup {
        y: comboBox.height
        x: comboBox.width - comboBox.popupWidth
        width: comboBox.popupWidth
        height: Math.min(contentItem.implicitHeight, comboBox.Window.height - Theme.margin(1))
        topMargin: Theme.margin(1)
        bottomMargin: Theme.margin(1)

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: comboBox.popup.visible ? comboBox.delegateModel : null
            currentIndex: comboBox.highlightedIndex
            highlightMoveDuration: 0

            T.ScrollBar.vertical: ScrollBar {
                visible: parent.height < parent.contentHeight
                padding: Theme.margin(0.5)
            }
        }

        background: Rectangle { radius: 4;  color: Theme.slate900 }
    }
}
