import QtQuick 2.4

Canvas {
    id: canvas
    anchors.fill: parent

    property vector2d handleA;
    property vector2d handleB;
    property vector2d handleC;
    property vector2d handleD;

    Connections {
        target: fluoroMgr
        onPointsChanged: {
            if(enabled)
            {
                canvas.requestPaint()
            }
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

    function drawScrew(pTip,pHead) {
        var sDir = pHead.minus(pTip).normalized();
        var nDir = Qt.vector2d(sDir.y,-sDir.x);

        context.beginPath();
        context.lineWidth = 2;
        context.strokeStyle = "yellow"

        var rad = 6;
        var p1 = pTip.plus(sDir.times(2*rad)).plus(nDir.times(rad));
        var p2 = pHead.plus(nDir.times(rad));
        var p3 = pHead.minus(nDir.times(rad));
        var p4 = pTip.plus(sDir.times(2*rad)).minus(nDir.times(rad));

        context.moveTo(pTip.x, pTip.y);
        context.lineTo(p1.x,p1.y);
        context.lineTo(p2.x,p2.y);
        context.lineTo(p3.x,p3.y);
        context.lineTo(p4.x,p4.y);
        context.lineTo(pTip.x, pTip.y);
        context.stroke();

        context.beginPath();
        context.fillStyle = "yellow"
        context.arc(pHead.x, pHead.y, 6, 0, 2*Math.PI, true)
        context.fill();
        context.stroke();
    }

    onPaint: {
        // Get drawing context
        var context = getContext("2d");
        context.clearRect(0,0,canvas.width,canvas.height)

        //Screws
            var wTip = imgObj.fixtureToImg(fluoroMgr.screwAactive ? fluoroMgr.tipA : fluoroMgr.tipB)
            var wHead = imgObj.fixtureToImg(fluoroMgr.screwAactive ? fluoroMgr.headA : fluoroMgr.headB)

            var pTip  = imgToScreen(wTip)
            var pHead = imgToScreen(wHead)

            drawScrew(pTip,pHead)

            var sDir = pHead.minus(pTip).normalized();
            handleA = pTip.minus(sDir.times(25))
            handleB = pHead.plus(sDir.times(25))

            context.beginPath();
            context.lineWidth = 2;
            context.strokeStyle = "cyan"
            context.arc(handleA.x , handleA.y, 15, 0, 2*Math.PI, true)
            context.stroke();

            context.beginPath();
            context.lineWidth = 2;
            context.strokeStyle = "cyan"
            context.arc(handleB.x , handleB.y, 15, 0, 2*Math.PI, true)
            context.stroke();
    }

    MouseArea {
        id: screwMouseArea
        anchors.fill: parent
        propagateComposedEvents: false
        property vector2d handleDelta
        property vector2d lastMousePosition;
        property int handleIdx: -1;
        property bool active: false

        enabled: true

        onPressed: {
            active = true
            lastMousePosition = Qt.vector2d(mouse.x,mouse.y);
            if(lastMousePosition.minus(canvas.handleA).length() < 20)
            {
                handleDelta = (canvas.handleA).minus(lastMousePosition)
                handleIdx = 1;
            }
            else if(lastMousePosition.minus(canvas.handleB).length() < 20)
            {
                handleDelta = (canvas.handleB).minus(lastMousePosition)
                handleIdx = 2;
            }
            else
            {
                active = false
                handleIdx = -1;
            }
            mouse.accepted = active
        }

        onReleased: {
            active = false
        }

        function pointOnLine(p0,p1,p) {
            var v = p1.minus(p0);
            var w = p.minus(p0);

            var c1 = w.dotProduct(v);
            var c2 = v.dotProduct(v);
            var b = c1 / c2;

            return p0.plus(v.times(b));
        }
        onPositionChanged: {
            var currentMousePosition = Qt.vector2d(mouse.x,mouse.y)
            if(handleIdx != -1)
            {
                if(handleIdx == 1) {
                    var wHead = imgObj.fixtureToImg(fluoroMgr.screwAactive ? fluoroMgr.headA : fluoroMgr.headB)
                    var pHead = imgToScreen(wHead)
                    var newPos = currentMousePosition.plus(handleDelta)

                    var sDir = pHead.minus(newPos).normalized();
                    var sLgth = pHead.minus(newPos).length() - 25;
                    sLgth = Math.max(sLgth,0.1);
                    var newTip = pHead.minus(sDir.times(sLgth));
                    newTip =  screenToImg(newTip)
                    var pnts = imgObj.imgToFixture(newTip);

                    if(fluoroMgr.screwAactive) {
                        fluoroMgr.tipA = pointOnLine(pnts[0],pnts[1],fluoroMgr.tipA)
                    }
                    else {
                        fluoroMgr.tipB = pointOnLine(pnts[0],pnts[1],fluoroMgr.tipB)
                    }
                }
                else if(handleIdx == 2)
                {
                    var wTip = imgObj.fixtureToImg(uuid,fluoroMgr.screwAactive ? fluoroMgr.tipA : fluoroMgr.tipB)
                    var pTip = imgToScreen(wTip)
                    var newPos = currentMousePosition.plus(handleDelta)

                    var sDir = pTip.minus(newPos).normalized();
                    var sLgth = pTip.minus(newPos).length() - 25;
                    sLgth = Math.max(sLgth,0.1);
                    var newTip = pTip.minus(sDir.times(sLgth));
                    newTip = screenToImg(newTip)
                    var pnts = imgObj.imgToFixture(newTip);

                    if(fluoroMgr.screwAactive) {
                        fluoroMgr.headA = pointOnLine(pnts[0],pnts[1],fluoroMgr.headA)
                    }
                    else {
                        fluoroMgr.headB = pointOnLine(pnts[0],pnts[1],fluoroMgr.headB)
                    }
                }
            }
            else
            {
                var pt = screenToImg(mouse)
                fluoroMgr.mousePositionChanged(uuid,pt)
            }
            lastMousePosition = currentMousePosition;
        }
    }

}

