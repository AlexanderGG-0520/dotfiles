import "../services" as Services
import "../theme" as Theme
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var targetScreen
    required property var audioState

    screen: targetScreen
    visible: Services.PopupState.osdScreen === targetScreen && osd.shown
    implicitHeight: 50
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        bottom: true
        left: true
        right: true
    }

    margins {
        bottom: 56
    }

    Rectangle {
        id: osd

        property bool shown: false
        property bool microphone: false
        property real volume: 0
        property bool muted: false

        function show(mic, value, isMuted) {
            microphone = mic;
            volume = value;
            muted = isMuted;
            shown = true;
            hideTimer.restart();
        }

        anchors.horizontalCenter: parent.horizontalCenter
        width: 264
        height: 50
        radius: Theme.Metrics.radius
        color: Theme.Colors.surfaceElevated
        border.color: Theme.Colors.border
        border.width: 1

        Row {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: osd.microphone ? (osd.muted ? "Mic muted" : "Mic") : (osd.muted ? "Muted" : "Volume")
                color: Theme.Colors.textSecondary
                font.pixelSize: Theme.Typography.captionSize
            }

            Rectangle {
                width: 126
                height: 5
                radius: 3
                color: Theme.Colors.background

                Rectangle {
                    width: parent.width * Math.min(1, osd.volume)
                    height: parent.height
                    radius: 3
                    color: osd.muted ? Theme.Colors.textMuted : Theme.Colors.accent
                }

            }

            Text {
                text: Math.round(osd.volume * 100) + "%"
                color: Theme.Colors.text
                font.family: Theme.Typography.monoFamily
                font.pixelSize: Theme.Typography.captionSize
            }

        }

        Timer {
            id: hideTimer

            interval: 1100
            repeat: false
            onTriggered: osd.shown = false
        }

    }

    Connections {
        function onOutputChanged(volume, muted) {
            osd.show(false, volume, muted);
        }

        function onMicrophoneChanged(volume, muted) {
            osd.show(true, volume, muted);
        }

        target: root.audioState
    }

}
