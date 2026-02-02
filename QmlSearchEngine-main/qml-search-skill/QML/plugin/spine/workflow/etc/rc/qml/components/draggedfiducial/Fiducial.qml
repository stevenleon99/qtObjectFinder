import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Scene3D 2.0

import Theme 1.0

import ViewModels 1.0
import Enums 1.0

Rectangle {
    opacity: 0.5
    x: locX - (width / 2)
    y: locY - (height / 2)
    width: (6.35 / draggedCadVM.mmPerPixel) + (2 * border.width)
    height: width
    radius: width / 2
    border { width: 64; color: Theme.blue }
    color: Theme.transparent

    property double locX: 0
    property double locY: 0

    // reusing the one from dragged cad for viewport zoom. when possible, DraggedCadViewModel
    // need to be split into generic properties and dragged cad specific properties
    DraggedCadViewModel {
        id: draggedCadVM
    }
}
