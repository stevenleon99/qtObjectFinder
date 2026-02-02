import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewportEnums 1.0
import ViewModels 1.0
import Cad2DRenderTypes 1.0
import GmQml 1.0

ColumnLayout {
    spacing: 0

    ViewportToolsViewModel {
        id: viewportToolsViewModel
    }

    ColumnLayout {
        Layout.fillHeight: true
        spacing: 0

        Button {
            state: "icon"
            icon.source: "qrc:/icons/brightness-contrast.svg"
            checked: viewportToolsViewModel.windowLevelOverlayDisplayed
            checkable: true
            highlighted: checked
            
            onCheckedChanged: viewportToolsViewModel.windowLevelOverlayDisplayed = checked
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/center.svg"
            onClicked: viewportToolsViewModel.recenterViews()
        }

        Button {
            state: "icon"
            icon.source: {
                if (coordinateSystemPopup.coordinateType == View2DCoordinateType.ActiveTrajectory)
                {
                    return "qrc:/images/crosshair-trajectory.svg"
                }
                else if (coordinateSystemPopup.coordinateType == View2DCoordinateType.ActiveTool)
                {
                    return "qrc:/images/crosshair-tool.svg"
                }
                else
                {
                    return "qrc:/images/crosshair-image.svg"
                }
            }

            color: coordinateSystemPopup.coordinateUniform ? Theme.white : Theme.disabledColor

            onClicked: coordinateSystemPopup.setup(this)

            View2DCoordinateSystemPopup {
                id: coordinateSystemPopup
                visible: false
            }
        }

        Button {
            state: "icon"
            icon.source: {
                if  (viewportToolsViewModel.compareModeColor == CompareModeColor.SingleColor)
                {
                    return "qrc:/images/color-blend-single.svg"
                }
                else if  (viewportToolsViewModel.compareModeColor == CompareModeColor.DualColor)
                {
                    return "qrc:/images/color-blend-double.svg"
                }
                else if  (viewportToolsViewModel.compareModeColor == CompareModeColor.NoColor)
                {
                    return "qrc:/images/color-blend.svg"
                }
            }

            onClicked: viewportToolsViewModel.cycleBlendMode()
        }

        Button {
            state: "icon"
            visible: true
            icon.source: {
                if  (viewportToolsViewModel.compareMode == CompareMode.Single)
                {
                    return "qrc:/icons/image-single.svg"
                }
                else if  (viewportToolsViewModel.compareMode == CompareMode.CheckerBoard)
                {
                    return "qrc:/icons/checkerboard.svg"
                }
                else if (viewportToolsViewModel.compareMode == CompareMode.Alpha)
                {
                    return "qrc:/icons/blend.svg"
                }
            }

            onClicked: viewportToolsViewModel.cycleCompareMode()
        }

        Slider {
            visible: viewportToolsViewModel.isOpacitySliderVisible
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            orientation: Qt.Vertical
            handleIcon: "qrc:/icons/visibility-on.svg"
            from: 1
            value: viewportToolsViewModel.compareOpacity
            to: 0

            onValueChanged: viewportToolsViewModel.compareOpacity = value
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/measure.svg"
            checked: viewportToolsViewModel.measurementOverlayDisplayed
            checkable: true
            highlighted: checked
            
            onCheckedChanged: viewportToolsViewModel.measurementOverlayDisplayed = checked            
        }

        Button {
            state: "icon"
            icon.source: "qrc:/images/show-off-slice.svg"
            color: viewportToolsViewModel.render2DType == Cad2DRenderTypes.FullProjective ? Theme.blue : Theme.white

            onClicked: viewportToolsViewModel.cycleTrajectoriesRender2DType();
        }

        Button {
            state: "icon"
            icon.source: "qrc:/images/image-thru.svg"
            color: clipSlicePopup.isSliceSliderVisible ? Theme.blue : Theme.white

            onClicked: clipSlicePopup.setup(this)

            ClipSlicePopup {
                id: clipSlicePopup
                visible: false
            }
        }

        Button {
            state: "icon"
            visible: true
            icon.source: {
                if (view2DOrientationTypePopup.view2dOrientationType == View2DOrientationType.Neuro)
                {
                    return "qrc:/images/orientation-LR.svg"
                }
                else if (view2DOrientationTypePopup.view2dOrientationType == View2DOrientationType.Radio)
                {
                    return "qrc:/images/orientation-RL.svg"
                }
            }

            onClicked: view2DOrientationTypePopup.setup(this)

            View2DOrientationTypePopup {
                id: view2DOrientationTypePopup
                visible: false
            }
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/tool-planning.svg"
            color: viewportToolsViewModel.isToolFollowingEnabled ? Theme.blue : Theme.white

            onClicked: viewportToolsViewModel.toggleToolFollowing()
        }

        Button {
            state: "icon"
            icon.source: "qrc:/images/slice-lines.svg"
            color: viewportToolsViewModel.areCrosshairsVisible ? Theme.blue : Theme.white

            onClicked: viewportToolsViewModel.toggleCrosshairs();
        }

        Button {
            visible: viewportToolsViewModel.isSkinMeshButtonVisible
            state: "icon"
            icon.source: "qrc:/icons/mesh.svg"
           
            color: Theme.white 

            onClicked: skinMeshPopup.setup(this)

            SkinMeshPopup {
                id: skinMeshPopup
                visible: false
            }
        }

        Button {
            state: "icon"
            icon.source: "qrc:/images/fine-movement-controls.svg"
            visible: viewportToolsViewModel.isMergeVolumeButtonsVisible
            checked: viewportToolsViewModel.mergeVolumeOverlayDisplayed
            checkable: true
            highlighted: checked
            
            onCheckedChanged: viewportToolsViewModel.mergeVolumeOverlayDisplayed = checked
        }

        LayoutSpacer { }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/step-back.svg"
            color: Theme.white
            enabled: viewportToolsViewModel.isUndoButtonEnabled
            visible: viewportToolsViewModel.isUndoRedoButtonsVisible
            onClicked: viewportToolsViewModel.undoTrajectory()
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/step-forward.svg"
            color: Theme.white
            enabled: viewportToolsViewModel.isRedoButtonEnabled
            visible: viewportToolsViewModel.isUndoRedoButtonsVisible
            onClicked: viewportToolsViewModel.redoTrajectory()
        }
    }
}
