import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

ColumnLayout {
    id: control
    spacing: Theme.margin(1)

    property alias header: label.text
    property alias text: textField.text

    states: [
        State {
            name: "ipAddress"
            PropertyChanges {
                target: textField
                maximumLength: 15
                placeholderText: "Ex. 000.000.000.000"
                validator: ipValidator
            }
        },
        State {
            name: "macAddress"
            PropertyChanges {
                target: textField
                placeholderText: "00:00:00:00:00:00"
                enabled: false
            }
        }
    ]
    
    RegExpValidator { id: ipValidator; regExp: /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]|[3-9]?[0-9])\.){3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]|[3-9]?[0-9])$/ }

    Label {
        id: label
        state: "body1"
        color: textField.activeFocus && control.enabled ? Theme.blue : Theme.navyLight
    }

    TextField {
        id: textField
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(6)
        font { pixelSize: 21 }
    }
}
