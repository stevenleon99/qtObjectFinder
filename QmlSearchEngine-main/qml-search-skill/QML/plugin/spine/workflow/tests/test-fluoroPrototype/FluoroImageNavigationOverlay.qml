import QtQuick 2.4

Canvas {
    id: canvas
    anchors.fill: parent

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

    Connections {
        target: tracking
        onNewFrame: {
            if(navMode)
                canvas.requestPaint()
        }
    }

    onVisibleChanged: {
        if(uuid == "APImage")
        {
            console.log("Transfrom - Start",visible,visibility)
            transformManager.print()
            console.log("Transfrom - End")
        }
    }

    onPaint: {
        // Get drawing context
        var context = getContext("2d");
        context.clearRect(0,0,canvas.width,canvas.height)

        var xfm = transformManager.transform("Image",uuid,"ROM","56649ef7-8d0f-4d59-a897-0aae8ad81856")

        var probeTip = Qt.vector3d(-17,0,-160)

        if(xfm.valid)
        {
            var pntImg = xfm.matrix.times(probeTip)
            var spnt = imgToScreen(pntImg)

            drawCirle(spnt,10,'red');
         }
    }
}

