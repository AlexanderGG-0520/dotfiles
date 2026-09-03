import QtQuick
import Quickshell.Services.Notifications

QtObject {
    id: root
    // History is presentation-only. It deliberately never owns a native
    // Notification, because closed() destroys that object after its handlers.
    property var history: []
    // Popup records are also presentation-only and exist independently of history.
    property var popups: []
    // This is the sole owner of live native Notification references.
    property var liveNotifications: []
    readonly property int historyLimit: 80
    // D-Bus uses -1 for the server default and 0 for "never expire". The
    // default is applied only to -1, never to a client-supplied timeout.
    readonly property int defaultExpireTimeout: 6500
    property int nextKey: 1

    function snapshot(notification, key) {
        const actions = []
        const nativeActions = notification.actions || []
        for (let index = 0; index < nativeActions.length; index++)
            actions.push({ text: nativeActions[index].text || "" })

        return {
            key: key,
            appName: notification.appName || notification.desktopEntry || "Notification",
            appIcon: notification.appIcon || "",
            image: notification.image || "",
            summary: notification.summary || "",
            body: notification.body || "",
            urgency: notification.urgency,
            actions: actions,
            resident: notification.resident,
            transient: notification.transient,
            // Quickshell 0.3.1 carries the D-Bus expire_timeout value through;
            // Timer.interval uses those milliseconds directly.
            expireTimeout: notification.expireTimeout,
            created: Date.now()
        }
    }

    function liveFor(key) {
        return liveNotifications.find(entry => entry.key === key)
    }

    function isLive(key) { return liveFor(key) !== undefined }

    function popupExpiryMillis(record) {
        if (record.expireTimeout > 0) return record.expireTimeout
        if (record.expireTimeout < 0) return defaultExpireTimeout
        return 0
    }

    function receive(notification) {
        // NotificationServer.notification objects are discarded unless tracked.
        notification.tracked = true
        const key = nextKey++
        const record = snapshot(notification, key)
        liveNotifications = liveNotifications.concat([{ key: key, notification: notification }])
        popups = [record].concat(popups).slice(0, 3)
        // Transient notifications must not enter persistent notification history.
        if (!record.transient)
            history = [record].concat(history).slice(0, historyLimit)

        // This runs before Quickshell destroys the native object. Do not retain
        // it in history or popup data after this handler returns.
        notification.closed.connect(reason => root.nativeClosed(key, reason))
    }

    function nativeClosed(key, reason) {
        popups = popups.filter(record => record.key !== key)
        liveNotifications = liveNotifications.filter(entry => entry.key !== key)
    }

    function dismiss(key) {
        const live = liveFor(key)
        if (live) live.notification.dismiss()
        // Explicit user dismissal also removes the corresponding history item.
        history = history.filter(record => record.key !== key)
    }

    function expire(key) {
        const live = liveFor(key)
        // Do not hide the popup first: closed() is the lifecycle boundary.
        if (live) live.notification.expire()
    }

    function invokeAction(key, actionIndex) {
        const live = liveFor(key)
        if (!live) return
        const action = live.notification.actions[actionIndex]
        if (action) action.invoke()
    }

    function clearAll() {
        const live = liveNotifications.slice()
        history = []
        live.forEach(entry => entry.notification.dismiss())
    }

    property var server: NotificationServer {
        id: server
        keepOnReload: true
        persistenceSupported: true
        actionsSupported: true
        imageSupported: true
        bodyMarkupSupported: true
        onNotification: notification => root.receive(notification)
    }
}
