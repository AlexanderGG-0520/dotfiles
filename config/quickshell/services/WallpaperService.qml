import QtQuick
import Quickshell.Io
pragma Singleton

// Fixed, packaged candidates avoid filesystem scans and thumbnail caches.
QtObject {
    id: root

    property string currentWallpaper: "/usr/share/hypr/wall0.png"
    readonly property var wallpapers: [{
        "name": "Sapphire One",
        "path": "/usr/share/hypr/wall0.png"
    }, {
        "name": "Sapphire Two",
        "path": "/usr/share/hypr/wall1.png"
    }, {
        "name": "Sapphire Three",
        "path": "/usr/share/hypr/wall2.png"
    }]
    property var applyProcess

    applyProcess: Process {
    }

    function apply(path) {
        // hyprpaper's native IPC sets the same image on all outputs.
        applyProcess.exec(["/usr/bin/hyprctl", "hyprpaper", "reload", "," + path]);
        currentWallpaper = path;
    }

}
