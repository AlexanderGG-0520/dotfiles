import QtQuick
pragma Singleton

QtObject {
    // fc-match exposes the installed CJK face as this family with Black style.
    readonly property string uiFamily: "Noto Sans CJK JP"
    readonly property int uiWeight: Font.Black
    // SF Mono is not installed on this host; keep the shell legible with its
    // available monospace fallback. Ghostty remains untouched.
    readonly property string monoFamily: "SF Mono"
    readonly property int titleSize: 14
    readonly property int bodySize: 12
    readonly property int captionSize: 11
    readonly property int metadataSize: 10
    readonly property int clockSize: 14
}
