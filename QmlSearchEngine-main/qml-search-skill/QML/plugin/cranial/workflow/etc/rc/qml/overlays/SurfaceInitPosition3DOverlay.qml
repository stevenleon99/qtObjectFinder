import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.12
import ViewModels 1.0

import GmQml 1.0
import Theme 1.0

Item {
    visible: surfaceInitOverlayViewModel.isVisible 

    property var renderer

    SurfaceInitOverlay3DViewModel {
        id: surfaceInitOverlayViewModel
        viewport: renderer
    }

                                MouseArea {
                                anchors.fill: parent

                                onClicked: {
console.log("AREA CLICKED")
surfaceInitOverlayViewModel.setPointIndex(false)
mouse.accepted=false
                                }

                            }



Rectangle{
                        anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 30 
width: 120
height: 50

                        color: Theme.slate700 
                        border.color: surfaceInitOverlayViewModel.isSelected?Theme.blue:Theme.slate700 
                        border.width:  2 
                        radius: 4

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: Theme.margin(1)
                            anchors.fill: parent

                            IconImage {
                                id: crosshairIcon1
                                Layout.leftMargin: Theme.margin(1)
                                Layout.rightMargin: 0
                                source: "qrc:/icons/crosshair.svg"
                                sourceSize: Theme.iconSize
                                color: {
                                    if (surfaceInitOverlayViewModel.pointIndex == 1) {
										Theme.magenta
									} else if (surfaceInitOverlayViewModel.pointIndex == 2) {
										Theme.lime
									} else if (surfaceInitOverlayViewModel.pointIndex == 3) {
										Theme.yellow
									}
                                }
                            }

                            Label {
                                Layout.leftMargin: 0
                                Layout.rightMargin: 37
                                state: "subtitle1"
                                text: "Ref. "+ surfaceInitOverlayViewModel.pointIndex
                                color: Theme.white
                                font.bold: true
                            }


                        }
                    

                                MouseArea {
                                anchors.fill: parent
                                preventStealing: true
                                propagateComposedEvents :false

                                onClicked: {
console.log("RECTANGLE CLICKED")
surfaceInitOverlayViewModel.setPointIndex(true)
mouse.accepted=true
                                }

                            }
}

    
}


