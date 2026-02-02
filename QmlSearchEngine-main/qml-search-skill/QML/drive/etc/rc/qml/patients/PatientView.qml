import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import DriveEnums 1.0
import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../components"

ColumnLayout {
    Layout.fillWidth: true
    spacing: 0

    property var patientDetails

    Button {
        objectName: "autoUIOpenPatientBtnObj"
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.marginSize * 3
        Layout.alignment: Qt.AlignHCenter
        state: "active"
        text: qsTr("Open Patient")

        onClicked: drivePageViewModel.currentPage = DrivePage.Cases
    }

    DetailsTabBar {
        id: tabBar
        Layout.preferredHeight: Theme.marginSize * 4
        thumbnailCount: scanListModel.count
    }

    StackLayout {
        Layout.fillWidth: true
        currentIndex: tabBar.currentIndex

        ColumnLayout {
            id: container
            objectName: "patientViewDetails"
            Layout.fillWidth: true
            spacing: Theme.marginSize * .75

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.marginSize * 1.25
            }

            NameValueRow { objectName: "patientNameInfo"; name: qsTr("Name"); value: patientDetails.patientName }
            NameValueRow { objectName: "patientDoBInfo"; name: qsTr("Date of Birth"); value: patientDetails.dateOfBirth }
            NameValueRow { objectName: "patientMedicalIDInfo"; name: qsTr("Medical Id"); value: patientDetails.medicalId }
            NameValueRow { objectName: "patientHeighInfo"; name: qsTr("Height"); value: patientDetails.height +
                                                        (userViewModel.useMetric ? " cm" : " in.") }
            NameValueRow { objectName: "patientWeightInfo"; name: qsTr("Weight"); value: patientDetails.weight +
                                                        (userViewModel.useMetric ? " kg" : " lbs") }
            NameValueRow { objectName: "patientBMIInfo"; name: qsTr("BMI"); value: (patientDetails.height !== 0) &&
                                                     (patientDetails.weight !== 0) ?
                                                         patientDetails.bodyMassIndex().toFixed(2) : "-" }
            NameValueRow { objectName: "patientGenderInfo"; name: qsTr("Gender"); value: patientDetails.gender }
            NameValueRow { objectName: "patientCreatorInfo"; name: qsTr("Creator"); value: patientDetails.creatorName }
            NameValueRow { objectName: "patientOpenedInfo"; name: qsTr("Opened"); value: patientDetails.accessedTime }
            NameValueRow { objectName: "patientCreatedInfo"; name: qsTr("Created"); value: patientDetails.createdTime }
        }

        ScanThumbnailView {
            id: scanThumbnailView
            state: "patient"
        }
    }
}
