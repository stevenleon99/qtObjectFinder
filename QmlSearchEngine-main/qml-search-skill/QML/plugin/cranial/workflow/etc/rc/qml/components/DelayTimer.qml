import QtQuick 2.10

// This component is a timer similar to the default Timer class except that
// it also has a delay property that defines how long to delay before the
// timer starts repeating. This is usefult to trigger a button that repeats
// it's action after you press and hold for some amount of time.
// This timer can be started and stopped using the start() and
// stop() methods or by setting "running" property directly.
Item {
    id: root

    property alias delay: delayTimer.interval
    property alias interval: repeatTimer.interval
    property bool triggeredOnStart: false
    property bool running: false

    signal triggered

    function start() {
        running = true;
    }

    function stop() {
        running = false;
    }

    onRunningChanged: {
        if (running === true) {
            if (triggeredOnStart) {
                root.triggered();
            }
            delayTimer.start();
        }
        else {
            delayTimer.stop();
            repeatTimer.stop();
        }

    }

    Timer {
        id: delayTimer
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            repeatTimer.start();
        }
    }

    Timer {
        id: repeatTimer
        repeat: true
        triggeredOnStart: true
        onTriggered: root.triggered()
    }
}
