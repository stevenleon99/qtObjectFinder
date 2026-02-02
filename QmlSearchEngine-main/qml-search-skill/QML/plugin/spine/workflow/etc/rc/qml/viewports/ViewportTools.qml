import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "../components"

import ViewportEnums 1.0
import ViewModels 1.0
import Cad2DRenderTypes 1.0
import Enums 1.0

ColumnLayout {
    spacing: 0

    ViewportToolsViewModel {
        id: viewportToolsViewModel
    }

    ColumnLayout {
        Layout.fillHeight: false
        spacing: 0

        Button {
            objectName: "windowLevelButton"  
            state: "icon"
            icon.source: "qrc:/icons/brightness-contrast.svg"
            checked: viewportToolsViewModel.windowLevelOverlayDisplayed
            checkable: true
            highlighted: checked
            
            onCheckedChanged: viewportToolsViewModel.windowLevelOverlayDisplayed = checked
        }

        Button {
            objectName: "measurementButton"  
            state: "icon"
            icon.source: "qrc:/icons/measure.svg"
            checked: viewportToolsViewModel.measurementOverlayDisplayed
            checkable: true
            highlighted: checked

            onCheckedChanged: viewportToolsViewModel.measurementOverlayDisplayed = checked
        }

        DividerLine {}

        Button {
            objectName: "implantRenderModeButton" 
            state: "icon"
            icon.source: {
                if (viewportToolsViewModel.cad2DRenderType == Cad2DRenderTypes.Intersection) {
                    return "qrc:/icons/screw-trajectory-toggle-2.svg";
                } else if (viewportToolsViewModel.cad2DRenderType == Cad2DRenderTypes.ProjectiveColorGradient) {
                    return "qrc:/icons/screw-trajectory-toggle-3.svg";
                } else if (viewportToolsViewModel.cad2DRenderType == Cad2DRenderTypes.Line) {
                    return "qrc:/icons/screw-trajectory-toggle-4.svg";
                }
            }
            property string sourcePath: icon.source
            onClicked: viewportToolsViewModel.cycleImplantRender2DType()
        }

        Button {
            objectName: "implantVisibilityButton" 
            state: "icon"
            icon.source: {
                if (viewportToolsViewModel.implantVisibilityType == ImplantVisibilityTypes.None) {
                    return "qrc:/icons/object-visibility/none.svg";
                } else if (viewportToolsViewModel.implantVisibilityType == ImplantVisibilityTypes.Active) {
                    return "qrc:/icons/object-visibility/single.svg";
                } else if (viewportToolsViewModel.implantVisibilityType == ImplantVisibilityTypes.SameLevel) {
                    return "qrc:/icons/object-visibility/double.svg";
                } else if (viewportToolsViewModel.implantVisibilityType == ImplantVisibilityTypes.All) {
                    return "qrc:/icons/object-visibility/full.svg";
                }
            }
            property string sourcePath: icon.source
            onClicked: viewportToolsViewModel.cycleImplantVisibilityType()
        }

        DividerLine {}

        Button {
            objectName: "recenterButton"  
            state: "icon"
            icon.source: "qrc:/icons/center.svg"
            onClicked: viewportToolsViewModel.recenterViews()
        }

        IconButton {
            objectName: "navigationTrackingModeButton" 
            state: "icon"
            icon.source: {
                if (navigationTrackingModePopup.navigationTrackingMode ==  View2DNavigationTrackingMode.ToolCentric)
                {
                    return "qrc:/images/tool-centric2.svg"
                }
                else if (navigationTrackingModePopup.navigationTrackingMode == View2DNavigationTrackingMode.ToolDynamic)
                {
                    return "qrc:/images/tool-dynamic.svg"
                }
                else if (navigationTrackingModePopup.navigationTrackingMode == View2DNavigationTrackingMode.ScanCentric)
                {
                    return "qrc:/images/image-lock.svg"
                }
            }
            property string sourcePath: icon.source

            active: navigationTrackingModePopup.visible
            enabled: navigationTrackingModePopup.enabled
            color: navigationTrackingModePopup.visible ? Theme.blue : Theme.white

            onPressed: {
                if (!navigationTrackingModePopup.visible)
                    navigationTrackingModePopup.setup(this)
            }

            NavigationTrackingModePopup {
                id: navigationTrackingModePopup
                visible: false
            }
        }

        Button {
            objectName: "interpolationModeButton"  
            state: "icon"
            visible: false
            icon.source: {
                if (viewportToolsViewModel.interpolationMode == ViewportInterpolationMode.Neighbor)
                    return "qrc:/icons/interpolate-nearest-neighbor.svg"
                else
                    return "qrc:/icons/interpolate-linear.svg"
            }

            onClicked: viewportToolsViewModel.cycleInterpolationMode()
        }

        Button {
            objectName: "sliceSliderVisibilityButton" 
            visible: false
            state: "icon"
            icon.source: "qrc:/images/image-thru.svg"
            color: viewportToolsViewModel.isSliceSliderVisible ? Theme.blue : Theme.white

            onClicked: viewportToolsViewModel.cycleSliceSliderVisibility();
        }

        IconButton {
            objectName: "scanOrientationButton" 
            state: "icon"
            visible: true
            icon.source: "qrc:/images/compass.svg"
            color: view2DOrientationTypePopup.visible ? Theme.blue : Theme.white
            active: view2DOrientationTypePopup.visible

            onPressed: {
                if (!view2DOrientationTypePopup.visible)
                    view2DOrientationTypePopup.setup(this)
            }

            View2DOrientationTypePopup {
                id: view2DOrientationTypePopup
                visible: false
            }
        }

        Button {
            objectName: "viewportConfigButton" 
            visible: viewportToolsViewModel.twoViewportModeButtonVisible
            enabled: viewportToolsViewModel.twoViewportModeButtonEnabled
            state: "icon"
            icon.source: viewportToolsViewModel.volumeTwoUpIsActive ? "qrc:/icons/window-grid-2x1.svg" : "qrc:/icons/window-grid-2x2.svg"
            property string sourcePath: icon.source
            onClicked: viewportToolsViewModel.toggleTwoViewportMode()
        }

        Button {
            objectName: "ictVisibilityButton" 
            visible: viewportToolsViewModel.ictMaskingButtonVisible
            state: "icon"
            icon.source: "qrc:/icons/ict-crop.svg"
            checked: viewportToolsViewModel.ictMaskingEnable
            checkable: true
            highlighted: checked

            onCheckedChanged: viewportToolsViewModel.ictMaskingEnable = checked
        }

        Button {
            objectName: "viewportSetToggleButton" 
            visible: viewportToolsViewModel.viewportSetToggleButtonVisible
            enabled: viewportToolsViewModel.viewportSetToggleButtonEnabled
            state: "icon"
            icon.source: viewportToolsViewModel.usingVolumeViewportSet ? "qrc:/icons/3d.svg" : "qrc:/icons/image-fluoro.svg"

            onClicked: viewportToolsViewModel.toggleUsingVolumeViewportSet()
        }

        DividerLine {}

        Button {
            objectName: "instrumentPlanningButton"  
            state: "icon"
            icon.source: "qrc:/icons/plan-tool2.svg"
            highlighted: viewportToolsViewModel.instrumentPlanningEnabled
            
            onClicked: viewportToolsViewModel.toggleInstrumentPlanning()
        }

        Button {
                objectName: "cadVisibilityButton" 
                state: "icon"
                icon.source: viewportToolsViewModel.instrumentPlanningCadEnabled ? "qrc:/icons/visibility-on" : "qrc:/icons/visibility-off"

                onClicked: viewportToolsViewModel.toggleInstrumentPlanningCad()
            }

        Button {
            objectName: "accuracyTestButton" 
             visible: viewportToolsViewModel.isTestMode
             state: "icon"
             icon.source: "qrc:/images/accuracy-check.svg"
             highlighted: viewportToolsViewModel.accuracyTest2dOverlayEnabled

             onClicked: viewportToolsViewModel.toggle2dAccuracyOverlay()
        }
    }

    LayoutSpacer { }
}
