import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import ViewModels 1.0
import QtGraphicalEffects 1.0

import Theme 1.0

Item {
    id: rootId
    anchors.left: parent.left
    anchors.top: parent.top

    property double viewScale: renderer ? renderer.viewMmPerPixel : 0

    property bool arrowUpVisible: true
    property bool arrowDownVisible: true
    property bool arrowLeftVisible: true
    property bool arrowRightVisible: true
    property bool arrowsVisible: true

    property real positionOverlayX
    onPositionOverlayXChanged: pickerCenterId.x = positionOverlayX - pickerCenterId.width/2;

    property real positionOverlayY
    onPositionOverlayYChanged: pickerCenterId.y = positionOverlayY - pickerCenterId.height/2;

    property real limitSize: (leftArrow.width + rightArrow.width + pickerCenterId.width) / 2

    signal upArrowClicked();
    signal downArrowClicked();
    signal leftArrowClicked();
    signal rightArrowClicked();
    signal pressedAndHolding(var x,var y);
    signal releasing();
    signal positionChanging(var x,var y);

    Button {
        id: upArrow
        visible: arrowsVisible && arrowUpVisible
        anchors {horizontalCenter: pickerCenterId.horizontalCenter; bottom: pickerCenterId.top}
        icon.source: "qrc:/icons/arrow.svg"
        icon.width: 64
        icon.height: 64
        state: "icon"
        color: Theme.blue
        rotation: 90

        onClicked: upArrowClicked()
    }

    Button {
        id: leftArrow
        visible: arrowsVisible && arrowLeftVisible
        anchors {verticalCenter: pickerCenterId.verticalCenter; right: pickerCenterId.left}
        icon.source: "qrc:/icons/arrow.svg"
        icon.width: 64
        icon.height: 64
        state: "icon"
        color: Theme.blue
        //rotation: 180

        onClicked: leftArrowClicked()
    }

    Button {
        id: downArrow
        visible: arrowsVisible && arrowDownVisible
        anchors {horizontalCenter: pickerCenterId.horizontalCenter; top: pickerCenterId.bottom}
        icon.source: "qrc:/icons/arrow.svg"
        icon.width: 64
        icon.height: 64
        state: "icon"
        color: Theme.blue
        rotation: -90

        onClicked: downArrowClicked()
    }

    Button {
        id: rightArrow
        visible: arrowsVisible && arrowRightVisible
        anchors {verticalCenter: pickerCenterId.verticalCenter; left: pickerCenterId.right}
        icon.source: "qrc:/icons/arrow.svg"
        icon.width: 64
        icon.height: 64
        state: "icon"
        color: Theme.blue
        rotation: 180

        onClicked: rightArrowClicked()
    }

    Rectangle {
        id: pickerCenterId
        opacity: 0.5
        width: (10.35 / viewScale) + (2 * border.width)
        height: width
        radius: width / 2
        border { width: 64; color: Theme.blue }
        color: Theme.transparent

        MouseArea {
            anchors.fill: parent

            pressAndHoldInterval: 1

            onReleased:
            {
                releasing();
                arrowsVisible=true;
            }

            onPressAndHold: {
                var auxPos = pickerCenterId.mapToItem(rootId.parent,mouse.x,mouse.y);
                pressedAndHolding(auxPos.x,auxPos.y);
                arrowsVisible=false;
            }

            onPositionChanged: {
                var auxPos = pickerCenterId.mapToItem(rootId.parent,mouse.x,mouse.y);
                positionChanging(auxPos.x,auxPos.y);
            }
        }
    }
}
