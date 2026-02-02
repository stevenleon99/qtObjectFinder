import QtQuick 2.2
import QtQuick.Dialogs 1.1

MessageDialog {
    id: messageDialog
    title: "Configuration Error"
    text: "Failed to parse the config files.\nPlease check config files and try again."
    onAccepted: {
        Qt.quit()
    }
    Component.onCompleted: visible = true
}
