import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

RowLayout {
    Layout.fillWidth: true
    Layout.fillHeight: false
    Layout.leftMargin: Theme.margin(2)
    Layout.rightMargin: Theme.margin(2)
    Layout.preferredHeight: Theme.margin(8)
    spacing: 0

    property string title

    property string textState: "body1"
    property string textColor: Theme.navyLight

    LayoutSpacer {

        Label {
            anchors { fill: parent }
            state: textState
            minimumPixelSize: 16
            verticalAlignment: Label.AlignVCenter
            fontSizeMode: Text.HorizontalFit
            font.styleName: Theme.boldFont.styleName
            font.bold: true
            color: textColor
            text: title
        }
    }
}
