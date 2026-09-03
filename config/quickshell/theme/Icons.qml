import QtQuick
pragma Singleton

QtObject {
    // These are installed with the base Adwaita icon package. Explicit paths
    // keep primary shell indicators independent from the user's Qt icon theme.
    readonly property string root: "file:///usr/share/icons/Adwaita/symbolic/"
    readonly property string volumeHigh: root + "status/audio-volume-high-symbolic.svg"
    readonly property string volumeMuted: root + "status/audio-volume-muted-symbolic.svg"
    readonly property string microphone: root + "devices/audio-input-microphone-symbolic.svg"
    readonly property string networkWired: root + "devices/network-wired-symbolic.svg"
    readonly property string bluetooth: root + "status/bluetooth-active-symbolic.svg"
    readonly property string networkConnected: root + "status/network-wireless-signal-excellent-symbolic.svg"
    readonly property string networkDisconnected: root + "status/network-offline-symbolic.svg"
    readonly property string notifications: root + "legacy/preferences-system-notifications-symbolic.svg"
    readonly property string settings: root + "categories/preferences-system-symbolic.svg"
    readonly property string power: root + "actions/system-shutdown-symbolic.svg"
    readonly property string play: root + "actions/media-playback-start-symbolic.svg"
    readonly property string pause: root + "actions/media-playback-pause-symbolic.svg"
    readonly property string previous: root + "actions/media-skip-backward-symbolic.svg"
    readonly property string next: root + "actions/media-skip-forward-symbolic.svg"
    // Used only when a StatusNotifierItem supplies no usable icon source.
    readonly property string trayFallback: root + "categories/applications-system-symbolic.svg"
}
