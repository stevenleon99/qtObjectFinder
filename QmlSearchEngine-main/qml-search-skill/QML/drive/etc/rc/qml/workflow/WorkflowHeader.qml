import QtQuick 2.12
import QtQuick.Controls 2.5

import "../components"

Item {
    anchors { fill: parent }

    Component.onCompleted: pluginModel.launchHeaderPlugin(this, drivePageViewModel.workflowPluginName)
}
