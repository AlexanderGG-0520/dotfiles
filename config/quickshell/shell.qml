import Quickshell
import "bars"
import "notifications" as Notifications
import "services" as Services

ShellRoot {
    Notifications.NotificationService { id: notificationService }
    Services.AudioOsdState { id: audioOsdState }
    Phase2Surfaces { notificationService: notificationService; audioState: audioOsdState }
    // One lifecycle-managed surface for every connected ShellScreen.
    Variants {
        // Quickshell owns screen lifecycle; this model creates and removes one
        // PanelWindow for each connected screen without connector assumptions.
        model: Quickshell.screens

        TopBar {
            required property var modelData
            targetScreen: modelData
        }
    }
}
