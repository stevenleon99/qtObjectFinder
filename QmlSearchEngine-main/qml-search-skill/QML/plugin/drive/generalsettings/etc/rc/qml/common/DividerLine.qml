import QtQuick 2.12
import QtQuick.Layouts 1.12

import Theme 1.0

Rectangle {
    id: dividerLine
    color: Theme.lineColor

    property int orientation: parent instanceof ColumnLayout ? Qt.Horizontal : Qt.Vertical

    property int lineThickness: 1

    states: [
        State {
            when: orientation === Qt.Horizontal
            PropertyChanges {
                target: dividerLine
                width: dividerLine.parent.width
                height: lineThickness
                Layout.preferredWidth: dividerLine.parent.width
                Layout.preferredHeight: lineThickness
            }
        },
        State {
            when: orientation === Qt.Vertical
            PropertyChanges {
                target: dividerLine
                width: lineThickness
                height: dividerLine.parent.height
                Layout.preferredWidth: lineThickness
                Layout.preferredHeight: dividerLine.parent.height
            }
        }
    ]
}
