import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import Enums 1.0

import "../components"

RowLayout {
    id: sidebarTabBar
    spacing: 0

    property int activeTab: -1

    signal clicked(int tab)

    Repeater {
        model: ListModel { id: tabList }

        SidebarTab {
            objectName: "SidebarTab_" + role_text
            enabled: role_text
            source: role_source
            text: role_text
            active: activeTab == role_id
            lastTab: index === parent.count - 1

            onClicked: {
                if (!active)
                    sidebarTabBar.clicked(role_id)
            }
        }

        Component.onCompleted: {
            tabList.append({role_text: "Implants", role_source: "qrc:/icons/screw-planned", role_id: ActiveSideBarTab.Implants })
            tabList.append({role_text: "Tools", role_source: "qrc:/icons/tools", role_id: ActiveSideBarTab.Tools })
            tabList.append({role_text: "", role_source: "", role_id: -1 })
        }
    }
}
