import "../theme" as Theme
import QtQuick
import Quickshell.Hyprland

Item {
    id: root

    readonly property var activeToplevel: Hyprland.activeToplevel
    readonly property string title: activeToplevel && activeToplevel.title ? activeToplevel.title : "Sapphire Shell"

    implicitWidth: Math.min(titleText.implicitWidth, 440)
    implicitHeight: titleText.implicitHeight

    Text {
        id: titleText

        width: root.implicitWidth
        text: root.title
        color: Theme.Colors.text
        font.family: Theme.Typography.uiFamily
        font.pixelSize: Theme.Typography.titleSize
        font.weight: Theme.Typography.uiWeight
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

}
