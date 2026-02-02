import QtQuick 2.4

Canvas {
    id: canvas
    anchors.fill: parent

    property vector2d cpA
    property vector2d cpB
    property bool apImage: uuid == "APImage"

    property vector2d handleA;
    property vector2d handleB;
    property vector2d handleC;
    property vector2d handleD;

    onVisibleChanged: {
        if(visible)
        {
            console.log("Showing Handles")
            canvas.requestPaint()
        }
    }

    Connections {
        target: fluoroMgr
        onPointsChanged: {
            if(enabled)
            {
                canvas.requestPaint()
            }
        }
    }


    function drawSubline(pt,offset,colorName) {
        var p1 = pt.minus(offset);
        var p2 = pt.plus(offset);

        drawLine(p1,p2,colorName)
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
        // Get drawing context
        var context = getContext("2d");
        context.clearRect(0,0,canvas.width,canvas.height)
        context.lineWidth = 2;

        if(apImage)
        {

            var posPnts = fluoroMgr.image("LatImage").imgToFixture(fluoroMgr.bodyPosteriorLatImg);
            var latFix = fluoroMgr.image("LatImage").fixtureUuid();
            var xfm = transformManager.transform("Image",uuid,"CAD",latFix)

            if(!xfm.valid)
                return;

            var pntA = xfm.matrix.times(posPnts[0])
            var pntB = xfm.matrix.times(posPnts[1])
            pntA = imgToScreen(pntA)
            pntB = imgToScreen(pntB)

            var cp = pntA.plus(pntB).times(0.5);
            //cp = imgToScreen(cp)
            drawCirle(cp,5,"red")


            var mainDir = (pntB.minus(pntA)).normalized()

            var pedicaleDist_img = 100;

            var pA = cp.minus(mainDir.times(pedicaleDist_img))
            var pB = cp.plus(mainDir.times(pedicaleDist_img))
            drawCirle(pA,10,"cyan")
            drawCirle(pB,10,"cyan")

            var pC = pA.minus(Qt.vector2d(30/2.0,50/2.0))
            context.beginPath();
            context.rotate(Math.PI/45)
            context.roundedRect(pC.x, pC.y, 30, 50, 10,10);
            context.stroke();
            pC = pB.minus(Qt.vector2d(30/2.0,50/2.0))

            drawCirle(pC,10,"red")
            context.rotate(-Math.PI/45)

            context.beginPath();
            context.roundedRect(pC.x, pC.y, 30, 50, 10,10);
            context.stroke();

            var cursorA,cursorB
            var myDir = pntB.minus(pntA).normalized();

            cursorA = pntA.plus(myDir.times(-2*canvas.width));
            cursorB = pntA.plus(myDir.times(2*canvas.width));
            drawLine(cursorA,cursorB,"lightgreen")


            cpA = imgToScreen(fluoroMgr.pedicleAinside)
            cpB = imgToScreen(fluoroMgr.pedicleBinside)

            var pAi = imgToScreen(fluoroMgr.pedicleAinside);
            var pBi = imgToScreen(fluoroMgr.pedicleBinside);

            var length = (pBi.minus(pAi)).length()
            var mainDir = (pBi.minus(pAi)).normalized()
            var normalDir = Qt.vector2d(mainDir.y,-mainDir.x)
            var normalLine = normalDir.times(30)

            var pAo = pAi.minus( mainDir.times(fluoroMgr.pedicleAwidth * fImage.imageScale));
            var pBo = pBi.plus(  mainDir.times(fluoroMgr.pedicleBwidth * fImage.imageScale));

            pA = (pAi.plus(pAo)).times(0.5);
            pB = (pBi.plus(pBo)).times(0.5);

            context.beginPath();
            context.lineWidth = 2;
            context.moveTo(pA.x, pA.y);
            context.strokeStyle = context.createPattern("cyan",Qt.DashLine)
            context.lineTo(pB.x, pB.y);
            context.stroke();

            // Draw handles
            handleA = pAo.minus(mainDir.times(25));
            drawCirle(handleA,15,"cyan")

            handleB = pBo.plus(mainDir.times(25));
            drawCirle(handleB,15,"cyan")

            // Sublines A
            drawSubline(pAi,normalLine,"cyan")
            drawSubline(pAo,normalLine,"cyan")
            drawSubline(pBi,normalLine,"cyan")
            drawSubline(pBo,normalLine,"cyan")

            handleC = pAo.plus(normalDir.times(55));
            drawCirle(handleC,15,"blue")

            handleD = pBo.plus(normalDir.times(55));
            drawCirle(handleD,15,"blue")
        }
        else {
            cpA = imgToScreen(fluoroMgr.bodyPosteriorLatImg)
            cpB = imgToScreen(fluoroMgr.bodyAnteriorLatImg)
            context.lineWidth = 2;

            var length = (cpB.minus(cpA)).length()
            var mainDir = (cpB.minus(cpA)).normalized()
            var pA,pB;
            var linAng = Math.atan2(mainDir.y,mainDir.x)

            // Draw main line
            drawLine(cpA,cpB,'cyan')

            // Draw Posterior handle
            handleA = cpA.minus(mainDir.times(45));
            drawCirle(handleA,15,'cyan')

            pA = cpA.minus(mainDir.times(length));
            context.beginPath();
            context.strokeStyle = "cyan"
            context.arc(pA.x, pA.y, length, linAng + 2*Math.PI/12, linAng - 2*Math.PI/12, true)
            context.stroke();

            context.beginPath();
            context.strokeStyle = "green"
            context.fillStyle = "lightgreen"
            context.arc(cpA.x, cpA.y, 5, 0, 2*Math.PI, true)
            context.fill();
          //  context.stroke();


            // Draw Anterior handle
            handleB = cpB.plus(mainDir.times(45));
            drawCirle(handleB,15,'cyan')

            pB = cpB.plus(mainDir.times(length));
            linAng = Math.atan2(-mainDir.y,-mainDir.x)
            context.beginPath();
            context.strokeStyle = "cyan"
            context.arc(pB.x, pB.y, length, linAng + 2*Math.PI/12, linAng - 2*Math.PI/12, true)
            context.stroke();
        }

    }

    MouseArea {
        id: reghandles
        anchors.fill: parent
        propagateComposedEvents: true

        enabled: true

        property vector2d handleDelta
        property vector2d lastMousePosition;
        property int handleIdx: -1;
        property bool active: false

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
            else if(lastMousePosition.minus(canvas.handleC).length() < 20)
            {
                handleDelta = (canvas.handleC).minus(lastMousePosition)
                handleIdx = 3;
            }
            else if(lastMousePosition.minus(canvas.handleD).length() < 20)
            {
                handleDelta = (canvas.handleD).minus(lastMousePosition)
                handleIdx = 4;
            }
            else
            {
                active = false
                handleIdx = -1;
            }

            console.log("Handle",handleIdx)

            mouse.accepted = active
        }

        onReleased: {
            active = false
        }

        onPositionChanged: {
            if(active)
            {
                var currentMousePosition = Qt.vector2d(mouse.x,mouse.y)
                if(apImage && handleIdx == 1)
                {
                    var newPos = currentMousePosition.plus(handleDelta)
                    var theDir = newPos.minus(canvas.cpB)
                    var cpLength = (theDir.length() - 25 - fluoroMgr.pedicleAwidth * fImage.imageScale )
                    if(cpLength < 30) cpLength = 30
                    var newCP = theDir.normalized().times(cpLength).plus(canvas.cpB)
                    fluoroMgr.pedicleAinside = screenToImg(newCP)
                }
                else if(apImage && handleIdx == 2)
                {
                    var newPos = currentMousePosition.plus(handleDelta)
                    var theDir = newPos.minus(canvas.cpA)
                    var cpLength = (theDir.length() - 25 - fluoroMgr.pedicleBwidth * fImage.imageScale )
                    if(cpLength < 30) cpLength = 30
                    var newCP = theDir.normalized().times(cpLength).plus(canvas.cpA)
                    fluoroMgr.pedicleBinside = screenToImg(newCP)
                }
                else if(apImage && handleIdx == 3)
                {
                    var newPos = currentMousePosition.minus(lastMousePosition)
                    var theDir = canvas.cpA.minus(canvas.cpB).normalized();

                    var dist = theDir.dotProduct(newPos);
                    console.log(dist)

                    fluoroMgr.pedicleAwidth = Math.max(fluoroMgr.pedicleAwidth + dist,10);
                }
                else if(apImage && handleIdx == 4)
                {
                    var newPos = currentMousePosition.minus(lastMousePosition)
                    var theDir = canvas.cpB.minus(canvas.cpA).normalized();

                    var dist = theDir.dotProduct(newPos);
                    console.log(dist)

                    fluoroMgr.pedicleBwidth = Math.max(fluoroMgr.pedicleBwidth + dist,10);
                }
                else if(!apImage && handleIdx == 1)
                {
                    var newPos = currentMousePosition.plus(handleDelta)
                    var theDir = newPos.minus(canvas.cpB)
                    var cpLength = (theDir.length() - 45)
                    if(cpLength < 30) cpLength = 30
                    var newCP = theDir.normalized().times(cpLength).plus(canvas.cpB)
                    fluoroMgr.bodyPosteriorLatImg =  screenToImg(newCP)
                }
                else if(!apImage && handleIdx == 2)
                {
                    var delta = currentMousePosition.minus(lastMousePosition).times(1/fImage.imageScale)
                    fluoroMgr.bodyPosteriorLatImg = fluoroMgr.bodyPosteriorLatImg.plus(delta);
                    fluoroMgr.bodyAnteriorLatImg = fluoroMgr.bodyAnteriorLatImg.plus(delta);

                    console.log("translate",imgObj.imgToFixture(fluoroMgr.bodyAnteriorLatImg))
                }
                lastMousePosition = currentMousePosition;
            }
        }
    }

}


