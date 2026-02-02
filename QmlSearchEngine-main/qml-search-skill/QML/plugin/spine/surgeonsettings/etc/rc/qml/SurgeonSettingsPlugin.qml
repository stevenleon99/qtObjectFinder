import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

ColumnLayout {
    x: Theme.margin(6)
    width: parent.width
    spacing: Theme.marginSize * 2


    PairingSystemsSettings {}
    
    DividerLine {}

    ViewportSettings {}

    DividerLine {}

    WorkflowSettings {}
}
