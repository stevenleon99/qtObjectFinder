import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import "../components"
import "../components/toolspanel"
import "../components/implantspanel"

Item {
    Layout.preferredWidth: Theme.margin(45)
    Layout.fillHeight: true

    SidebarTabBarViewModel {
        id: sidebarTabBarViewModel
    }

    NavigationTips { }

    ColumnLayout {
        anchors { fill: parent }

        SidebarTabBar {
            id: sidebarTabs
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.preferredHeight: Theme.margin(10)

            activeTab: sidebarTabBarViewModel.activeTab

            onClicked: sidebarTabBarViewModel.setActiveTab(tab)
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true

            sourceComponent: {
                if (sidebarTabBarViewModel.activeTab == ActiveSideBarTab.Implants) {
                    return implantsPanelComponent
                } else if (sidebarTabBarViewModel.activeTab == ActiveSideBarTab.Tools) {
                    return toolsPanelComponent
                } else {
                    return undefined
                }
            }
        }

        Component {
            id: implantsPanelComponent

            ImplantsPanel {
                implantDetails: NavImplantDetails { }
            }
        }

        Component {
            id: toolsPanelComponent

            ToolsPanel { }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            PageControls {
                anchors { verticalCenter: parent.verticalCenter }
                width: parent.width
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }

    DividerLine {
        orientation: Qt.Vertical
        anchors { left: parent.left }
    }
}
