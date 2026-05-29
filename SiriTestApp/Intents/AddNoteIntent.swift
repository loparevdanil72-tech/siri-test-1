import AppIntents

// Siri: "Add note [title] to SiriApp"
// Siri: "Create note in SiriApp"
struct AddNoteIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Note"
    static var description = IntentDescription("Adds a new note to SiriApp.")

    @Parameter(title: "Title", description: "Note title")
    var title: String

    @Parameter(title: "Content", description: "Note content", default: "")
    var body: String

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        AppStore.shared.addNote(title: title, body: body)
        return .result(dialog: "Заметка «\(title)» добавлена.")
    }
}

// Siri: "Add reminder [title] to SiriApp"
struct AddReminderIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Reminder"
    static var description = IntentDescription("Adds a new reminder to SiriApp.")

    @Parameter(title: "Title", description: "Reminder title")
    var title: String

    @Parameter(title: "Due Date", description: "When to remind you")
    var dueDate: Date?

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        AppStore.shared.addReminder(title: title, dueDate: dueDate)
        let dueDateText = dueDate.map { ", срок: \(DateFormatter.localizedString(from: $0, dateStyle: .short, timeStyle: .short))" } ?? ""
        return .result(dialog: "Напоминание «\(title)» создано\(dueDateText).")
    }
}
