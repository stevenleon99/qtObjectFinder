import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import Enums 1.0
import GmQml 1.0

import ".."

Item {
    width: parent.width
    height: 64

    property string iconColor
    property string instrumentName

    property bool instrumentVisible: false
    property int verifiedStatus: ToolVerifiedStatus.Required
    property var calibratedStatus: ToolCalibratedStatus.NotRequired
    property var calibrationFiles
    property var calibratedFile

    states: [
        State {
            name: "Biopsy Needle"
            PropertyChanges { target: visibilityCircle; visible: false }
            PropertyChanges { target: verifiedIcon; visible: false }
            PropertyChanges {
                target: verifyButton
                visible: true
                enabled: role_verifiedStatus != ToolVerifiedStatus.Passed
                text: (role_verifiedStatus == ToolVerifiedStatus.Passed) ? "Verified" : "Verify"
                onClicked: instrumentVerificationVMID.displayBiopsyNeedleVerificationAlert()
            }
        }
    ]

    RowLayout {
        anchors { fill: parent }
        spacing: 0

        Item {
            id: visibilityCircle
            Layout.fillHeight: true
            Layout.preferredWidth: height

            Rectangle {
                anchors { centerIn: parent }
                height: parent.height / 2
                width: height
                radius: width / 2
                border { width: 3; color: iconColor }
                color: instrumentVisible ? iconColor : Theme.transparent
            }
        }

        Label {
            Layout.fillWidth: true
            state: "body1"
            font.styleName: Theme.mediumFont.styleName
            font.bold: true
            text: instrumentName
        }

        OptionsDropdown {
            id: comboBox
            visible: calibratedStatus != ToolCalibratedStatus.NotRequired
            model: calibrationFiles
            Layout.fillHeight: false
            Layout.rightMargin: Theme.marginSize
            Layout.preferredHeight: Theme.marginSize * 3
            spacing: Theme.marginSize / 2
            popupWidth: 200 + Theme.marginSize

            onModelChanged: comboBox.enabled = calibrationFiles.length != 0

            popup.x: -comboBox.popupWidth/2

            background: Rectangle {
                anchors.fill: parent
                border.color: {
                    if (calibratedStatus == ToolCalibratedStatus.Failed)
                        return Theme.red
                    else if (calibratedStatus == ToolCalibratedStatus.Required)
                        return Theme.disabledColor
                    else if (calibratedStatus == ToolCalibratedStatus.Passed)
                        return Theme.green
                    else
                        return Theme.blue
                }
                color: Theme.backgroundColor
                radius: 4
            }

            contentItem: Text {
                    leftPadding: Theme.marginSize
                    rightPadding: 0
                    text: calibratedFile
                    color: {
                        if (calibratedStatus == ToolCalibratedStatus.Failed)
                            return Theme.red
                        else if (calibratedStatus == ToolCalibratedStatus.Required)
                            return Theme.disabledColor
                        else if (calibratedStatus == ToolCalibratedStatus.Passed)
                            return Theme.green
                        else
                            return Theme.blue
                    }
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

            delegate: ItemDelegate {
                width: comboBox.popupWidth
                enabled: index != calibrationFiles.length-1
                height: Theme.marginSize * 3
                highlighted: calibratedFile == modelData
                background: Rectangle {
                        anchors.fill: parent
                        color: {
                            if (enabled)
                            {
                                return parent.highlighted ? Theme.gunmetal : Theme.foregroundColor;
                            }
                            else
                            {
                                return Theme.black;
                            }
                        }

                    }

                InstrumentCalibrationDelegate {
                    anchors { fill: parent }
                    name: modelData
                    textColor: parent.highlighted ? Theme.blue
                                                  : Theme.white
                }

                MouseArea {
                    anchors { fill: parent }
                    onClicked: {
                        if (!parent.highlighted)
                        {
                            instrumentVerificationVMID.setCalibratedFile(role_InstrumentUuid,modelData);
                        }
                        comboBox.popup.close();
                    }
                }
            }
        }


        IconImage {
            id: verifiedIcon
            sourceSize: Theme.iconSize
            source: "qrc:/icons/register.svg"
            color:  switch(verifiedStatus)
            {
                case ToolVerifiedStatus.Required:
                    return Theme.disabledColor
                case ToolVerifiedStatus.Failed:
                    return Theme.red
                case ToolVerifiedStatus.NotRequired:
                case ToolVerifiedStatus.Passed: 
                    return Theme.green
            }
        }

        Button {
            id: verifyButton
            state: "active"
            visible: false
            text: "Verify"
        }
    }

    DividerLine {
        anchors { bottom: parent.bottom }
        orientation: Qt.Horizontal
    }
}
