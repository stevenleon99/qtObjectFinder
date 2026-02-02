import QtQuick 2.12
import QtQuick.Window 2.12

import QtQuick 2.6
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

import QtQuick.Dialogs 1.3

//import Volume 1.0 as Volume

ApplicationWindow {
    id: appWindow

    visible: true
    color: "#FFE5CC"
    visibility: Window.Windowed
    width: 1500
    height: 1080
    flags: Qt.Window //| Qt.FramelessWindowHint
    title: "Cranial Debug Window"

    overlay.modal: Rectangle { color: Qt.rgba(0, 0, 0, 0.5) }

    onClosing: gmDebug.closed()

    Row {
        width: parent.width
        height: parent.height

        //CASE DATA
        Column {
            id: caseDataId
            height: parent.height
            width: parent.width/3
            //anchors {left: parent.left}
            spacing: 5
            topPadding: 5

            Rectangle {
                id: refreshCaseId
                width: parent.width-10
                height: 50
                color: "red"
                anchors.left: parent.left
                anchors.leftMargin: 5

                Text {
                    id: name
                    text: qsTr("CASE DATA")
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        gmDebug.updateCaseData()
                    }
                }
            }

            CheckBox {
                id: automaticCaseId
                height: 30
                anchors.horizontalCenter: refreshCaseId.horizontalCenter
                text: "Automatic"
                checked: gmDebug.autoCaseData

                onCheckedChanged: {
                    gmDebug.autoCaseData = !gmDebug.autoCaseData;
                }
            }

            ScrollView {
                height: parent.height-100
                width: parent.width
                clip: true

                TextEdit {
                    text: gmDebug.caseData
                    textFormat: TextEdit.RichText
                    selectByMouse: true
                }
            }
        }

        Rectangle {
            id: firstLineId
            width: 5
            border.color: 'grey'
            border.width: 2
            color: 'red'
            height: parent.height
            //anchors {left: caseDataId.right}
        }

        //APPLICATION DATA
        Column {
            id: appDataId
            height: parent.height
            width: parent.width/3
            //anchors {left: firstLineId.right}
            spacing: 5
            topPadding: 5

            Rectangle {
                id: refresh2Id
                width: parent.width-10
                height: 50
                color: "orange"
                anchors.right: parent.right
                anchors.rightMargin: 5

                Text {
                    id: name2
                    text: qsTr("APPLICATION DATA")
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        gmDebug.updateAppData()
                    }
                }
            }


            CheckBox {
                id: automaticId2
                height: 30
                anchors.horizontalCenter: refresh2Id.horizontalCenter
                text: "Automatic"
                checked: gmDebug.autoAppData

                onCheckedChanged: {
                    gmDebug.autoAppData = !gmDebug.autoAppData;
                }
            }

            ScrollView {
                height: parent.height-100
                width: parent.width
                clip: true

                TextEdit {
                    text: gmDebug.appData
                    textFormat: TextEdit.RichText
                    selectByMouse: true
                }
            }

        }

        Rectangle {
            id: secondLineId
            height: parent.height
            width: 5
            border.color: 'grey'
            border.width: 2
            color: 'red'
            //anchors.left: appDataId.right
        }

        Column {
            height: parent.height
            width: parent.width - 10 - appDataId.width - caseDataId.width
           // anchors.left: secondLineId.right
            //anchors.right: parent.right
            spacing: 5
            topPadding: 10


            Button {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                state: "active"
                text: "Restore latest case && app snapshot"

                onClicked: gmDebug.restoreLatestSnapshot(true)
            }
            Button {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                state: "active"
                text: "Restore only latest case snapshot"

                onClicked: gmDebug.restoreLatestSnapshot(false)
            }

            Rectangle {
                height: 1
                color: 'black'
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            TextField {
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("Words to search")
                color: 'black'
                selectByMouse: true

                onEditingFinished: gmDebug.setSearchWords(text)
            }

            Rectangle {
                       height: 1
                       color: 'black'
                       anchors {
                           left: parent.left
                           right: parent.right

                       }
                   }

            Row {
                spacing: 2

                Text {
                    text: "World/Patient Pos:"
                }

                Connections {
                    target: gmDebug

                    onPositionChanged: {
                        textFieldX.text = Math.round(gmDebug.position.x * 100) / 100
                        textFieldY.text = Math.round(gmDebug.position.y * 100) / 100
                        textFieldZ.text = Math.round(gmDebug.position.z * 100) / 100
                    }

                }

                TextField {
                    id: textFieldX
                    width: 80
                    height: 40
                    color: 'black'
                    selectByMouse: true
                }

                TextField {
                    id: textFieldY
                    width: 80
                    height: 40
                    color: 'black'
                    selectByMouse: true
                }

                TextField {
                    id: textFieldZ
                    width: 80
                    height: 40
                    color: 'black'
                    selectByMouse: true
                }

                Rectangle {
                    width: 40
                    height: 40

                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("GO")
                    }
                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            gmDebug.setRenderPosition(Qt.vector3d(textFieldX.text,textFieldY.text,textFieldZ.text))
                        }
                    }
                }
            }

            Rectangle {
                       height: 1
                       color: 'black'
                       anchors {
                           left: parent.left
                           right: parent.right

                       }
                   }

            CheckBox {
                anchors.horizontalCenter: parent.horizontalCenter
                checked: gmDebug.isE3Dvisible
                text: qsTr("E3D Visible?")

                onCheckStateChanged: gmDebug.setIsE3Dvisible(!gmDebug.isE3Dvisible)
            }

            CheckBox {
                anchors.horizontalCenter: parent.horizontalCenter
                checked: gmDebug.isDRBvisible
                text: qsTr("DRB Visible?")

                onCheckStateChanged: gmDebug.setIsDRBvisible(!gmDebug.isDRBvisible)
            }

            Rectangle {
                       height: 1
                       color: 'black'
                       anchors {
                           left: parent.left
                           right: parent.right

                       }
                   }

            Rectangle {
                id: runCustomId
                height: 31
                color: "#00ABA9"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    id: runCustomTxt
                    text: qsTr("Run Custom Function")
                    anchors.fill: parent
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    id: runCustomButton
                    anchors.fill: parent

                    onClicked: gmDebug.runCustomFunction()
                }
            }

            Rectangle {
                       height: 1
                       color: 'black'
                       anchors {
                           left: parent.left
                           right: parent.right

                       }
                   }

            CheckBox {
                anchors.horizontalCenter: parent.horizontalCenter
                checked: gmDebug.isShotsSaved
                text: gmDebug.isShotsSaved?qsTr("Stop Saving shots to local"):qsTr("Save shots to local")

                onToggled: gmDebug.setIsShotsSaved(!gmDebug.isShotsSaved)
            }

            Row
            {
                width: parent.width
                height: 31
                spacing:10
                leftPadding: 5
                rightPadding: 5

                Rectangle {
                    width: parent.width/2-6
                    height: 31
                    color: "#0000FF"

                    Text {
                        text: qsTr("Load AP shot")
                        anchors.fill: parent
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: gmDebug.loadApShot()
                    }
                }

                Rectangle {
                    width: parent.width/2-6
                    height: 31
                    color: "#0000FF"

                    Text {
                        text: qsTr("Load LAT shot")
                        anchors.fill: parent
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: gmDebug.loadLatShot()
                    }
                }
            }

            Rectangle {
                       height: 1
                       color: 'black'
                       anchors {
                           left: parent.left
                           right: parent.right

                       }
                   }

            Rectangle {
                id: createSnapshotId
                height: 31
                color: "#A000A0"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    text: qsTr("Capture Surgical Area")
                    anchors.fill: parent
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: gmDebug.create_patRef_x_ict()
                }
            }

