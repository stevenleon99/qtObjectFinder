import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

RowLayout {
    Layout.preferredHeight: Theme.margin(8)
    spacing: Theme.margin(4)

    property alias title: settings.title
    property alias description: settings.description
    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value

    signal sliderMoved(int position)

    SurgeonSettingsDescription {
        id: settings
    }

    Slider {
        id: slider
        Layout.preferredWidth: Theme.margin(47)
        from: 0
        to: 100
        stepSize: 1

        onMoved: sliderMoved(value)
    }

    Label {
        Layout.leftMargin: -Theme.margin(2)
        state: "body1"
        text: slider.value + "%"
    }
}
