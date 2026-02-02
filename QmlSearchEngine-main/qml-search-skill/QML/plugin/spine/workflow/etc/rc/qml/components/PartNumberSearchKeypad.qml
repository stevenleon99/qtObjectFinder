import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import GmQml 1.0
import Theme 1.0

CalculatorKeypad {
    Layout.margins: Theme.margin(2)
    numberEnabled: searchString.length < 14
    signButtonVisible: false

    property string searchString: ""

    signal enterPressed(string partNumber)

    onNumberPressed: {
        // automatic addition of period in part number
        if(searchString.length === 4 || searchString.length === 9)
            searchString += "."

        searchString += number
    }

    onClearPressed: {
        searchString = ""
    }

    onBackspacePressed: {
        // remove both period and previous charactor when reaching the period
        var removeChar = searchString.length === 6 || searchString.length === 11 ? 2 : 1
        searchString = searchString.substring(0, searchString.length - removeChar)
    }

    onEnterButtonPressed: enterPressed(searchString)
}
