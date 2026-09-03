import QtQuick
import Quickshell.Networking
import Quickshell.Widgets
import "../theme" as Theme

Item {
    id: root
    readonly property var connectedDevice: Networking.devices.values.find(device => device.connected) || null
    readonly property var connectedNetwork: connectedDevice
        ? connectedDevice.networks.values.find(network => network.connected) || null : null
    implicitWidth: networkRow.implicitWidth
    implicitHeight: networkRow.implicitHeight

    Row {
        id: networkRow
        spacing: 5
        IconImage {
            width: 15; height: 15
            source: root.connectedDevice
                ? Theme.Icons.networkConnected : Theme.Icons.networkDisconnected
        }
        Text {
            width: 108
            visible: root.connectedNetwork !== null
            text: root.connectedNetwork ? root.connectedNetwork.name : ""
            color: Theme.Colors.text
            font.family: Theme.Typography.uiFamily
            font.pixelSize: Theme.Typography.captionSize
            font.weight: Theme.Typography.uiWeight
            elide: Text.ElideRight
        }
    }
}
