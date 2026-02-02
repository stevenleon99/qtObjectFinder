import QtQuick 2.12

Loader {
    id: loader
    active: false
    source: "TutorialPopup.qml"

    signal tutorialClosed()

    onLoaded: item.open()

    Connections {
        target: loader.item
        onClosed: {
            loader.tutorialClosed()
            loader.active = false
        }
    }
}
