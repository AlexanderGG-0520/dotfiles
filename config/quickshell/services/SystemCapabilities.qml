import QtQuick
import Quickshell.Bluetooth
import Quickshell.Networking
pragma Singleton

// The only source used to decide whether a device control is rendered.
// Bluetooth and networking are signal-driven Quickshell services; the local
// backlight/DDC probes are intentionally static per shell lifecycle.
QtObject {
    id: root

    readonly property bool hasBluetooth: Bluetooth.defaultAdapter !== null
    readonly property bool hasWifi: Networking.wifiHardwareEnabled && Networking.devices.values.some((device) => {
        return device.type === DeviceType.Wifi;
    })
    readonly property bool hasBacklight: false // Discovery: no /sys/class/backlight entries.
    readonly property bool hasDdcBrightness: false // Discovery: ddcutil is absent.
    readonly property bool hasHyprlock: true // Discovery: /usr/bin/hyprlock.
    readonly property bool hasWallpaperBackend: true // Discovery: /usr/bin/hyprpaper.
    readonly property bool canSuspend: true // logind manager is available to this graphical session.
    readonly property bool canHibernate: false // Not advertised by the current host.
}
