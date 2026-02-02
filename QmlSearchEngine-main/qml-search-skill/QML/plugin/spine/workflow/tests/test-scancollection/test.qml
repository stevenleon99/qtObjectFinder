import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Window 2.1
import QtQuick.Dialogs 1.1
import GpsClient 1.0
import QtQml.Models 2.1

Window {
    id: mainUI
    width: 900
    height: 780
    color: "gray"
    visible: true

    Rectangle {
        id: newPatientListRect
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 5
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5
        anchors.top: scanDirectory.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        color: "#00000000"
        radius: 10
        border.width: 2
        ListView {
            id: newPatientList
            clip: true
            anchors.top: newPatientTxt.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 5
            anchors.margins: 10

            model: controller.newPatientList
            delegate: Item {
                x: 5
                width: 300
                height: 50
                Rectangle {
                    id: rect
                    anchors.fill: parent
                    anchors.margins: 5
                    color: "#444444"
                    radius: 10
                    Row {
                        id: row1
                        anchors.fill: parent
                        anchors.leftMargin: 20

                        //                Rectangle {
                        //                    width: 40
                        //                    height: 40
                        //                    color: "blue"
                        //                }

                        Text {
                            text: controller.newPatientList[index].lastName ? controller.newPatientList[index].lastName : "--"
                            anchors.verticalCenter: row1.verticalCenter
                        }

                        Text {
                            text: controller.newPatientList[index].firstName ? controller.newPatientList[index].firstName : "--"
                            anchors.verticalCenter: row1.verticalCenter
                        }

                        Text {
                            text: controller.newPatientList[index].entryCount ? controller.newPatientList[index].entryCount : "--"
                            anchors.verticalCenter: row1.verticalCenter
                        }

                        spacing: 10
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            controller.addPatientToDb(controller.newPatientList[index].uuid);
                        }
                    }
                }
            }

        }

        Text {
            id: newPatientTxt
            text: qsTr("New Patients")
            horizontalAlignment: Text.AlignHCenter
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 5
            font.pointSize: 10
        }
    }

    Rectangle {
        id: patientInDbRect
        color: "#00000000"
        radius: 10
        border.width: 2
        anchors.bottom: newPatientListRect.bottom
        anchors.bottomMargin: 0
        anchors.top: newPatientListRect.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 5
        ListView {
            id: patientList
            clip: true
            anchors.top: patientInDbTxt.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 5
            anchors.margins: 10
            model: DelegateModel {
                model: controller.patientModel
                delegate: Item {
                    id: patientItem
                    x: 5
                    width: parent.width-10
                    height: 50
                    Rectangle {
                        id: rect2
                        anchors.fill: parent
                        anchors.margins: 5
                        color: "#444444"
                        radius: 10

                        Rectangle {
                            width: 20
                            height:20
                            radius:10
                            anchors.margins: 3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            color: "red"
                            visible: newScanCount
                            Text {
                                anchors.centerIn: parent
                                text: newScanCount
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: parent.top
                            anchors.topMargin: 5
                            text: (lastName ? lastName : "--") + ", " + (firstName ? firstName : "--")
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                            text: dateTime ? dateTime.toLocaleDateString() + " | " + dateTime.toLocaleTimeString() : "--"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                patientList.currentIndex = index
                             }
                        }
                    }
                }
                filterOnGroup:  showAll.checked ?  "showAllPatientScans" : "onlyPatientWithVisibleScans"

                items.includeByDefault: false
                groups: [
                    DelegateModelGroup {
                        id: showAllPatientScans
                        name: "showAllPatientScans"
                        includeByDefault: true
                        onChanged: {
                            if(onlyPatientWithVisibleScans.count) {
                                onlyPatientWithVisibleScans.remove(0,onlyPatientWithVisibleScans.count)
                            }
                            for(var i=0;i<count;i++) {
                                var mItm = get(i);
                                if(mItm.model.visible) {
                                    showAllPatientScans.addGroups(i,1,"onlyPatientWithVisibleScans")
                                }
                            }
                        }
                    },
                    DelegateModelGroup {
                        id: onlyPatientWithVisibleScans
                        name: "onlyPatientWithVisibleScans"
                        includeByDefault: false
                    }
                ]


            }

            onCountChanged: {
                scanList.model.model = controller.patientModel
                scanList.model.rootIndex = patientList.model.modelIndex(patientList.currentIndex)
            }

            onCurrentIndexChanged: {
                scanList.model.model = controller.patientModel
                scanList.model.rootIndex = patientList.model.modelIndex(patientList.currentIndex)
            }
        }

        Text {
            id: patientInDbTxt
            text: qsTr("Patient In DB")
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 5
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 10
        }
    }

    Button {
        id: scanDirectory
        x: 31
        y: 9
        width: 138
        height: 23
        text: qsTr("Scan Directory...")
        onClicked: {
            fileDialog.visible = true
        }
    }

    FileDialog {
        id: fileDialog
        modality: Qt.WindowModal
        title: "Choose a folder"
        selectExisting: true
        selectMultiple: false
        selectFolder: true
        //        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        //        selectedNameFilter: "All files (*)"
        //        sidebarVisible: fileDialogSidebarVisible.checked
        onAccepted: {
            console.log("Accepted: " + fileUrls)
            controller.scanDirectory(fileUrls)
        }
        onRejected: { console.log("Rejected") }
    }

    Rectangle {
        id: percentageDone
        width: 200
        color: (controller.usbStatus === ScanManager.NO_DISK ? "#666666" :
               (controller.usbStatus === ScanManager.DISK_ACTIVE ? "red" :
               (controller.usbStatus === ScanManager.DISK_IDLE ? "green": "#444444")))
        radius: 10
        anchors.left: scanDirectory.right
        anchors.leftMargin: 20
        anchors.bottom: scanDirectory.bottom
        anchors.bottomMargin: 0
        anchors.top: scanDirectory.top

        Text {
            id: scanPercentText
            text: (controller.usbStatus === ScanManager.NO_DISK ? "No USB" :
                  (controller.usbStatus === ScanManager.DISK_ACTIVE ? "USB Active" :
                  (controller.usbStatus === ScanManager.DISK_IDLE ? "USB Idle" :
                   controller.usbStatus === ScanManager.USB_DISABLED ? "Local Disk Mode" : "No Connection To DataIoManager")))
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pointSize: 10
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(controller.usbStatus === ScanManager.USB_DISABLED) {
                    controller.enableUSB()
                }
            }
        }
    }

    Rectangle {
        id: scanstoload
        width: 200
        color: controller.itemToLoadCount ? "red" : "#666666"
        radius: 10
        anchors.left: percentageDone.right
        anchors.leftMargin: 20
        anchors.topMargin: 0
        anchors.top: scanDirectory.top
        anchors.bottom: scanDirectory.bottom
        Text {
            id: scanToLoadCount
            text:  controller.itemToLoadCount ? controller.itemToLoadCount.toString() + " toLoad" : qsTr("Loading Completed")
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
        }
        anchors.bottomMargin: 0
    }

    Rectangle {
        id: scanListRect
        color: "transparent"
        radius: 10
        anchors.rightMargin: 0
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.top: newPatientListRect.bottom
        anchors.right: newPatientListRect.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        border.width: 2

        ListView {
            id: scanList
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.top: scanListTxt.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 5

            model: DelegateModel {
                model: 0
                rootIndex: 0
                onRootIndexChanged: {
                    updateThumbnails();
                }

                delegate: Item {
                    x: 5
                    width: parent.width-10
                    height: 50
                   Rectangle {
                        id: rect3
                        anchors.fill: parent
                        anchors.margins: 5
                        color: "#444444"
                        radius: 10
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            //text: uid
                            text: dateTime ? scanType + " | " + dateTime : scanType

                        }
                        Rectangle {
                            width: 20
                            height:20
                            radius:10
                            anchors.margins: 3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            color: "red"
                            visible: newScanCount
                            Text {
                                anchors.centerIn: parent
                                text: newScanCount
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                scanList.currentIndex = index
                            }
                        }
                    }
                }
            }



            onCurrentIndexChanged: {
                updateThumbnails();
            }


        }

        Text {
            id: scanListTxt
            text: qsTr("Scan Collection List")
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 5
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 10
        }


    }

    function updateThumbnails() {
        if(scanList.model.items.count && scanList.currentIndex >=0 ) {
            var mItem = scanList.model.items.get(scanList.currentIndex).model
//         s   if(mItem.itemType === "Scan")  {
//                singleScanModel.setProperty(0,'uid',mItem.uid)
//                thumbnailView.model.model = singleScanModel
//                thumbnailView.model.rootIndex = 0
//            } else
                if(mItem.itemType === "Study"){
                thumbnailView.model.model = controller.patientModel
                thumbnailView.model.rootIndex = scanList.model.modelIndex(scanList.currentIndex)
            } else {
                thumbnailView.model.model = 0
                thumbnailView.model.rootIndex = 0
            }
        }
    }

    Rectangle {
        id: thumbnailsRect
        color: "transparent"
        radius: 10
        border.width: 2
        anchors.right: patientInDbRect.right
        anchors.rightMargin: 0
        anchors.left: patientInDbRect.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.top: newPatientListRect.bottom
        anchors.topMargin: 5
        clip: true

        Text {
            id: thumbnailTxt
            text: qsTr("Scan Thumbnails")
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 10
        }

        GridView {
            id: thumbnailView
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.top: thumbnailTxt.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 5
            cellHeight: 125
            cellWidth: 125
            model: DelegateModel {
                model: 0
                rootIndex: 0

                filterOnGroup:  showAll.checked ?  "allItems" : "newNread"

                items.includeByDefault: false
                groups: [
                    DelegateModelGroup {
                        id: allItems
                        name: "allItems"
                        includeByDefault: true
                        onChanged: {
                            if(newReadItems.count) {
                                newReadItems.remove(0,newReadItems.count)
                            }
                            for(var i=0;i<count;i++) {
                                var mItm = get(i);
                                if(mItm.model.visible) {
                                    allItems.addGroups(i,1,"newNread")
                                }
                            }
                        }
                    },
                    DelegateModelGroup {
                        id: newReadItems
                        name: "newNread"
                        includeByDefault: false
                    }
                ]


                delegate: Item {
                    width: 125; height: 125
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 5
                        anchors.bottomMargin: 10
                        color: "#555555"
                        Image {
                            anchors.fill: parent
                            source: "image://patientDb/" + uid
                            fillMode: Image.PreserveAspectFit
                            Rectangle {
                                visible: status === ScanCollectionItem.NEW
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: 5
                                color:"red"
                                width: 10
                                height: 10
                                radius: 5

                            }
                        }

                    }
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.margins: 5
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: th.contentHeight
                        color: "#555555"
                        Text {
                            id: th
                            visible: showAll.checked
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: 10
                            text: {
                                switch(status) {
                                case ScanCollectionItem.NEW:
                                    return "New"
                                case ScanCollectionItem.READ:
                                    return "Read"
                                case ScanCollectionItem.HIDDEN:
                                    return "Hidden"
                                case ScanCollectionItem.DELETED:
                                    return "Deleted"
                                }
                            }
                        }
                        Text {
                            visible: !showAll.checked
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: 10
                            text: dateTime ? dateTime.toLocaleTimeString() : "--"
                        }
                    }


                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(showAll.checked) {
                                if(status === ScanCollectionItem.NEW) {
                                    status = ScanCollectionItem.READ
                                } else  if(status === ScanCollectionItem.READ ) {
                                    status = ScanCollectionItem.HIDDEN
                                } else if(status === ScanCollectionItem.HIDDEN) {
                                    status = ScanCollectionItem.DELETED
                                } else if(status === ScanCollectionItem.DELETED) {
                                    status = ScanCollectionItem.NEW
                                }
                            } else if(status === ScanCollectionItem.NEW) {
                                    status = ScanCollectionItem.READ
                            }
                        }
                    }
                }
            }
        }
    }

    CheckBox {
        id: showAll
        y: 15
        text: qsTr("ShowAll")
        anchors.verticalCenter: scanstoload.verticalCenter
        anchors.left: scanstoload.right
        anchors.leftMargin: 20
    }
}

