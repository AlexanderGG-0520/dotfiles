import "../services" as Services
import "../theme" as Theme
import QtQuick
import QtQuick.Controls
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Rectangle {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var connectedDevice: Networking.devices.values.find((device) => device.connected) || null
    readonly property var connectedNetwork: connectedDevice ? connectedDevice.networks.values.find((network) => network.connected) || null : null
    readonly property var players: Mpris.players.values
    readonly property var player: players.find((candidate) => candidate.isPlaying) || players[0] || null
    readonly property var bluetoothAdapter: Bluetooth.defaultAdapter
    property string currentTime: Qt.formatTime(new Date(), "HH:mm")

    // Track the same default nodes used by the shared audio OSD. This keeps
    // source updates and default-source replacement reactive while open.
    PwObjectTracker { objects: [root.sink, root.source].filter((node) => node) }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root.currentTime = Qt.formatTime(new Date(), "HH:mm")
    }

    function clamp(value) { return Math.max(0, Math.min(1.5, Number.isFinite(value) ? value : 0)); }
    function nodeVolume(node) { return node && node.audio ? clamp(node.audio.volume) : 0; }
    function setNodeVolume(node, value) { if (node && node.audio) node.audio.volume = clamp(value); }
    function toggleMute(node) { if (node && node.audio) node.audio.muted = !node.audio.muted; }

    width: 390
    height: Services.SystemCapabilities.hasWallpaperBackend ? 516 : 452
    radius: 15
    color: Theme.Colors.surfaceElevated
    border.color: Qt.rgba(0.25, 0.35, 0.49, 0.7)
    border.width: 1

    Column {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 11

        Item {
            width: parent.width
            height: 25
            Column {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 1
                Text { text: "CONTROL"; color: Theme.Colors.text; font.family: Theme.Typography.uiFamily; font.weight: Font.Bold; font.pixelSize: 13; font.letterSpacing: 1.5 }
                Text { text: "SYSTEM SURFACE"; color: Theme.Colors.textMuted; font.family: Theme.Typography.monoFamily; font.pixelSize: 9; font.letterSpacing: 1.1 }
            }
            Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: root.currentTime; color: Theme.Colors.accentBright; font.family: Theme.Typography.monoFamily; font.pixelSize: 14; font.weight: Font.Medium }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.Colors.border }

        Column {
            width: parent.width
            spacing: 8
            Text { text: "AUDIO"; color: Theme.Colors.textMuted; font.family: Theme.Typography.monoFamily; font.pixelSize: 10; font.letterSpacing: 1.4 }

            Row {
                width: parent.width; height: 45; spacing: 10
                IconImage {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17; height: 17
                    source: !root.sink || !root.sink.audio || root.sink.audio.muted ? Theme.Icons.volumeMuted : Theme.Icons.volumeHigh
                    opacity: root.sink && root.sink.audio ? 1 : 0.38
                    MouseArea { anchors.fill: parent; onClicked: root.toggleMute(root.sink) }
                }
                Column {
                    width: parent.width - 27; anchors.verticalCenter: parent.verticalCenter; spacing: 5
                    Item {
                        width: parent.width; height: 12
                        Text { anchors.left: parent.left; width: parent.width - 42; text: root.sink ? (root.sink.description || root.sink.name || "Output") : "No output device"; color: Theme.Colors.text; font.pixelSize: 11; font.weight: Font.Medium; elide: Text.ElideRight }
                        Text { anchors.right: parent.right; text: root.sink && root.sink.audio ? Math.round(root.nodeVolume(root.sink) * 100) + "%" : "—"; color: root.sink && root.sink.audio && root.sink.audio.muted ? Theme.Colors.textMuted : Theme.Colors.accentBright; font.family: Theme.Typography.monoFamily; font.pixelSize: 10 }
                    }
                    Slider {
                        id: outputSlider
                        width: parent.width; height: 14; from: 0; to: 1.5
                        enabled: root.sink && root.sink.audio
                        value: root.nodeVolume(root.sink)
                        onMoved: root.setNodeVolume(root.sink, value)
                        background: Rectangle {
                            x: outputSlider.leftPadding; y: outputSlider.topPadding + outputSlider.availableHeight / 2 - height / 2
                            width: outputSlider.availableWidth; height: 4; radius: 2; color: Theme.Colors.background
                            Rectangle { width: outputSlider.visualPosition * parent.width; height: parent.height; radius: 2; color: Theme.Colors.accent }
                        }
                        handle: Rectangle {
                            x: outputSlider.leftPadding + outputSlider.visualPosition * (outputSlider.availableWidth - width)
                            y: outputSlider.topPadding + outputSlider.availableHeight / 2 - height / 2
                            width: 10; height: 10; radius: 5; color: Theme.Colors.text
                        }
                    }
                }
            }

            Row {
                width: parent.width; height: 45; spacing: 10
                IconImage {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 17; height: 17; source: Theme.Icons.microphone
                    opacity: root.source && root.source.audio && !root.source.audio.muted ? 1 : 0.38
                    MouseArea { anchors.fill: parent; onClicked: root.toggleMute(root.source) }
                }
                Column {
                    width: parent.width - 27; anchors.verticalCenter: parent.verticalCenter; spacing: 5
                    Item {
                        width: parent.width; height: 12
                        Text { anchors.left: parent.left; width: parent.width - 42; text: root.source ? (root.source.description || root.source.name || "Microphone") : "No microphone connected"; color: root.source && root.source.audio ? Theme.Colors.text : Theme.Colors.textMuted; font.pixelSize: 11; font.weight: Font.Medium; elide: Text.ElideRight }
                        Text { anchors.right: parent.right; text: root.source && root.source.audio ? Math.round(root.nodeVolume(root.source) * 100) + "%" : "—"; color: root.source && root.source.audio && !root.source.audio.muted ? Theme.Colors.accentBright : Theme.Colors.textMuted; font.family: Theme.Typography.monoFamily; font.pixelSize: 10 }
                    }
                    Slider {
                        id: inputSlider
                        width: parent.width; height: 14; from: 0; to: 1.5
                        enabled: root.source && root.source.audio
                        value: root.nodeVolume(root.source)
                        onMoved: root.setNodeVolume(root.source, value)
                        background: Rectangle {
                            x: inputSlider.leftPadding; y: inputSlider.topPadding + inputSlider.availableHeight / 2 - height / 2
                            width: inputSlider.availableWidth; height: 4; radius: 2; color: Theme.Colors.background
                            Rectangle { width: inputSlider.visualPosition * parent.width; height: parent.height; radius: 2; color: Theme.Colors.accent }
                        }
                        handle: Rectangle {
                            x: inputSlider.leftPadding + inputSlider.visualPosition * (inputSlider.availableWidth - width)
                            y: inputSlider.topPadding + inputSlider.availableHeight / 2 - height / 2
                            width: 10; height: 10; radius: 5; color: Theme.Colors.text
                        }
                    }
                }
            }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.Colors.border }

        Column {
            width: parent.width; visible: root.player !== null; spacing: 6
            Text { text: "MEDIA"; color: Theme.Colors.textMuted; font.family: Theme.Typography.monoFamily; font.pixelSize: 10; font.letterSpacing: 1.4 }
            Row {
                width: parent.width; height: 25
                Text { width: parent.width - 58; anchors.verticalCenter: parent.verticalCenter; text: root.player ? ((root.player.trackTitle || "Unknown title") + "  ·  " + (root.player.trackArtist || "Unknown artist")) : ""; color: Theme.Colors.text; font.pixelSize: 11; elide: Text.ElideRight }
                IconImage { width: 18; height: 18; source: Theme.Icons.previous; visible: root.player && root.player.canGoPrevious; MouseArea { anchors.fill: parent; onClicked: root.player.previous() } }
                IconImage { width: 22; height: 22; source: root.player && root.player.isPlaying ? Theme.Icons.pause : Theme.Icons.play; MouseArea { anchors.fill: parent; onClicked: root.player.togglePlaying() } }
                IconImage { width: 18; height: 18; source: Theme.Icons.next; visible: root.player && root.player.canGoNext; MouseArea { anchors.fill: parent; onClicked: root.player.next() } }
            }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.Colors.border }

        Column {
            width: parent.width; spacing: 7
            Row {
                width: parent.width
                IconImage { width: 15; height: 15; source: root.connectedNetwork ? Theme.Icons.networkConnected : Theme.Icons.networkWired }
                Text { width: parent.width - 92; leftPadding: 9; text: root.connectedNetwork ? root.connectedNetwork.name : (!Services.SystemCapabilities.hasWifi && root.connectedDevice ? "Ethernet" : "Network"); color: Theme.Colors.text; font.pixelSize: 11; elide: Text.ElideRight }
                Text { text: root.connectedDevice ? "CONNECTED" : (Networking.wifiEnabled ? "SEARCHING" : "OFF"); color: root.connectedDevice ? Theme.Colors.accentBright : Theme.Colors.textMuted; font.family: Theme.Typography.monoFamily; font.pixelSize: 9 }
            }
            Row {
                width: parent.width; visible: Services.SystemCapabilities.hasBluetooth
                IconImage { width: 15; height: 15; source: Theme.Icons.bluetooth; opacity: root.bluetoothAdapter && root.bluetoothAdapter.enabled ? 1 : 0.4 }
                Text { width: parent.width - 46; leftPadding: 9; text: "Bluetooth"; color: Theme.Colors.text; font.pixelSize: 11 }
                Item {
                    width: 30; height: 15
                    Text { anchors.right: parent.right; text: root.bluetoothAdapter && root.bluetoothAdapter.enabled ? "ON" : "OFF"; color: root.bluetoothAdapter && root.bluetoothAdapter.enabled ? Theme.Colors.accentBright : Theme.Colors.textMuted; font.family: Theme.Typography.monoFamily; font.pixelSize: 9 }
                    MouseArea { anchors.fill: parent; onClicked: { if (root.bluetoothAdapter) root.bluetoothAdapter.enabled = !root.bluetoothAdapter.enabled } }
                }
            }
        }

        Column {
            width: parent.width; visible: Services.SystemCapabilities.hasWallpaperBackend; spacing: 6
            Rectangle { width: parent.width; height: 1; color: Theme.Colors.border }
            Text { text: "WALLPAPER"; color: Theme.Colors.textMuted; font.family: Theme.Typography.monoFamily; font.pixelSize: 10; font.letterSpacing: 1.4 }
            Row {
                spacing: 6
                Repeater {
                    model: Services.WallpaperService.wallpapers
                    delegate: Rectangle {
                        required property var modelData
                        width: 112; height: 22; radius: 5
                        color: Services.WallpaperService.currentWallpaper === modelData.path ? Theme.Colors.accentDark : Theme.Colors.surface
                        border.color: Theme.Colors.border; border.width: 1
                        Text { anchors.centerIn: parent; text: modelData.name; color: Theme.Colors.text; font.pixelSize: 9 }
                        MouseArea { anchors.fill: parent; onClicked: Services.WallpaperService.apply(modelData.path) }
                    }
                }
            }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.Colors.border }

        Item {
            width: parent.width; height: 22
            Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "SESSION"; color: Theme.Colors.textMuted; font.family: Theme.Typography.monoFamily; font.pixelSize: 10; font.letterSpacing: 1.2 }
            Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: "POWER  ›"; color: Theme.Colors.accentBright; font.pixelSize: 10; font.weight: Font.Medium }
            MouseArea { anchors.fill: parent; onClicked: Services.PopupState.toggle("powerMenu", Services.PopupState.panelScreen) }
        }
    }
}
