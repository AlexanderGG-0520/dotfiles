import "../theme" as Theme
import QtQuick
import Quickshell.Widgets

Rectangle {
    id: root

    required property var record
    required property var service
    property bool popup: false

    function iconSource() {
        if (record.image)
            return record.image;

        if (record.appIcon && record.appIcon.indexOf("/") >= 0)
            return record.appIcon;

        return "image://icon/" + (record.appIcon || "dialog-information");
    }

    width: parent ? parent.width : 360
    implicitHeight: content.implicitHeight + 28
    radius: Theme.Metrics.radius
    color: Theme.Colors.surfaceElevated
    border.width: Theme.Metrics.borderWidth
    border.color: record.urgency === 2 ? Theme.Colors.urgent : Theme.Colors.border

    Timer {
        id: expiry

        interval: root.service.popupExpiryMillis(root.record)
        running: root.popup && root.service.popupExpiryMillis(root.record) > 0
        repeat: false
        onTriggered: root.service.expire(root.record.key)
    }

    Column {
        id: content

        spacing: 6

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 14
        }

        Row {
            width: parent.width
            spacing: 9

            IconImage {
                width: 34
                height: 34
                source: root.iconSource()
            }

            Text {
                width: parent.width - 72
                text: root.record.appName
                color: Theme.Colors.textMuted
                font.family: Theme.Typography.uiFamily
                font.pixelSize: Theme.Typography.metadataSize
                elide: Text.ElideRight
            }

            Text {
                text: "×"
                color: Theme.Colors.textMuted
                font.pixelSize: 16

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.service.dismiss(root.record.key)
                }

            }

        }

        Text {
            width: parent.width
            text: root.record.summary
            visible: text.length > 0
            color: Theme.Colors.text
            font.family: Theme.Typography.uiFamily
            font.pixelSize: Theme.Typography.titleSize
            font.bold: true
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: root.record.body
            visible: text.length > 0
            color: Theme.Colors.textSecondary
            font.family: Theme.Typography.uiFamily
            font.pixelSize: Theme.Typography.captionSize
            wrapMode: Text.Wrap
            maximumLineCount: root.popup ? 3 : 7
            elide: Text.ElideRight
        }

        Row {
            visible: root.popup && root.service.isLive(root.record.key) && root.record.actions.length > 0
            spacing: 6

            Repeater {
                model: root.record.actions

                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    height: 25
                    width: Math.min(120, label.implicitWidth + 14)
                    radius: 8
                    color: Theme.Colors.accentDark

                    Text {
                        id: label

                        anchors.centerIn: parent
                        text: modelData.text
                        color: Theme.Colors.text
                        font.pixelSize: Theme.Typography.captionSize
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.service.invokeAction(root.record.key, index)
                    }

                }

            }

        }

    }

}
