import QtQuick 2.4

Item
{
    property string uuid: "ImageKeys"
    property real xPad:  (fImage.width-fImage.paintedWidth)/2
    property real yPad:  (fImage.height-fImage.paintedHeight)/2
    property var imgObj

    onUuidChanged: {
        imgObj = fluoroMgr.image(uuid)
    }


    function imgToScreen(pt) {
        var ptA = Qt.vector2d(pt.x,pt.y)
        return ptA.times(fImage.imageScale).plus(Qt.vector2d(xPad,yPad));
    }

    function screenToImg(pt) {
        return Qt.vector2d(
                    ( (pt.x-xPad) / fImage.imageScale) ,
                    ( (pt.y-yPad) / fImage.imageScale) )
    }

    Image {
        id:fImage
        anchors { fill: parent; margins: 6 }


        property double imageScale: paintedHeight / sourceSize.height;

        source: "image://FluoroImage/" + uuid
        fillMode: Image.PreserveAspectFit

        onImageScaleChanged: {
            fluoroMgr.computeRegistration()
         }

        FluoroImageCursorOverlay {
            id: cursorCanvas
            visible: cursorCB.checked
            enabled: visible
        }

        FluoroImageRegistrationHandleOverlay {
            id: handlecanvas
            visible: enabled
            enabled: regMode
        }

        FluoroImageScrewOverlay {
            id: screwCanvas
            visible: enabled
            enabled: planningMode
        }

        FluoroImageRingOverlay {
            id: ringCanvas
            visible: enabled
            enabled: ringMode
        }

        FluoroImageNavigationOverlay {
            id: navCanvas
            visible: navMode
            enabled: visible
        }
    }

    BorderImage {
        id: view_border
        anchors { fill: parent }
        border { left: 34; right: 34; top: 34; bottom: 34 }
        source: "view_border.png"
    }

}

