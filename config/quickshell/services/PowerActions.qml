import "." as Services
import QtQuick
import Quickshell.Io
pragma Singleton

// Each operation invokes its own supported session/system API. No action is
// multiplexed through a shell script and no credentials enter Quickshell.
QtObject {
    id: root

    property string pendingAction: ""
    property var runner

    runner: Process {
    }

    function label(action) {
        return ({
            "logout": "Log Out",
            "reboot": "Restart",
            "poweroff": "Power Off"
        })[action] || action;
    }

    function request(action) {
        if (action === "lock" || action === "suspend")
            execute(action);
        else
            pendingAction = action;
    }

    function cancel() {
        pendingAction = "";
    }

    function confirm() {
        const action = pendingAction;
        pendingAction = "";
        execute(action);
    }

    function execute(action) {
        Services.PopupState.closePanels();
        if (action === "lock")
            runner.exec(["/usr/bin/hyprlock"]);
        else if (action === "logout")
            runner.exec(["/usr/bin/uwsm", "stop"]);
        else if (action === "suspend")
            runner.exec(["/usr/bin/loginctl", "suspend"]);
        else if (action === "reboot")
            runner.exec(["/usr/bin/loginctl", "reboot"]);
        else if (action === "poweroff")
            runner.exec(["/usr/bin/loginctl", "poweroff"]);
    }

}
