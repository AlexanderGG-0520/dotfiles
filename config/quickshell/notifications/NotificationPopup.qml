import "../services" as Services
import "../theme" as Theme
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var targetScreen
    required property var service

    screen: targetScreen
    visible: Services.PopupState.focusedScreen() === targetScreen && service.popups.length > 0
    implicitWidth: 360
    implicitHeight: stack.implicitHeight
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        right: true
    }

    margins {
        top: 58
        right: Theme.Metrics.outerMargin
    }

    Column {
        id: stack

        width: 360
        spacing: Theme.Metrics.spacing + 1

        Repeater {
            model: root.service.popups

            delegate: NotificationCard {
                required property var modelData

                width: 360
                record: modelData
                service: root.service
                popup: true
            }

        }

    }

}
