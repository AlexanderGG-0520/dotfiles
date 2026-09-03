import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../theme" as Theme
import "../widgets"

PanelWindow {
    id: root
    // Do not shadow PanelWindow.screen: doing so creates every surface on the
    // compositor default screen instead of the Variants model screen.
    required property var targetScreen
    screen: targetScreen
    readonly property var hyprMonitor: Hyprland.monitorFor(targetScreen)

    anchors { top: true; left: true; right: true }
    exclusiveZone: 0
    implicitHeight: Theme.Metrics.topMargin + Theme.Metrics.islandHeight
    color: "transparent"

    Item {
        anchors.fill: parent

        WorkspaceStrip {
            anchors.left: parent.left
            anchors.leftMargin: Theme.Metrics.outerMargin
            anchors.top: parent.top
            anchors.topMargin: Theme.Metrics.topMargin
            screen: root.targetScreen
            hyprMonitor: root.hyprMonitor
        }

        ContextIsland {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Theme.Metrics.topMargin
        }

        SystemCluster {
            anchors.right: parent.right
            anchors.rightMargin: Theme.Metrics.outerMargin
            anchors.top: parent.top
            anchors.topMargin: Theme.Metrics.topMargin
            parentWindow: root
        }
    }
}
