import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0


Rectangle {
    implicitWidth: contentLayout.implicitWidth + contentMargins
    implicitHeight: Theme.margin(6)
    color: Theme.transparent
    border { width: 1; color: Theme.lineColor }
    radius: Theme.margin(0.5)

    property bool patientSelected: patientNameVM.patientSelected
    property int maxComponentWidth: 240
    property int contentMargins: Theme.margin(3)

    PatientNameViewModel {
        id: patientNameVM
    }

    RowLayout {
        id: contentLayout
        height: parent.height
        anchors { centerIn: parent }

        IconImage {
            id: patientIcon
            source: "qrc:/icons/man-circle.svg"
            sourceSize: Theme.iconSize
        }

        Label {
            Layout.maximumWidth: maxTextWidth
            state: "subtitle1"
            font.bold: true
            text: patientNameVM.patientName

            property int maxTextWidth: maxComponentWidth - patientIcon.width - contentMargins - parent.spacing
        }
    }
}
