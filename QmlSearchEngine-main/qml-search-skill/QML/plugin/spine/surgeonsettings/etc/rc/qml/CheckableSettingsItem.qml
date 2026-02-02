import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0


RowLayout {
    Layout.preferredHeight: Theme.marginSize * 4
    spacing: Theme.margin(4)

    property alias title: settings.title
    property alias description: settings.description
    property alias checkState: checkBox.checkState

    signal checkBoxClicked()

    SurgeonSettingsDescription {
        id: settings
    }

    CheckBox {
        id: checkBox
        checkable: false
        onClicked: checkBoxClicked()
    }
}
