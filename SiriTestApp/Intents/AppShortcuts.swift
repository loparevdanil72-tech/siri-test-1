import AppIntents

// AppShortcutsProvider registers pre-built Siri phrases that work
// immediately, without the user having to add them in Shortcuts app.
// These phrases appear in Siri Suggestions and Spotlight search.
struct SiriTestAppShortcuts: AppShortcutsProvider {
    // Accent colour shown in Shortcuts app
    static var shortcutTileColor: ShortcutTileColor = .blue

    static var appShortcuts: [AppShortcut] {
        // Open a section
        AppShortcut(
            intent: OpenSectionIntent(),
            phrases: [
                "Открой \(\.$section) в SiriApp",
                "Перейди к \(\.$section) в SiriApp",
                "Open \(\.$section) in SiriApp",
            ],
            shortTitle: "Open Section",
            systemImageName: "square.grid.2x2"
        )

        // Add a note
        AppShortcut(
            intent: AddNoteIntent(),
            phrases: [
                "Добавь заметку в SiriApp",
                "Создай заметку в SiriApp",
                "Add note in SiriApp",
                "New note in SiriApp",
            ],
            shortTitle: "Add Note",
            systemImageName: "note.text.badge.plus"
        )

        // Add a reminder
        AppShortcut(
            intent: AddReminderIntent(),
            phrases: [
                "Напомни мне в SiriApp",
                "Добавь напоминание в SiriApp",
                "Add reminder in SiriApp",
                "Remind me in SiriApp",
            ],
            shortTitle: "Add Reminder",
            systemImageName: "checklist.checked"
        )

        // Search
        AppShortcut(
            intent: SearchIntent(),
            phrases: [
                "Найди \(\.$query) в SiriApp",
                "Поищи \(\.$query) в SiriApp",
                "Search \(\.$query) in SiriApp",
                "Find \(\.$query) in SiriApp",
            ],
            shortTitle: "Search",
            systemImageName: "magnifyingglass"
        )

        // Count notes
        AppShortcut(
            intent: GetNotesCountIntent(),
            phrases: [
                "Сколько заметок в SiriApp",
                "Мои заметки в SiriApp",
                "How many notes in SiriApp",
            ],
            shortTitle: "Note Count",
            systemImageName: "note.text"
        )

        // Count reminders
        AppShortcut(
            intent: GetRemindersCountIntent(),
            phrases: [
                "Сколько напоминаний в SiriApp",
                "Мои напоминания в SiriApp",
                "How many reminders in SiriApp",
            ],
            shortTitle: "Reminder Count",
            systemImageName: "checklist"
        )

        // Send Telegram message — main feature
        AppShortcut(
            intent: SendTelegramMessageIntent(),
            phrases: [
                "Отправь сообщение \(\.$contact) в Telegram",
                "Напиши \(\.$contact) в Telegram",
                "Send Telegram message to \(\.$contact)",
                "Message \(\.$contact) in Telegram",
            ],
            shortTitle: "Send Telegram",
            systemImageName: "paperplane.fill"
        )
    }
}
