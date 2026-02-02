import QtQuick 2.4

Canvas {
    id: canvas
    anchors.fill: parent

    property vector3d inCursorA
    property vector3d inCursorB
    property string refUuid

    onVisibleChanged:  {
        if(visible)
            canvas.requestPaint()
    }

    Connections {
        target: fluoroMgr
        onCursorPosition : {
            inCursorA = ptA
            inCursorB = ptB
            refUuid = uuid
            canvas.requestPaint()
        }
    }

    function drawLine(p1,p2,colorName) {
        context.beginPath();
        context.moveTo(p1.x,p1.y);
        context.strokeStyle = colorName
        context.lineTo(p2.x,p2.y);
        context.stroke();
    }

    function drawCirle(pt,radius,colorName) {
        context.beginPath();
        context.strokeStyle = colorName
        context.arc(pt.x, pt.y, radius, 0, 2*Math.PI, true)
        context.stroke();
    }

    onPaint: {

        var xfm = transformManager.transform("Image",uuid,"CAD",refUuid)

        if(xfm.valid)
        {
            var pntA = xfm.matrix.times(inCursorA)
            var pntB = xfm.matrix.times(inCursorB)

            pntA = imgToScreen(pntA)
            pntB = imgToScreen(pntB)


            var cursorA,cursorB
            var myDir = pntB.minus(pntA)
            if(myDir.length() < 1)
            {
                cursorA = pntA;
                cursorB = pntB;
            }
            else
            {
                var myDir2 = (myDir).normalized();
                cursorA = pntA.plus(myDir2.times(-2*canvas.width));
                cursorB = pntA.plus(myDir2.times(2*canvas.width));
            }


            // Get drawing context
            var context = getContext("2d");
            context.clearRect(0,0,canvas.width,canvas.height)

             // Draw a line
            context.lineWidth = 2;
            drawLine(cursorA,cursorB,"green")

            // Draw a circle
            context.beginPath();
            context.fillStyle = "orange"
            context.arc(cursorA.x, cursorA.y, 5, 0, 2*Math.PI, true)
            context.fill();
            context.stroke();

            // Draw a circle
            context.beginPath();
            context.fillStyle = "blue"
            context.arc(cursorB.x, cursorB.y, 5, 0, 2*Math.PI, true)
            context.fill();
            context.stroke();
        }
    }

    MouseArea {
        id: cursor
        anchors.fill: parent
        propagateComposedEvents: false
        enabled: true
        property bool active: false

        onPressed: {
            active = true
        }
        onReleased: {
            active = false
        }

        onPositionChanged: {
            if(active)
            {
                var pt = screenToImg(mouse)
                fluoroMgr.mousePositionChanged(uuid,pt)
            }
        }
    }
}


