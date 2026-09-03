import "../services" as Services
import "../theme" as Theme
import QtQuick
import Quickshell.Widgets

Rectangle {
    id: root

    required property var parentWindow

    height: Theme.Metrics.islandHeight
    width: clusterRow.width + Theme.Metrics.clusterPadding * 2
    radius: Theme.Metrics.radius
    color: Qt.rgba(0.063, 0.082, 0.114, Theme.Metrics.clusterOpacity)
    border.color: Qt.rgba(0.26, 0.33, 0.42, 0.82)
    border.width: Theme.Metrics.borderWidth

    Row {
        id: clusterRow

        anchors.centerIn: parent
        spacing: 10

        VolumeWidget {
        }

        NetworkWidget {
        }

        Item {
            width: 5
            height: 1
        }

        IconImage {
            width: 16
            height: 16
            source: Theme.Icons.notifications

            MouseArea {
                anchors.fill: parent
                onClicked: Services.PopupState.toggle("notifications", root.parentWindow.targetScreen)
            }

        }

        IconImage {
            width: 16
            height: 16
            source: Theme.Icons.settings

            MouseArea {
                anchors.fill: parent
                onClicked: Services.PopupState.toggle("controlCenter", root.parentWindow.targetScreen)
            }

        }

        IconImage {
            width: 16
            height: 16
            source: Theme.Icons.power

            MouseArea {
                anchors.fill: parent
                onClicked: Services.PopupState.toggle("powerMenu", root.parentWindow.targetScreen)
            }

        }

        TrayWidget {
            parentWindow: parent.parentWindow
        }

        Item {
            width: 6
            height: 1
        }

        ClockWidget {
        }

    }

}
