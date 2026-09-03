import QtQuick
import Quickshell
import "../theme" as Theme

Text {
    id: root
    SystemClock { id: clock; precision: SystemClock.Minutes }
    text: Qt.formatDateTime(clock.date, "HH:mm")
    color: Theme.Colors.text
    font.family: Theme.Typography.monoFamily
    font.pixelSize: Theme.Typography.clockSize
}
