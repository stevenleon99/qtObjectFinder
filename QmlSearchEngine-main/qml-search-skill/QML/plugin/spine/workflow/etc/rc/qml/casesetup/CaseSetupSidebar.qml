import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0

Item {
    Layout.preferredWidth: Theme.margin(45)
    Layout.fillHeight: true
    
    ColumnLayout {
        anchors { fill: parent }
        spacing: 0
        
        WorkflowCategorySelection { }
        
        CaseImplantSystemList { }
        
        ImplantSystemSelection { }
    }
    
    DividerLine {
        anchors { right: parent.right }
    }
}
