import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.impl 2.5

import Theme 1.0
import ViewModels 1.0

RowLayout {
    spacing: 0

    property bool usePassword: false
    property int remainingAttemptCount: userViewModel.loginAttemptsRemaining

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredHeight: Theme.margin(6)
        Layout.fillWidth: false
        spacing: Theme.margin(1)

        IconImage {
            source: "qrc:/icons/case-info.svg"
            sourceSize: Theme.iconSize
            color: Theme.red
        }

        Label {
            state: "subtitle1"
            text: remainingAttemptCount > 0 ? qsTr("Wrong ") + codeText + qsTr(". ") + remainingAttemptCount + qsTr(" attempts remaining...")
                                            : qsTr("Too many failed attempts. Password reset required.")

            property string codeText: usePassword ? qsTr("Password") : qsTr("PIN")
        }
    }
}
