import "../theme" as Theme
import QtQuick
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: root

    required property var screen
    required property var hyprMonitor
    readonly property var workspaceModel: Hyprland.workspaces

    height: Theme.Metrics.islandHeight
    width: workspaceRow.width + Theme.Metrics.workspacePadding * 2
    radius: Theme.Metrics.radius
    color: Qt.rgba(0.063, 0.082, 0.114, Theme.Metrics.workspaceOpacity)
    border.color: Qt.rgba(0.24, 0.3, 0.38, 0.72)
    border.width: Theme.Metrics.borderWidth

    Row {
        id: workspaceRow

        anchors.centerIn: parent
        spacing: 10

        Repeater {

            model: ScriptModel {
                // The relation is object identity from Hyprland's live model, not a name/ID range.
                values: root.hyprMonitor ? root.workspaceModel.values.filter((workspace) => {
                    return workspace.monitor === root.hyprMonitor;
                }) : []
            }

            delegate: Item {
                required property var modelData
                readonly property var workspace: modelData

                width: workspace.active ? 26 : (workspace.toplevels.values.length > 0 ? 6 : 5)
                height: 24

                Rectangle {
                    anchors.centerIn: parent
                    visible: workspace.active
                    width: parent.width + 4
                    height: 10
                    radius: 5
                    color: Qt.rgba(0.31, 0.55, 1, 0.12)
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: workspace.active ? 6 : 5
                    radius: height / 2
                    color: workspace.urgent ? Theme.Colors.urgent : workspace.active ? Theme.Colors.accent : workspace.toplevels.values.length > 0 ? Qt.rgba(0.31, 0.55, 1, 0.44) : Qt.rgba(0.54, 0.59, 0.67, 0.32)

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.Animations.workspace
                        }

                    }

                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: workspace.activate()
                }

                Behavior on width {
                    NumberAnimation {
                        duration: Theme.Animations.workspace
                        easing.type: Easing.OutCubic
                    }

                }

            }

        }

    }

}
