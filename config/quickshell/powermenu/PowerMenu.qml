import "../services" as Services
import "../theme" as Theme
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    width: 400
    height: Services.PowerActions.pendingAction === "" ? 286 : 210
    radius: Theme.Metrics.radius
    color: Theme.Colors.surfaceElevated
    border.color: Theme.Colors.border
    border.width: 1

    Column {
        anchors.fill: parent
        anchors.margins: Theme.Metrics.panelPadding
        spacing: Theme.Metrics.groupGap
        visible: Services.PowerActions.pendingAction === ""

        Text {
            text: "Session"
            color: Theme.Colors.text
            font.family: Theme.Typography.uiFamily
            font.pixelSize: Theme.Typography.titleSize
            font.bold: true
        }

        Text {
            text: "Secure session and power controls"
            color: Theme.Colors.textMuted
            font.pixelSize: Theme.Typography.captionSize
        }

        Column {
            width: parent.width
            spacing: 3

            Repeater {
                model: [{
                    "key": "lock",
                    "label": "Lock",
                    "detail": "Secure this session",
                    "danger": false
                }, {
                    "key": "logout",
                    "label": "Log Out",
                    "detail": "End Hyprland session",
                    "danger": false
                }, {
                    "key": "suspend",
                    "label": "Suspend",
                    "detail": "Sleep this system",
                    "danger": false
                }, {
                    "key": "reboot",
                    "label": "Restart",
                    "detail": "Restart this system",
                    "danger": true
                }, {
                    "key": "poweroff",
                    "label": "Power Off",
                    "detail": "Shut down this system",
                    "danger": true
                }]

                delegate: Rectangle {
                    required property var modelData

                    width: parent.width
                    height: 38
                    radius: Theme.Metrics.innerRadius
                    color: modelData.danger ? "#2B2026" : "transparent"
                    border.color: modelData.danger ? "#75414B" : "transparent"
                    border.width: modelData.danger ? 1 : 0

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 11
                        spacing: 0

                        Text {
                            text: modelData.label
                            color: Theme.Colors.text
                            font.pixelSize: Theme.Typography.bodySize
                            font.bold: true
                        }

                        Text {
                            text: modelData.detail
                            color: Theme.Colors.textMuted
                            font.pixelSize: Theme.Typography.metadataSize
                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Services.PowerActions.request(modelData.key)
                    }

                }

            }

        }

    }

    Column {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 14
        visible: Services.PowerActions.pendingAction !== ""

        Text {
            text: Services.PowerActions.label(Services.PowerActions.pendingAction) + "?"
            color: Theme.Colors.text
            font.pixelSize: 19
            font.bold: true
        }

        Text {
            text: "This will end your current work session."
            color: Theme.Colors.textMuted
            font.pixelSize: Theme.Typography.bodySize
            wrapMode: Text.WordWrap
        }

        Item {
            width: 1
            height: 12
        }

        Row {
            spacing: 10

            Button {
                text: "Cancel"
                onClicked: Services.PowerActions.cancel()
            }

            Button {
                text: Services.PowerActions.label(Services.PowerActions.pendingAction)
                onClicked: Services.PowerActions.confirm()
            }

        }

    }

}
