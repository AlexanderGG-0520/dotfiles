import QtQuick
import Quickshell.Services.Pipewire
import "../services" as Services

QtObject {
    id: root
    property var sink: Pipewire.defaultAudioSink
    property var source: Pipewire.defaultAudioSource
    property bool ready: false
    property real sinkVolume: 0
    property bool sinkMuted: false
    property real sourceVolume: 0
    property bool sourceMuted: false
    signal outputChanged(real volume, bool muted)
    signal microphoneChanged(real volume, bool muted)

    // OSD and the Control Center observe the same default PipeWire nodes.
    property var nodeTracker: PwObjectTracker {
        objects: [root.sink, root.source].filter((node) => node)
    }

    function synchronize() {
        sink = Pipewire.defaultAudioSink
        source = Pipewire.defaultAudioSource
        if (!Pipewire.ready)
            return
        if (sink && sink.audio) {
            sinkVolume = sink.audio.volume
            sinkMuted = sink.audio.muted
        }
        if (source && source.audio) {
            sourceVolume = source.audio.volume
            sourceMuted = source.audio.muted
        }
        ready = true
    }

    function emitOutput() {
        Services.PopupState.osdScreen = Services.PopupState.focusedScreen()
        outputChanged(sink.audio.volume, sink.audio.muted)
    }
    function emitMicrophone() {
        Services.PopupState.osdScreen = Services.PopupState.focusedScreen()
        microphoneChanged(source.audio.volume, source.audio.muted)
    }

    Component.onCompleted: synchronize()
    property var pipewireConnections: Connections {
        target: Pipewire
        function onReadyChanged() { root.synchronize() }
        function onDefaultAudioSinkChanged() { root.ready = false; root.synchronize() }
        function onDefaultAudioSourceChanged() { root.ready = false; root.synchronize() }
    }
    property var sinkConnections: Connections {
        target: root.sink ? root.sink.audio : null
        function onVolumesChanged() { if (!root.ready) root.synchronize(); else root.emitOutput() }
        function onMutedChanged() { if (!root.ready) root.synchronize(); else root.emitOutput() }
    }
    property var sourceConnections: Connections {
        target: root.source ? root.source.audio : null
        function onVolumesChanged() { if (!root.ready) root.synchronize(); else root.emitMicrophone() }
        function onMutedChanged() { if (!root.ready) root.synchronize(); else root.emitMicrophone() }
    }
}
