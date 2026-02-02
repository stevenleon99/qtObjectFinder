import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "../components"

Popup {
    id: namePopup

    y: 249
    width: 640
    height: 385
    closePolicy: Popup.NoAutoClose

    /**
     * Regular expression to validate the acceptable date format dd-MM-yyyy
     * Supports year value from 1900
     *
     * Eg:
     * Successful match
     * 03-04-1981
     * 12-20-1900
     * 02-29-2020  - leap year
     * 01-31-2020
     *
     * Fail to match
     * 03-04-81 - invalid year
     * 02-29-2021  - not a leap year
     * 29-12-2021 - dd-MM-yyyy format
     * Jan-29-2021 - Invalid month
     * 01-32-2021 - invalid date > 31
     * 04-31-2021 - invalid date, no 31 in April
     * 04-30-1899 - invalid year < 1900
     * 03/04/1981 - invalid separator
     */

    readonly property var dateRegExp: /(^(((0[1-9]|1[012])[\-](0[1-9]|1[0-9]|2[0-8]))|((0[13578]|1[02])[\-](29|30|31))|((0[4,6,9]|11)[\-](29|30)))[\-](19|[2-9][0-9])\d\d$)|(^(02)[\-]29[\-](19|[2-9][0-9])(00|04|08|12|16|20|24|28|32|36|40|44|48|52|56|60|64|68|72|76|80|84|88|92|96)$)/


    signal createClicked(string patientLastName, string patientFirstName, string dob)

    modal: true
    Overlay.modal: Rectangle { color: Qt.rgba(0, 0, 0, 0.75) }

    contentItem: Rectangle {
        width: namePopup.width
        height: namePopup.height
        color: Theme.backgroundColor
        radius: 8
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 0

            Label {
                Layout.fillWidth: true
                text: qsTr("New Patient")
                font.bold: true
                font.pixelSize: 40
                color: Theme.white
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.marginSize

                TitledTextField {
                    id: firstNameInput
                    Layout.preferredWidth: Theme.margin(30)
                    title: qsTr("First Name")
                }

                TitledTextField {
                    id: lastNameInput
                    Layout.preferredWidth: Theme.margin(30)
                    title: qsTr("Last Name")
                }
            }

            TitledTextField {
                id: dobInput
                Layout.preferredWidth: Theme.margin(30)
                placeholderText: "MM-DD-YYYY"
                validator: RegExpValidator { regExp: dateRegExp }
                title: qsTr("Date of Birth (MM-DD-YYYY)")

                property string originalText

                onTextChanged: {
                    var tempText = text
                    if (tempText.length === 2 || tempText.length === 5) {
                        if (originalText.length < tempText.length)
                            tempText = tempText + "-"
                        else if (originalText.length > tempText.length)
                            tempText = tempText.substring(0, tempText.length - 1)
                    }

                    originalText = tempText
                    text = tempText
                }

                Component.onCompleted: originalText = text
            }

            RowLayout {
                id: layout
                Layout.alignment: Qt.AlignRight
                spacing: Theme.marginSize

                Button {
                    objectName: "autoUIPatientCancelBtnObj"
                    Layout.preferredWidth: 128
                    state: "available"
                    text: qsTr("Cancel")

                    onClicked: close()
                }

                Button {
                    objectName: "autoUIPatientCreateBtnObj"
                    Layout.preferredWidth: 128
                    enabled: firstNameInput.text && lastNameInput.text &&
                             dobInput.text && dobInput.text.match(dateRegExp)
                    state: "active"
                    text: qsTr("Create")

                    onClicked: {
                        createClicked(lastNameInput.text, firstNameInput.text, dobInput.text);
                        close()
                    }
                }
            }
        }
    }

    onOpened: {
        firstNameInput.text = Qt.formatDateTime(new Date(), "dd-MMM-yyyy hh:mm:ss").toUpperCase();
        lastNameInput.text = qsTr("Patient");
        dobInput.text = "";
        firstNameInput.forceActiveFocus();
    }
}
