import "../theme" as Theme
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.SystemTray

Row {
    id: root

    required property var parentWindow

    spacing: 6

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayItem
            required property var modelData

            // SystemTrayItem.icon can be either a freedesktop icon name or an
            // image provider URL carrying an SNI pixmap. Provider URLs must be
            // given directly to Image; iconPath() only accepts icon names.
            readonly property string requestedIcon: String(modelData.icon || "")
            readonly property bool isNativeImageSource: /^(image|file|qrc|data):/i.test(requestedIcon)
                || requestedIcon.startsWith("/")
            readonly property string checkedThemeIcon: isNativeImageSource || !requestedIcon
                ? "" : Quickshell.iconPath(requestedIcon, true)
            readonly property bool usingFallback: !requestedIcon
                || (!isNativeImageSource && !checkedThemeIcon)
            readonly property string resolvedIcon: isNativeImageSource
                ? requestedIcon : (checkedThemeIcon || Theme.Icons.trayFallback)
            readonly property bool symbolic: usingFallback
                || /-symbolic(?:\.[^/?#]+)?(?:[?#].*)?$/i.test(requestedIcon)
                || /-symbolic(?:\.[^/?#]+)?(?:[?#].*)?$/i.test(resolvedIcon)
            // Opt-in diagnostics for inspecting SNI metadata without normal log noise.
            readonly property bool diagnosticsEnabled: Qt.application.arguments.indexOf("--tray-debug") !== -1

            function logTrayItem() {
                if (diagnosticsEnabled)
                    console.info("[tray] id=" + modelData.id
                        + " title=" + modelData.title
                        + " icon=" + requestedIcon
                        + " resolved=" + resolvedIcon
                        + " status=" + modelData.status
                        + " category=" + modelData.category)
            }

            width: 16
            height: 16
            visible: modelData.status !== 0

            Component.onCompleted: logTrayItem()
            Connections {
                target: modelData
                function onIconChanged() { trayItem.logTrayItem() }
            }

            // Keep the backing texture alive across SNI updates. In particular,
            // Fcitx can switch between symbolic and colored icons at runtime.
            Image {
                id: trayIconImage
                anchors.fill: parent
                source: trayItem.resolvedIcon
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                visible: false
                layer.enabled: true
            }

            // This is deliberately beneath the effect: errors and initial
            // asynchronous loads never expose Quickshell's missing-icon texture.
            Image {
                anchors.fill: parent
                source: Theme.Icons.trayFallback
                fillMode: Image.PreserveAspectFit
                opacity: 0.78
            }

            MultiEffect {
                anchors.fill: parent
                source: trayIconImage
                visible: trayIconImage.status === Image.Ready
                opacity: 0.78
                colorization: trayItem.symbolic ? 1.0 : 0.0
                colorizationColor: Theme.Colors.text
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                hoverEnabled: true
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton)
                        modelData.onlyMenu ? modelData.display(root.parentWindow, 0, parent.height) : modelData.activate();
                    else if (mouse.button === Qt.MiddleButton)
                        modelData.secondaryActivate();
                    else if (modelData.hasMenu)
                        modelData.display(root.parentWindow, 0, parent.height);
                }
            }

        }

    }

}
