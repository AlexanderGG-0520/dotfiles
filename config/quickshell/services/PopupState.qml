import QtQuick
import Quickshell
import Quickshell.Hyprland
pragma Singleton

QtObject {
    // The two anchored panels share one owner; OSD deliberately does not.
    property string panel: "none"
    // none, notifications, controlCenter, powerMenu
    property var panelScreen: null
    property var osdScreen: null



    function focusedScreen() {
        const monitor = Hyprland.focusedMonitor;
        for (let i = 0; i < Quickshell.screens.length; ++i) {
            const candidate = Quickshell.screens[i];
            const mapped = Hyprland.monitorFor(candidate);
            if (monitor && mapped && mapped.name === monitor.name)
                return candidate;

        }
        return Quickshell.screens.length ? Quickshell.screens[0] : null;
    }

    function toggle(which, screen) {
        if (panel === which) {
            closePanels();
            return ;
        }
        panelScreen = screen || focusedScreen();
        panel = which;
    }

    function closePanels() {
        panel = "none";
        panelScreen = null;
    }

}
