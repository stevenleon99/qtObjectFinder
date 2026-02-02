import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    ColumnLayout {
        anchors { centerIn: parent }
        spacing: Theme.marginSize

        IconImage {
            Layout.alignment: Qt.AlignHCenter
            source: "qrc:/icons/image-settings.svg"
            sourceSize: Qt.size(Theme.marginSize * 8, Theme.marginSize * 8)
            color: Theme.navyLight
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: Theme.marginSize
            state: "h5"
            font.styleName: Theme.regularFont.styleName
            text: qsTr("Image Setup")
        }

        SetupCheckList { }
    }

}

