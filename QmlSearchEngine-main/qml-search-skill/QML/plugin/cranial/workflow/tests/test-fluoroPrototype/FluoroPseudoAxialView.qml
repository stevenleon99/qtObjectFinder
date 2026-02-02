import QtQuick 2.4

//FluoroPseudoAxialView.qml


Rectangle {
    color: "#000000"
    clip: true

    property real heightScale: height / middle.sourceSize.height

    property var regData

    Connections {
        target: fluoroMgr
        onRegistrationChanged: {
            regData = regList
            updateAxialView();
        }
    }

    function projectPoint(pt){
        // project head on plane
        var v = pt.minus(regData[4]);
        var n = ((regData[0].minus(regData[4])).crossProduct(regData[2].minus(regData[4]))).normalized()
        var dist = v.dotProduct(n);
        var pHead = pt.minus(n.times(dist))

        // project head on x dir
        var pHaM = pHead.minus(regData[4])
        var xDir = regData[6].minus(regData[4]).normalized();
        var xOff = xDir.dotProduct(pHaM);
        var yDir = regData[0].minus(regData[4]).normalized();
        var yOff = yDir.dotProduct(pHaM);

        return Qt.vector2d(xOff,yOff)
    }

    function screen2fixture(pt,oldPnt){
        var hI = 377
        var h = (regData[0].minus(regData[4])).length()/hI;

        var ptA = pt.times(h / heightScale)
        var xDir = regData[6].minus(regData[4]).normalized();
        var yDir = regData[0].minus(regData[4]).normalized();

        ptA = regData[4].plus(xDir.times(ptA.x)).plus(yDir.times(ptA.y))

        var n = ((regData[0].minus(regData[4])).crossProduct(regData[2].minus(regData[4]))).normalized()

        var w = oldPnt - ptA;

        var c1 = n.dotProduct(w)
        var c2 = n.dotProduct(n)
        var b = c1 / c2;

        var newP = ptA.plus(n.times(b))

        return newP;
    }

    function updateAxialView() {
        var hI = 377
        var mI = 273
        var lI = 100
        var rI = 100

        var h = (regData[0].minus(regData[4])).length()/hI;
        var m = (regData[3].minus(regData[5])).length()/mI;
        var l = (regData[2].minus(regData[3])).length()/lI;
        var r = (regData[5].minus(regData[6])).length()/rI;
        middle.imgScale = m/h
        left.imgScale = l/h
        right.imgScale = r/h

        var imgOrg = Qt.vector2d(0/hI,51.5 * heightScale )

        var pHead = projectPoint(fluoroMgr.headA)
        canvas.headA = pHead.times(heightScale/h)

        var pTip = projectPoint(fluoroMgr.tipA)
        canvas.tipA = pTip.times(heightScale/h)

        var pHeadB = projectPoint(fluoroMgr.headB)
        canvas.headB = pHeadB.times(heightScale/h)

        var pTipB = projectPoint(fluoroMgr.tipB)
        canvas.tipB = pTipB.times(heightScale/h)
        canvas.origin = imgOrg.times(1)

        canvas.requestPaint()

    }

    Image {
        id: middle
        property real imgScale: 1
        anchors { centerIn: parent  }
        width: imgScale * height / sourceSize.height * sourceSize.width
        height: parent.height
        source: "L3_4_M.png"
    }

    Image {
        id: left
        anchors {
            right: middle.left
            top: middle.top
            bottom: middle.bottom
        }
        property real imgScale: 1
        width: imgScale * height / sourceSize.height * sourceSize.width
        source: "L3_4_L.png"
    }

    Image {
        id: right
        anchors {
            left: middle.right
            top: middle.top
            bottom: middle.bottom
        }
        property real imgScale: 1
        width: imgScale * height / sourceSize.height * sourceSize.width
        source: "L3_4_R.png"
    }

    MouseArea {
        anchors.fill: parent

        enabled: true


        property int activePoint: -1

        function sqr(x) { return x * x }
        function dist2(v, w) { return sqr(v.x - w.x) + sqr(v.y - w.y) }
        function distToSegmentSquared(p, v, w) {
            var l2 = dist2(v, w);
            if (l2 === 0) return dist2(p, v);
            var t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
            if (t < 0) return dist2(p, v);
            if (t > 1) return dist2(p, w);
            return dist2(p, { x: v.x + t * (w.x - v.x),
                             y: v.y + t * (w.y - v.y) });
        }
        function distToSegment(p, v, w) { return Math.sqrt(distToSegmentSquared(p, v, w)); }

        property vector2d pickOffset

        onPressed: {
            var pos = Qt.vector2d(mouse.x - canvas.width/2, mouse.y - canvas.height/2 - canvas.origin.y)

            if(fluoroMgr.screwAactive)
            {
                activePoint = -1;
                if(pos.minus(canvas.headA).length() < 20)
                {
                    activePoint = 1
                    pickOffset = pos.minus(canvas.headA)
                }
                else if(pos.minus(canvas.tipA).length() < 20)
                {
                    activePoint = 2
                    pickOffset = pos.minus(canvas.tipA)
                }
                else if(distToSegment(pos,canvas.tipB,canvas.headB) < 20)
                {
                    fluoroMgr.screwAactive = false
                }
            }
            else
            {
                activePoint = -1;
                if(pos.minus(canvas.headB).length() < 20)
                {
                    activePoint = 1
                    pickOffset = pos.minus(canvas.headB)
                }
                else if(pos.minus(canvas.tipB).length() < 20)
                {
                    activePoint = 2
                    pickOffset = pos.minus(canvas.tipB)
                }
                else if(distToSegment(pos,canvas.tipA,canvas.headA) < 20)
                {
                    fluoroMgr.screwAactive = true
                }
            }

        }
        onPositionChanged: {
            var pos = Qt.vector2d(mouse.x - canvas.width/2, mouse.y - canvas.height/2 - canvas.origin.y)

            var newPos = pos.minus(pickOffset)
            if(fluoroMgr.screwAactive && activePoint == 1) {
                fluoroMgr.headA = screen2fixture(newPos,fluoroMgr.headA)
            } else if(fluoroMgr.screwAactive && activePoint == 2) {
                fluoroMgr.tipA = screen2fixture(newPos,fluoroMgr.tipA)
            } else if(activePoint == 1) {
                fluoroMgr.headB = screen2fixture(newPos,fluoroMgr.headB)
            } else if(activePoint == 2) {
                fluoroMgr.tipB = screen2fixture(newPos,fluoroMgr.tipB)
            }

            canvas.requestPaint()
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        visible: planningMode

        property vector2d tipA
        property vector2d headA
        property vector2d tipB
        property vector2d headB
        property vector2d origin

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
            context.setTransform(1,0,0,1,0,0)
            context.clearRect(0,0,canvas.width,canvas.height)

            context.setTransform(1,0,0,1,canvas.width/2,canvas.height/2+origin.y)

            drawScrew(tipA,headA)
            drawScrew(tipB,headB)

            var pt = fluoroMgr.screwAactive ? tipA : tipB
            context.beginPath();
            context.lineWidth = 2;
            context.strokeStyle = "cyan"
            context.arc(pt.x , pt.y, 15, 0, 2*Math.PI, true)
            context.stroke();

            pt = fluoroMgr.screwAactive ? headA : headB
            context.beginPath();
            context.lineWidth = 2;
            context.strokeStyle = "cyan"
            context.arc(pt.x , pt.y, 15, 0, 2*Math.PI, true)
            context.stroke();
        }
    }
}

