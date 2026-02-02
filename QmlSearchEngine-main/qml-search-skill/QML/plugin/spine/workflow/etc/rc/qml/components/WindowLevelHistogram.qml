import QtQuick 2.12
import QtCharts 2.15

import Theme 1.0


Rectangle {
    id: windowLevelHistogram
    width: 300
    height: 80

    anchors {
        left: parent.horizontalCenter;
        right: parent.right;
        bottom: parent.bottom;
        leftMargin: Theme.margin(2);
        rightMargin: Theme.margin(2);
        bottomMargin: Theme.margin(0.5);
    }

    radius: Theme.margin(1)
    color: Theme.transparent

    property double histXMin
    property double histXMax
    property double histYMin
    property double histYMax
    // A list of (x, y) points
    property var histogramPoints
    property var histogramWindowPoints

    ChartView {
        anchors.fill: parent
        antialiasing: true
        backgroundColor: Theme.transparent
        legend.visible: false
        plotArea: Qt.rect(0, 0, windowLevelHistogram.width, windowLevelHistogram.height)

        AreaSeries {
            color: "#330099FF"
            axisX: hist.axisX
            axisY: hist.axisY
            borderColor: Theme.transparent
            upperSeries: LineSeries {
                id: hist
                name: "SplineSeries"
                color: Theme.blue
                width: 2
                axisX: ValueAxis {
                    labelsVisible: false
                    gridVisible: false
                    lineVisible: false
                    min: histXMin
                    max: histXMax
                }
                axisY: LogValueAxis {
                    labelsVisible: false
                    gridVisible: false
                    lineVisible: false
                    min: histYMin
                    max: histYMax
                }
                function drawHistogram() {
                    hist.clear()
                    for (var i = 1; i < histogramPoints.length; i++) {
                        hist.append(histogramPoints[i].x,
                                    2 + histogramPoints[i].y);
                    }
                }

                Component.onCompleted: {
                    drawHistogram()
                }

                Connections {
                    target: windowLevelHistogram
                    function onHistogramPointsChanged() {
                        hist.drawHistogram()
                    }
                }
            }
        }
        AreaSeries {
            id: wind
            name: "WindowSeries"
            color: "#CC0099FF"
            axisX: hist.axisX
            axisY: hist.axisY
            borderColor: Theme.transparent
            upperSeries: LineSeries {
                function drawWind() {
                    wind.upperSeries.clear()
                    for (var i = 1; i < histogramWindowPoints.length; i++) {
                        wind.upperSeries.append(histogramWindowPoints[i].x,
                                                2 + histogramWindowPoints[i].y);
                    }
                }

                Component.onCompleted: {
                    drawWind()
                }

                Connections {
                    target: windowLevelHistogram
                    function onHistogramWindowPointsChanged() {
                        wind.upperSeries.drawWind()
                    }
                }
            }
        }
    }
}
