import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

ColumnLayout {
    x: Theme.margin(6)
    width: parent.width
    spacing: 0

    readonly property string pluginName: "apps_plugin_cranial_settings"

    Component.onCompleted: pluginModel.launchSettingsPlugin(this, pluginName)

    Component.onDestruction: pluginModel.quitPlugin(pluginName)
}
