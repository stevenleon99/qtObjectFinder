import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.12
import Theme 1.0
import GmQml 1.0
import "../components"

Item {
    readonly property bool selected: state === "dropdown" ? sortedRole === comboBoxRole : (sortRole && (sortedRole === sortRole))
    property string sortText: ""
    property string sortRole: ""
    property string sortedRole: ""
    property string comboBoxRole: ""
    property int sortedOrder: Qt.AscendingOrder

    signal sort(string roleName, int order)

    Layout.preferredWidth: layout.width
    state: "text"
    onSortedRoleChanged: {
        if (state === "dropdown") {
            var item = loader.item;
            for (var i = 0; i < item.roleNames.length; i++) {
                if (item.roleNames[i] === sortedRole)
                    item.currentIndex = i;

            }
        }
    }
    states: [
        State {
            name: "text"

            PropertyChanges {
                target: loader
                sourceComponent: labelComponent
            }

        },
        State {
            name: "icon"

            PropertyChanges {
                target: loader
                sourceComponent: imageComponent
            }

        },
        State {
            name: "dropdown"

            PropertyChanges {
                target: loader
                sourceComponent: comboBoxComponent
            }

        }
    ]

    Component {
        id: imageComponent

        IconImage {
            color: Theme.navyLight
            fillMode: Image.PreserveAspectFit
            sourceSize: Theme.iconSize
            source: "qrc:/icons/images.svg"
        }

    }

    Component {
        id: labelComponent

        Label {
            state: "body1"
            font.styleName: Theme.mediumFont.styleName
            color: selected ? Theme.white : Theme.navyLight
            text: sortText
        }

    }

    Component {
        id: comboBoxComponent

        ComboBox {
            id: comboBox

            property var roleNames: sortRole.split(",")
            property var displayNames: sortText.split(",")

            flat: true
            model: displayNames
            onCurrentIndexChanged: {
                comboBoxRole = roleNames[currentIndex];
                console.log("SortHeader currentIndexChanged", comboBoxRole);
            }

            contentItem: Label {
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                font.styleName: Theme.mediumFont.styleName
                font.capitalization: Font.AllUppercase
                color: selected ? Theme.white : Theme.navyLight
                text: comboBox.displayText
            }

        }

    }

    MouseArea {
        enabled: sortRole
        onClicked: sort(parent.state === "dropdown" ? comboBoxRole : sortRole, sortedOrder === Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder)

        anchors {
            fill: parent
        }

    }

    RowLayout {
        id: layout

        spacing: Theme.margin(1)

        anchors {
            fill: parent
            leftMargin: Theme.margin(2)
        }

        Loader {
            id: loader
        }

        IconImage {
            visible: sortRole
            rotation: sortedOrder === Qt.AscendingOrder ? 180 : 0
            color: selected ? Theme.blue : Theme.navyLight
            fillMode: Image.PreserveAspectFit
            sourceSize: Theme.iconSize
            source: selected ? "qrc:/icons/sort-down.svg" : "qrc:/icons/sort-empty.svg"
        }

        LayoutSpacer {
        }

    }

    Rectangle {
        visible: selected
        width: parent.width
        height: 2
        color: Theme.blue

        anchors {
            bottom: parent.bottom
        }

    }

}
