import QtQuick 2.12
import QtQuick.Layouts 1.12

import ".."

import Theme 1.0

RowLayout {
    spacing: Theme.marginSize

    property vector3d position

    ValueStepper {
        valueLabel: position.x < 0 ? "R" : "L"
        value: Math.abs(position.x)
    }

    ValueStepper {
        valueLabel: position.y < 0 ? "A" : "P"
        value: Math.abs(position.y)
    }

    ValueStepper {
        valueLabel: position.z < 0 ? "I" : "S"
        value: Math.abs(position.z)
    }
}
