import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "../theme" as Theme

Item {
    id: root
    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: root.sink ? [root.sink] : [] }
    implicitWidth: volumeRow.implicitWidth
    implicitHeight: volumeRow.implicitHeight

    Row {
        id: volumeRow
        spacing: 5
        IconImage {
            width: 15; height: 15
            source: !root.sink || !root.sink.audio || root.sink.audio.muted
                ? Theme.Icons.volumeMuted : Theme.Icons.volumeHigh
        }
        Text {
            text: root.sink && root.sink.audio ? Math.round(root.sink.audio.volume * 100) + "%" : "—"
            color: Theme.Colors.text
            font.family: Theme.Typography.monoFamily
            font.pixelSize: Theme.Typography.captionSize
        }
    }
}
