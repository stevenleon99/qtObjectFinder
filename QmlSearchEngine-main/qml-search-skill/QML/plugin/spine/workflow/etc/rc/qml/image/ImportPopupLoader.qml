import QtQuick 2.12

import ViewModels 1.0

Loader {
    source: "qrc:/imports/DriveImport/ImportPopup.qml"

    onLoaded: {
        item.importModel = importViewModelSource.volumeImportViewModel
        item.patientName = importPopupLoaderVM.patientName
    }

    ImportPopupLoaderViewModel {
        id: importPopupLoaderVM
    }
}
