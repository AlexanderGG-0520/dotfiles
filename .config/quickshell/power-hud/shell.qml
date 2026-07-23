import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

ShellRoot {
  id: root

  readonly property color bg: "#06111d"
  readonly property color bgAlt: "#0b1623"
  readonly property color bgSoft: "#111c2c"
  readonly property color fg: "#e4ebf3"
  readonly property color muted: "#93a4b7"
  readonly property color border: "#24384b"
  readonly property color borderSoft: "#162536"
  readonly property color selectedBg: "#0e1b29"
  readonly property color selectedBorder: "#39546d"

  property string confirmAction: ""

  function focusedScreen() {
    for (const screen of Quickshell.screens) {
      const monitor = Hyprland.monitorFor(screen);
      if (monitor && monitor.focused) {
        return screen;
      }
    }

    return Quickshell.screens.length > 0 ? Quickshell.screens[0] : null;
  }

  function showHud() {
    confirmAction = "";
    overlayWindow.visible = true;
    Qt.callLater(function() {
      panel.forceActiveFocus();
    });
  }

  function launch(command) {
    launcher.command = command;
    launcher.startDetached();
    closeHud();
  }

  function openConfirm(action) {
    confirmAction = action;
  }

  function closeHud() {
    confirmAction = "";
    overlayWindow.visible = false;
  }

  function toggleHud() {
    if (overlayWindow.visible) {
      closeHud();
    } else {
      showHud();
    }
  }

  function runMainAction(kind) {
    if (kind === "lock") {
      launch(["sh", "-lc", "command -v hyprlock >/dev/null 2>&1 && hyprlock"]);
      return;
    }

    if (kind === "sleep") {
      launch(["systemctl", "suspend"]);
      return;
    }

    if (kind === "logout") {
      launch(["hyprctl", "dispatch", "exit"]);
      return;
    }

    if (kind === "restart") {
      openConfirm("restart");
      return;
    }

    if (kind === "shutdown") {
      openConfirm("shutdown");
      return;
    }

    closeHud();
  }

  function confirmLabel() {
    return confirmAction === "restart" ? "Restart" : "Shutdown";
  }

  function confirmCommand() {
    return confirmAction === "restart"
      ? ["systemctl", "reboot"]
      : ["systemctl", "poweroff"];
  }

  Process {
    id: launcher
    running: false
  }

  IpcHandler {
    target: "power-hud"

    function toggle(): void {
      root.toggleHud();
    }
  }

  PanelWindow {
    id: overlayWindow
    visible: false
    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }
    screen: root.focusedScreen()
    focusable: true
    aboveWindows: true
    color: "#a006111d"

    Rectangle {
      anchors.fill: parent
      color: "transparent"

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: root.closeHud()
      }

      Rectangle {
        id: panel
        width: 444
        height: 292
        radius: 22
        color: root.bg
        border.color: root.border
        border.width: 1
        clip: true
        focus: true
        anchors.centerIn: parent
        antialiasing: true
        Component.onCompleted: forceActiveFocus()

        Keys.onEscapePressed: root.closeHud()

        Column {
          anchors.fill: parent
          anchors.margins: 16
          spacing: 12

          Text {
            width: parent.width
            text: "Power"
            color: root.fg
            font.pixelSize: 14
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
          }

          Grid {
            id: actionGrid
            visible: root.confirmAction === ""
            width: parent.width
            columns: 3
            rowSpacing: 10
            columnSpacing: 10

            readonly property var actions: [
              { kind: "lock", glyph: "󰌾", label: "Lock" },
              { kind: "sleep", glyph: "󰒲", label: "Sleep" },
              { kind: "logout", glyph: "󰗼", label: "Logout" },
              { kind: "restart", glyph: "󰜉", label: "Restart" },
              { kind: "shutdown", glyph: "󰐥", label: "Shutdown" },
              { kind: "cancel", glyph: "󰜺", label: "Cancel" }
            ]

            Repeater {
              model: actionGrid.actions

              delegate: PowerCard {
                required property var modelData
                width: 130
                height: 96
                glyph: modelData.glyph
                label: modelData.label
                kind: modelData.kind
                onTriggered: root.runMainAction(kind)
              }
            }
          }

          Rectangle {
            id: confirmPane
            visible: root.confirmAction !== ""
            width: parent.width
            height: 176
            radius: 18
            color: root.bgSoft
            border.color: root.borderSoft
            border.width: 1

            Column {
              anchors.fill: parent
              anchors.margins: 14
              spacing: 14

              Text {
                width: parent.width
                text: `${root.confirmLabel()}?`
                color: root.fg
                font.pixelSize: 15
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
              }

              Text {
                width: parent.width
                text: root.confirmAction === "restart"
                  ? "Restart the session now."
                  : "Power off the machine now."
                color: root.muted
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
              }

              Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                ConfirmCard {
                  width: 136
                  height: 80
                  glyph: "󰜺"
                  label: "Cancel"
                  accent: false
                  onTriggered: root.confirmAction = ""
                }

                ConfirmCard {
                  width: 136
                  height: 80
                  glyph: root.confirmAction === "restart" ? "󰜉" : "󰐥"
                  label: root.confirmLabel()
                  accent: true
                  onTriggered: root.launch(root.confirmCommand())
                }
              }
            }
          }
        }
      }
    }
  }

  component PowerCard: Rectangle {
    id: card

    property string glyph: ""
    property string label: ""
    property string kind: ""
    property bool hovered: false
    property bool pressed: false

    signal triggered()

    radius: 16
    color: pressed ? "#0d1a27" : hovered ? root.selectedBg : root.bgAlt
    border.color: pressed ? root.selectedBorder : hovered ? root.selectedBorder : root.borderSoft
    border.width: 1
    scale: pressed ? 0.985 : hovered ? 1.02 : 1.0
    opacity: pressed ? 0.95 : 1.0
    antialiasing: true

    Behavior on color {
      ColorAnimation {
        duration: 120
        easing.type: Easing.OutCubic
      }
    }

    Behavior on border.color {
      ColorAnimation {
        duration: 120
        easing.type: Easing.OutCubic
      }
    }

    Behavior on scale {
      NumberAnimation {
        duration: 120
        easing.type: Easing.OutCubic
      }
    }

    Behavior on opacity {
      NumberAnimation {
        duration: 120
        easing.type: Easing.OutCubic
      }
    }

    Column {
      anchors.centerIn: parent
      spacing: 5

      Text {
        width: 96
        text: card.glyph
        color: root.fg
        font.pixelSize: 27
        font.family: "Symbols Nerd Font"
        horizontalAlignment: Text.AlignHCenter
      }

      Text {
        width: 96
        text: card.label
        color: root.fg
        font.pixelSize: 12
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onEntered: card.hovered = true
      onExited: card.hovered = false
      onPressed: card.pressed = true
      onReleased: card.pressed = false
      onCanceled: card.pressed = false
      onClicked: card.triggered()
    }
  }

  component ConfirmCard: Rectangle {
    id: card

    property string glyph: ""
    property string label: ""
    property bool accent: false
    property bool hovered: false
    property bool pressed: false

    signal triggered()

    radius: 14
    color: hovered
      ? (accent ? root.selectedBg : root.bgAlt)
      : (accent ? root.bgAlt : root.bgSoft)
    border.color: hovered
      ? (accent ? root.selectedBorder : root.border)
      : (accent ? root.border : root.borderSoft)
    border.width: 1
    scale: pressed ? 0.985 : hovered ? 1.015 : 1.0
    opacity: pressed ? 0.95 : 1.0
    antialiasing: true

    Behavior on color {
      ColorAnimation {
        duration: 120
        easing.type: Easing.OutCubic
      }
    }

    Behavior on border.color {
      ColorAnimation {
        duration: 120
        easing.type: Easing.OutCubic
      }
    }

    Behavior on scale {
      NumberAnimation {
        duration: 120
        easing.type: Easing.OutCubic
      }
    }

    Behavior on opacity {
      NumberAnimation {
        duration: 120
        easing.type: Easing.OutCubic
      }
    }

    Column {
      anchors.centerIn: parent
      spacing: 4

      Text {
        width: 92
        text: card.glyph
        color: root.fg
        font.pixelSize: 20
        font.family: "Symbols Nerd Font"
        horizontalAlignment: Text.AlignHCenter
      }

      Text {
        width: 92
        text: card.label
        color: root.fg
        font.pixelSize: 11
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onEntered: card.hovered = true
      onExited: card.hovered = false
      onPressed: card.pressed = true
      onReleased: card.pressed = false
      onCanceled: card.pressed = false
      onClicked: card.triggered()
    }
  }
}
