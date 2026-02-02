import QtQuick 2.12
import QtMultimedia 5.12

Item {
    visible: false

    SoundEffect {
        id: unpluggedSound
        source: "qrc:/sounds/unplugged.wav"
    }

    Timer {
        running: !systemPower.acPresent && !systemPower.acPresentMuted
        interval: 10000
        repeat: true
        triggeredOnStart: true

        onTriggered: unpluggedSound.play()
    }
}
