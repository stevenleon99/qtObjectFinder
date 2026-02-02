import QtQuick 2.12

import ViewModels 1.0

ImageViewerPopup {
    iconSource: "qrc:/icons/help-outline.svg"
    titleText: qsTr("Tutorial")
    model: tutorialViewModel.imageList

    OnboardingTutorialViewModel {
        id: tutorialViewModel
    }
}
