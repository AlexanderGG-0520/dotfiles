import "./controlcenter" as ControlCenter
import "./notifications" as Notifications
import "./osd" as Osd
import "./powermenu" as PowerMenu
import "./services" as Services
import "./theme" as Theme
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    required property var notificationService
    required property var audioState

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData
            visible: Services.PopupState.panelScreen === modelData && Services.PopupState.panel !== "none"
            implicitWidth: 400
            implicitHeight: Services.PopupState.panel === "notifications" ? 530
                : (Services.PopupState.panel === "powerMenu" ? 286
                : (Services.SystemCapabilities.hasWallpaperBackend ? 516 : 452))
            color: "transparent"
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

            anchors {
                top: true
                right: true
            }

            margins {
                top: 58
                right: Theme.Metrics.outerMargin
            }

            Loader {
                anchors.fill: parent
                active: parent.visible
                sourceComponent: Services.PopupState.panel === "notifications" ? notificationPanel : (Services.PopupState.panel === "powerMenu" ? powerPanel : controlPanel)
            }

            Shortcut {
                sequence: "Escape"
                onActivated: Services.PopupState.closePanels()
            }

            Component {
                id: notificationPanel

                Notifications.NotificationCenter {
                    service: root.notificationService
                }

            }

            Component {
                id: controlPanel

                ControlCenter.ControlCenter {
                }

            }

            Component {
                id: powerPanel

                PowerMenu.PowerMenu {
                }

            }

        }

    }

    Variants {
        model: Quickshell.screens

        Notifications.NotificationPopup {
            required property var modelData

            targetScreen: modelData
            service: root.notificationService
        }

    }

    Variants {
        model: Quickshell.screens

        Osd.OsdHost {
            required property var modelData

            targetScreen: modelData
            audioState: root.audioState
        }

    }

}