//            Rectangle {
//                id: runTestId
//                height: 31
//                color: "#0000A0"
//                anchors.left: parent.left
//                anchors.right: parent.right
//                anchors.leftMargin: 5
//                anchors.rightMargin: 5

//                Text {
//                    id: testCaseTxt
//                    text: qsTr("Run Unit Tests")
//                    anchors.fill: parent
//                    font.pixelSize: 16
//                    horizontalAlignment: Text.AlignHCenter
//                    verticalAlignment: Text.AlignVCenter
//                }

//                MouseArea {
//                    id: runTestButton
//                    anchors.fill: parent

//                    onClicked: gmDebug.runTests()
//                }
//            }

//            ScrollView {
//                //anchors.top: runTestId.bottom
//                anchors.left: parent.left
//                width: parent.width

//                TextEdit {
//                    anchors.fill: parent
//                    text: gmDebug.testData
//                    textFormat: TextEdit.RichText
//                    selectByMouse: true
//                }
//            }

            Rectangle {
                       height: 1
                       color: 'black'
                       anchors {
                           left: parent.left
                           right: parent.right

                       }
                   }

            Rectangle {
                id: genTransformGraph
                height: 31
                color: "#0000FF"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    id: transformGraph
                    text: qsTr("Generate Transform Graph")
                    anchors.fill: parent
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    id: generateTransformGraph
                    anchors.fill: parent

                    onClicked: gmDebug.generateTransformGraph()
                }
            }

            Rectangle {
                height: 1
                color: 'black'
                anchors {
                    left: parent.left
                    right: parent.right

                }
            }

            Rectangle {
                id: transformsId
                height: 31
                color: "#0000FA"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    id: transformsTxt
                    text: qsTr("Print transforms to console")
                    anchors.fill: parent
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    id: runTransformsButton
                    anchors.fill: parent

                    onClicked: gmDebug.updateTransforms()
                }
            }

            Rectangle {
                id: landmarkdsId
                height: 31
                color: "#F000FA"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    id: landmarkdsTxt
                    text: qsTr("Print landmarks to console \n in scan selected coordinates")
                    anchors.fill: parent
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    id: runLandmarkdsButton
                    anchors.fill: parent

                    onClicked: gmDebug.printLandmarks()
                }
            }

            Rectangle {
                height: 31
                color: "cyan"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    text: qsTr("Set fiducials for surface")
                    anchors.fill: parent
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: gmDebug.initSurfaceRegistration()
                }
            }

        }
    }
}
