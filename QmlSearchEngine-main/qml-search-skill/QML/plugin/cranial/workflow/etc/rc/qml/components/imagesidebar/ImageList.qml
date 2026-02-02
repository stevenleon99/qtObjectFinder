import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import AppPage 1.0

import ".."

ColumnLayout {
    spacing: Theme.margin(1)

    readonly property int count: listView.count
    readonly property int delegateWidth: listView.width
    readonly property int scrollBarWidth: scrollBar.width

    property alias model: listView.model
    property alias delegate: listView.delegate

    property bool isStudyMode: false

    Rectangle {
        Layout.preferredHeight: Theme.margin(8)
        Layout.fillWidth: true
        color: Theme.backgroundColor

        SectionHeader {
            anchors { fill: parent; leftMargin: Theme.margin(2) }
            title: qsTr("IMAGES")

            Button {
                state: "icon"
                color: compareModePopup.visible ? Theme.blue : Theme.white
                icon.source: {
                    if  (compareModePopup.compareMode == CompareMode.Single)
                    {
                        return "qrc:/icons/image-single.svg"
                    }
                    else if  (compareModePopup.compareMode == CompareMode.CheckerBoard)
                    {
                        return "qrc:/icons/checkerboard.svg"
                    }
                    else if  (compareModePopup.compareMode == CompareMode.Alpha ||
                              compareModePopup.compareMode == CompareMode.SingleColor ||
                              compareModePopup.compareMode == CompareMode.DualColor)
                    {
                        return "qrc:/icons/blend.svg"
                    }
                }

                onClicked: compareModePopup.setup(this)

                View2DCompareModePopup {
                    id: compareModePopup
                    visible: false
                }
            }

            Button {
                enabled: applicationViewModel.canImportVolume
                icon.source: "qrc:/icons/plus.svg"
                state: "icon"
                color: isStudyMode?Theme.disabledColor:Theme.white

                onClicked: {
                    if (!volumeListViewModel.isStudyMode)
                        importPopupLoader.item.open()
                }
            }
        }
    }

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: Theme.marginSize
        z: -1
        spacing: Theme.marginSize

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            visible: listView.count
            policy: ScrollBar.AlwaysOn
        }

        footer: Item {
            height: Theme.margin(2)
        }
    }
}
