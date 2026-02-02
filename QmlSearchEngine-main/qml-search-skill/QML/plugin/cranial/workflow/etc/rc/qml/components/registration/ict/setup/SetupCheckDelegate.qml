import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

RowLayout {
    Layout.fillWidth: true
    spacing: Theme.marginSize

    property bool checked: false
    property string text
    property bool isInfo: false

    property alias iconSource: icon.source
    property alias color: icon.color

    states: [
        State {
            when: !isInfo && checked
            PropertyChanges { target: check; color: Theme.green; border.color: Theme.green }
            PropertyChanges { target: icon; source: "qrc:/icons/check.svg"; color: Theme.black }
        },
        State {
            when: !isInfo && !checked
            PropertyChanges { target: check; color: Theme.transparent; border.color: Theme.navyLight }
            PropertyChanges { target: icon; source: "qrc:/icons/x.svg"; color: Theme.navyLight }
        },
        State {
            name:"info"
            when: isInfo
            PropertyChanges { target: check; color: Theme.transparent; border.color: Theme.transparent }
            PropertyChanges { target: icon; source: "qrc:/icons/case-info.svg"; color: Theme.blue }
        }
    ]

    Rectangle {
        id: check
        Layout.preferredWidth: Theme.marginSize * 2
        Layout.preferredHeight: Theme.marginSize * 2
        Layout.alignment: Qt.AlignVCenter | Qt.AlignTop
        radius: width / 2

        IconImage {
            id: icon
            anchors { centerIn: parent }
            sourceSize: Theme.iconSize
        }
    }

    Label {
        id: label
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 480
        state: "subtitle1"
        wrapMode: Label.Wrap
        text: parent.text
    }
}
