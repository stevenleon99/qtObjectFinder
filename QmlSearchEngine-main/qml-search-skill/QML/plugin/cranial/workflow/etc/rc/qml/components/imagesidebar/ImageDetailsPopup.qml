import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."

Popup {
    width: layout.width
    height: layout.height
    dim: false

    background: Rectangle { radius: Theme.margin(1); color: Theme.slate900 }

            FastsurferViewModel {
		        id: fastsurferVM
	        }

        HypothalamusViewModel {
		        id: hypothalamusVM
	        }

        VesselsViewModel {
		        id: vesselsVM
	        }

	property var volumeUuid
    property var isMerged

    function setup(positionItem, volumeUid, merged) {
        var position = positionItem.mapToItem(null, 0, 0)
        var newX = position.x + Theme.margin(1)
        var newY = position.y
        var bottomY = newY + height

        if (bottomY > 1080) {
            newY = position.y - height - Theme.margin(1)
        }

        x = newX
        y = newY

        imageDetailsVM.setVolume(volumeUid)
        volumeUuid = volumeUid
        fastsurferVM.setVolumeUid(volumeUid)
        hypothalamusVM.setVolumeUid(volumeUid)
        vesselsVM.setVolumeUid(volumeUid)
        isMerged = merged

        open()
    }

    ImageDetailsViewModel {
        id: imageDetailsVM
    }


    ColumnLayout {
        id: layout
        spacing: 0

        RowLayout {
            Layout.margins: spacing
            spacing: Theme.margin(2)

            Label {
                Layout.fillWidth: true
                state: "subtitle1"
                color: Theme.white
                text: qsTr("Image Details")
            }

            Button {
                enabled: imageDetailsVM.isDeletable
                state: "icon"
                icon.source: "qrc:/icons/trash.svg"
                color: Theme.red

                onClicked: {
                    imageDetailsVM.deleteVolume();
                    close();
                }
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/x.svg"
                color: Theme.navyLight

                onClicked: close()
            }
        }

        DividerLine { }

        ColumnLayout {
            Layout.margins: spacing
            spacing: Theme.margin(2)

            ColumnLayout {
                spacing: Theme.margin(1)

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(7)
                    radius: 4
                    color: Theme.slate900
                    border.color: Theme.blue
                    border.width: 2

                    ColumnLayout {
                        anchors { fill: parent; margins: Theme.margin(1) }
                        spacing: 0

                        Label {
                            id: label
                            state: "body1"
                            color: Theme.navyLight
                            text: qsTr("Label")
                        }

                        Item {
                            id: valueItem
                            Layout.fillWidth: true
                            Layout.preferredHeight: t1.height
                            property alias text: t1.text
                            property int spacing: 1
                            clip: true

                            Label {
                                id: t1
                                text: imageDetailsVM.label
                                width: 500
                                horizontalAlignment: Text.AlignLeft
                                state: "body1"
                                font { bold: true}
                                onTextChanged: x = 0
                                NumberAnimation on x { running: t1.text.length > 25; from: 25; to: -t1.width; duration: 6000; loops: Animation.Infinite }
                            }
                        }
                    }

                    MouseArea {
                        anchors { fill: parent }

                        onClicked: volumeRenamePopup.open()
                    }

                    TextFieldPopup {
                        id: volumeRenamePopup
                        initialText: imageDetailsVM.label
                        popupTitle: qsTr("Rename Volume")

                        onConfirmClicked: imageDetailsVM.setLabel(confirmedText)
                    }
                }

                RowLayout {

                    Label {
                        Layout.fillWidth: false
                        state: "caption"
                        color: Theme.navyLight
                        font.bold: true
                        text: qsTr("Details")
                    }

                    LayoutSpacer {}
                }

                Repeater {
                    model: ListModel {
                        ListElement { role_text: qsTr("Patient") }
                        ListElement { role_text: qsTr("Modality") }
                        ListElement { role_text: qsTr("Series") }
                        ListElement { role_text: qsTr("Scan Date") }
                        ListElement { role_text: qsTr("E3D Navigated") }
                    }

                    RowLayout {
                        spacing: Theme.margin(2)
                        visible: switch (index) {
                                 case 4: return imageDetailsVM.hasE3Dregistration?true:false
                                 default: return true
                                 }

                        Label {
                            Layout.fillWidth: true
                            state: "caption"
                            color: Theme.disabledColor
                            text: role_text
                        }

                        Label {
                            state: "body1"
                            color: Theme.white
                            font { bold: true }
                            elide: Text.ElideRight
                            text: switch (index) {
                                  case 0: return imageDetailsVM.patient
                                  case 1: return imageDetailsVM.modality
                                  case 2: return imageDetailsVM.series
                                  case 3: return imageDetailsVM.scanDate
                                  case 4: return ""
                                  default: return "---"
                                  }
                        }
                    }
                }

                OptionsDropdown {
                    id: myComboBox
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    Layout.leftMargin: Theme.marginSize
                    Layout.rightMargin: Theme.marginSize    
                    
                    model: imageDetailsVM.colormapList
                    currentIndex: imageDetailsVM.colormapCurrentIndex

                    onActivated: {
                       // console.log("Selected index: " + myComboBox.currentIndex);
                        //console.log("Selected value: " + myComboBox.model.get(myComboBox.currentIndex).value);
                        //console.log("Selected value: " + imageDetailsVM.colormapList[currentIndex] );
                        imageDetailsVM.setColormap(imageDetailsVM.colormapList[currentIndex] );
                    }
                }

            }
        }

        WindowLevelPopupControls {}

        AlgorithmPopupComponent {
        id: wholeBrainId
        visible: imageDetailsVM.hasSegmentationFastsurferLicense && imageDetailsVM.modality == "MR" 
		buttonVisible: !imageDetailsVM.isFastsurferSegmented
        buttonEnabled: !imageDetailsVM.isSegRunning && isMerged
        titleCombo: qsTr("Brain")
        checkedCombo: fastsurferVM.isSegmentationVisible

          onButtonClicked: {
					fastsurferVM.showAlert();
					close();
		  }

onToggleCombo: {
				fastsurferVM.toggleLabelVisibility(checked)   
			}

        }

  AlgorithmPopupComponent {
        id: hypothalamusId
        visible: imageDetailsVM.hasSegmentationFastsurferLicense && imageDetailsVM.modality == "MR"
		buttonVisible: !imageDetailsVM.isHypothalamusSegmented
        buttonEnabled: !imageDetailsVM.isSegRunning && isMerged
        titleCombo: qsTr("Hypothalamus")
        checkedCombo: hypothalamusVM.isSegmentationVisible

          onButtonClicked: {
					hypothalamusVM.showAlert();
					close();
		  }

            onToggleCombo: {
				hypothalamusVM.toggleLabelVisibility(checked)   
			}
        }
    

  AlgorithmPopupComponent {
        id: vesselsId
        visible: imageDetailsVM.hasSegmentationVesselsLicense
		buttonVisible: !imageDetailsVM.isVesselsSegmented
        buttonEnabled: !imageDetailsVM.isSegRunning && isMerged
        titleCombo: qsTr("Vessels")
        checkedCombo: vesselsVM.isSegmentationVisible

        onButtonClicked: {
		    vesselsVM.showAlert();
			close();
		}

        onToggleCombo: {
				vesselsVM.toggleLabelVisibility(checked)   
		}
  }
    }
}
