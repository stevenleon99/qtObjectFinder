import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0

import "../components"

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    property var patientDetails

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

    signal saveClicked

    DetailsTabBar {
        id: tabBar
        Layout.preferredHeight: Theme.marginSize * 4
        thumbnailCount: scanListModel.count
    }

    StackLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: Theme.marginSize * .75
        Layout.bottomMargin: Theme.marginSize

        currentIndex: tabBar.currentIndex

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.marginSize

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.marginSize

                TitledTextField {
                    id: firstNameInput
                    Layout.preferredWidth: Theme.margin(29)
                    title: qsTr("First Name*")
                    text: patientDetails.patientFirstName
                }

                TitledTextField {
                    id: lastNameInput
                    Layout.preferredWidth: Theme.margin(29)
                    title: qsTr("Last Name*")
                    text: patientDetails.patientLastName
                }
            }

            TitledTextField {
                id: dobInput
                Layout.preferredWidth: Theme.marginSize * 20
                placeholderText: "MM-DD-YYYY"
                validator: RegExpValidator { regExp: dateRegExp }
                title: qsTr("Date of Birth (MM-DD-YYYY)*")
                text: dobInput.dateOfBirth.toLocaleString(Qt.locale(), "MM-dd-yyyy")

                property var dateOfBirth: Date.fromLocaleString(Qt.locale(), patientDetails.dateOfBirth, "d-MMM-yyyy")
                property string originalText

                onTextChanged: {
                    var tempText = text
                    if (tempText.length === 2 || tempText.length === 5)
                    {
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

            TitledTextField {
                id: medicalIDInput
                Layout.preferredWidth: Theme.marginSize * 20
                title: qsTr("Medical ID")
                text: patientDetails.medicalId
            }

            TitledTextField {
                id: heightInput
                Layout.preferredWidth: Theme.marginSize * 20
                inputMethod: TitledTextField.InputMethod.Digits
                validator: IntValidator { bottom: 0; top: userViewModel.useMetric ? 999 : 99 }
                title: userViewModel.useMetric ? qsTr("Height (cm)") : qsTr("Height (in.)")
                text: patientDetails.height

                property int heightVal: (heightInput.text === "") ? 0
                                            : parseInt(heightInput.text)
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.marginSize

                TitledTextField {
                    id: weightInput
                    Layout.preferredWidth: Theme.marginSize * 20
                    inputMethod: TitledTextField.InputMethod.Digits
                    validator: IntValidator { bottom: 0; top: 999 }
                    title: userViewModel.useMetric ? qsTr("Weight (kg)") : qsTr("Weight (lbs)")
                    text: patientDetails.weight

                    property int weight: (weightInput.text === "") ? 0
                                                : parseInt(weightInput.text)
                }

                TitledTextField {
                    enabled: false
                    Layout.preferredWidth: Theme.marginSize * 12
                    title: qsTr("BMI")
                    text: (heightInput.heightVal !== 0 ) && (weightInput.weight !== 0) ?
                              patientDetails.bodyMassIndex(userViewModel.useMetric,
                                                           heightInput.heightVal,
                                                           weightInput.weight).toFixed(2) : "-"
                   }
            }

            GenderInput {
                id: genderInput
                Layout.preferredWidth: Theme.marginSize * 30
                gender: patientDetails.gender
            }

            LayoutSpacer {}

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.marginSize * 3
                Layout.alignment: Qt.AlignHCenter
                enabled: lastNameInput.text && firstNameInput.text &&
                              dobInput.text && dobInput.text.match(dateRegExp)
                state: "active"
                text: qsTr("Save")
                onClicked: {
                    if (userViewModel.useMetric) {
                        patientDetails.updatePatientDataMetric(medicalIDInput.text, firstNameInput.text, lastNameInput.text,
                                                               dobInput.text, heightInput.heightVal,
                                                               weightInput.weight, genderInput.selectedGender);
                    } else  {
                        patientDetails.updatePatientDataImperial(medicalIDInput.text, firstNameInput.text, lastNameInput.text,
                                                                 dobInput.text, heightInput.heightVal,
                                                                 weightInput.weight, genderInput.selectedGender);
                    }

                    saveClicked();
                }
            }
        }

        ScanThumbnailView {
            id: scanThumbnailView
            state: "patient"
        }
    }
}
