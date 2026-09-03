import "../theme" as Theme
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    required property var service

    width: 400
    height: 530
    radius: Theme.Metrics.radius
    color: Theme.Colors.surfaceElevated
    border.color: Theme.Colors.border
    border.width: 1

    Column {
        anchors.fill: parent
        anchors.margins: Theme.Metrics.panelPadding
        spacing: Theme.Metrics.groupGap

        Row {
            width: parent.width

            Text {
                text: "Notifications"
                color: Theme.Colors.text
                font.family: Theme.Typography.uiFamily
                font.pixelSize: Theme.Typography.titleSize
                font.bold: true
            }

            Item {
                width: parent.width - 180
                height: 1
            }

            Text {
                text: "Clear all"
                color: Theme.Colors.accentBright
                font.pixelSize: Theme.Typography.captionSize

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.service.clearAll()
                }

            }

        }

        Item {
            visible: root.service.history.length === 0
            width: parent.width
            height: 430

            Text {
                anchors.centerIn: parent
                text: "No recent notifications"
                color: Theme.Colors.textMuted
                font.family: Theme.Typography.uiFamily
                font.pixelSize: Theme.Typography.captionSize
            }

        }

        ListView {
            visible: root.service.history.length > 0
            width: parent.width
            height: 460
            spacing: Theme.Metrics.spacing + 1
            clip: true
            model: root.service.history

            delegate: NotificationCard {
                required property var modelData

                width: ListView.view.width
                record: modelData
                service: root.service
            }

        }

    }

}
