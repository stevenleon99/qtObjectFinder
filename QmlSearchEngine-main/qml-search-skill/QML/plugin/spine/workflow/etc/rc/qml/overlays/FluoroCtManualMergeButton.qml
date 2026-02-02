import QtQuick.Controls 2.12

import Theme 1.0

Button {
    state: "icon"
    icon.width: Theme.margin(5)
    icon.height: Theme.margin(5)
    autoRepeat: true
    autoRepeatDelay: 500
    autoRepeatInterval: 50
}
