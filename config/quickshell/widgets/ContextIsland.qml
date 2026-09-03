import "../theme" as Theme
import QtQuick

Rectangle {
    id: root

    readonly property bool mediaActive: media.available

    width: Math.min(480, Math.max(280, content.implicitWidth + Theme.Metrics.contextPadding * 2))
    height: Theme.Metrics.islandHeight
    radius: Theme.Metrics.radius
    color: Qt.rgba(0.09, 0.12, 0.17, Theme.Metrics.contextOpacity)
    border.color: Qt.rgba(0.31, 0.55, 1, 0.38)
    border.width: Theme.Metrics.borderWidth

    Item {
        id: content

        anchors.centerIn: parent
        implicitWidth: root.mediaActive ? media.implicitWidth : activeWindow.implicitWidth
        implicitHeight: Theme.Metrics.islandHeight

        MediaWidget {
            id: media

            anchors.centerIn: parent
            opacity: root.mediaActive ? 1 : 0
            visible: opacity > 0
        }

        ActiveWindowWidget {
            id: activeWindow

            anchors.centerIn: parent
            width: Math.min(440, implicitWidth)
            opacity: root.mediaActive ? 0 : 1
            visible: opacity > 0
        }

    }

    Behavior on width {
        NumberAnimation {
            duration: Theme.Animations.context
            easing.type: Easing.OutCubic
        }

    }

}
