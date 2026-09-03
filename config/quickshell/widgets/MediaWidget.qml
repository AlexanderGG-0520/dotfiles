import "../theme" as Theme
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets

Item {
    id: root

    readonly property var players: Mpris.players.values
    // Prefer actively playing players; retain deterministic model order otherwise.
    readonly property var player: players.find((player) => {
        return player.isPlaying;
    }) || players[0] || null
    readonly property bool available: player !== null

    implicitWidth: available ? mediaRow.implicitWidth : 0
    implicitHeight: available ? mediaRow.implicitHeight : 0

    Row {
        id: mediaRow

        visible: root.available
        spacing: Theme.Metrics.spacing
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            width: 5
            height: 5
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.Colors.accent
        }

        Text {
            width: 260
            text: root.player ? ((root.player.trackTitle || "Unknown Title") + " — " + (root.player.trackArtist || "Unknown Artist")) : ""
            color: Theme.Colors.text
            font.family: Theme.Typography.uiFamily
            font.pixelSize: Theme.Typography.bodySize
            elide: Text.ElideRight
        }

        Text {
            text: "‹"
            visible: root.player && root.player.canGoPrevious
            color: Theme.Colors.textMuted
            font.pixelSize: 18

            MouseArea {
                anchors.fill: parent
                onClicked: root.player.previous()
            }

        }

        IconImage {
            width: 14
            height: 14
            visible: root.player && root.player.canTogglePlaying
            source: root.player && root.player.isPlaying ? Theme.Icons.pause : Theme.Icons.play

            MouseArea {
                anchors.fill: parent
                onClicked: root.player.togglePlaying()
            }

        }

        Text {
            text: "›"
            visible: root.player && root.player.canGoNext
            color: Theme.Colors.textMuted
            font.pixelSize: 18

            MouseArea {
                anchors.fill: parent
                onClicked: root.player.next()
            }

        }

    }

}
