import QtQuick 2.4
import QtQuick.Controls 1.2

Canvas {
    id: canvas
    anchors.fill: parent

    property int ringIdx: ringBut.text == "Far"

    property vector2d l1a;
    property vector2d l1b;
    property vector2d l2a;
    property vector2d l2b;
    property vector2d cpa;

    onVisibleChanged: {
        if(visible) {
            requestPaint()
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

    function drawX(pt,radius,colorName) {
        var p1 = pt.minus(Qt.vector2d(radius,radius))
        drawLine(pt.plus(Qt.vector2d(-radius,-radius)),pt.plus(Qt.vector2d(radius,radius)),colorName)
        drawLine(pt.plus(Qt.vector2d(-radius, radius)),pt.plus(Qt.vector2d(radius,-radius)),colorName)
    }


    onPaint: {
        // Get drawing context
        var context = getContext("2d");
        context.resetTransform();
        context.clearRect(0,0,canvas.width,canvas.height)
        context.lineWidth = 2;

        l1a = imgToScreen(imgObj.ringControlPnt(ringIdx,0))
        l1b = imgToScreen(imgObj.ringControlPnt(ringIdx,1))
        l2a = imgToScreen(imgObj.ringControlPnt(ringIdx,2))
        l2b = imgToScreen(imgObj.ringControlPnt(ringIdx,3))
        cpa = imgToScreen(imgObj.ringControlPnt(ringIdx,4))

        //Draw Line

        drawLine(l1a,l1b,"cyan")
        drawLine(l2a,l2b,"cyan")

        drawCirle(l1a,20,"cyan")
        drawCirle(l1b,20,"cyan")
        drawCirle(l2a,20,"cyan")
        drawCirle(l2b,20,"cyan")
        drawCirle(cpa,20,"cyan")


        var eData = imgObj.ringEllipse(ringIdx);
        if(eData)
        {
            var eCenter = imgToScreen(eData[0])
            var w = eData[1] * fImage.imageScale;
            var h = eData[2] * fImage.imageScale;
            var a = eData[3];

            context.save();
            context.beginPath();
            context.translate(eCenter.x,eCenter.y)
            context.rotate(a)
            context.ellipse(- w/2.0, - h/2.0,w,h);
            context.stroke();
            context.restore();
        }

        context.lineWidth = 1;
        var fPnt = imgObj.fidLandmarks_fig();
        for(var i=0;i<fPnt.length;i++)
        {
            var pLimg = imgObj.fixtureToImg(fPnt[i])
            var pLscn = imgToScreen(pLimg)
            drawX(pLscn,5,'orange')
        }

        var xfm = transformManager.transform("Image",uuid,"ROM",imgObj.landmarksRomUuid())
        var lPnt = imgObj.genericLandmarks();
        for(var j=0;j<lPnt.length;j++)
        {
            var pntImg = xfm.matrix.times(lPnt[j])
             var pntScrn = imgToScreen(pntImg)
            drawX(pntScrn,5,'red')


            context.beginPath();
            context.text(j.toString(),pntScrn.x,pntScrn.y+15)
            context.stroke();

        }
    }

    MouseArea {
        id: reghandles
        anchors.fill: parent
        propagateComposedEvents: true

        enabled: true

        property bool active: false

        property vector2d handleDelta
        property vector2d lastMousePosition;
        property int handleIdx: -1;

        onPressed: {
            lastMousePosition = Qt.vector2d(mouse.x,mouse.y);
            active = true
            if(lastMousePosition.minus(canvas.l1a).length() < 20)
            {
                handleDelta = (canvas.l1a).minus(lastMousePosition)
                handleIdx = 0;
            }
            else if(lastMousePosition.minus(canvas.l1b).length() < 20)
            {
                handleDelta = (canvas.l1b).minus(lastMousePosition)
                handleIdx = 1;
            }
            else if(lastMousePosition.minus(canvas.l2a).length() < 20)
            {
                handleDelta = (canvas.l2a).minus(lastMousePosition)
                handleIdx = 2;
            }
            else if(lastMousePosition.minus(canvas.l2b).length() < 20)
            {
                handleDelta = (canvas.l2b).minus(lastMousePosition)
                handleIdx = 3;
            }
            else if(lastMousePosition.minus(canvas.cpa).length() < 20)
            {
                handleDelta = (canvas.cpa).minus(lastMousePosition)
                handleIdx = 4;
            }
            else
            {
                active = false
                handleIdx = -1;
            }

            console.log("Ring Overlay Pressed",active)
            mouse.accepted = active

        }
        onReleased: {
            active = false
        }
        onPositionChanged: {
            if(active)
            {
                console.log("Ring Overlay Moved",reghandles.pressed)

                var currentMousePosition = Qt.vector2d(mouse.x,mouse.y)

                var newPos = currentMousePosition.plus(handleDelta)
                newPos = screenToImg(newPos)

                if(handleIdx != -1)
                {
                    imgObj.setRingControlPnt(ringIdx,handleIdx,newPos)

                    canvas.requestPaint();
                }
                lastMousePosition = currentMousePosition;
            }
            mouse.accepted = active
        }
    }

    Button {
        id: ringBut
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 25
        text: "Near"
        onClicked: {
            if(text == "Near") {
                text = "Far"
            } else if(text == "Far") {
                text = "Near"
            }
            canvas.requestPaint();
        }
    }

    Button {
        id: tracking
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 25
        text: "Collect Xfm"
        onClicked: {
            imgObj.captureFixtureXdrb();
        }
    }

    Button {
        id: register
        anchors.bottom: parent.bottom
        anchors.left: tracking.right
        anchors.margins: 25
        text: "Register Rings"
        onClicked: {
            imgObj.calculateRingRegistration();
            canvas.requestPaint()
        }
    }
}




