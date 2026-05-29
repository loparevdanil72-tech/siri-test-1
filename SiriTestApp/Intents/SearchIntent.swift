import AppIntents

// Siri: "Search [query] in SiriApp"
// Siri: "Find [query] in SiriApp"
struct SearchIntent: AppIntent {
    static var title: LocalizedStringResource = "Search in SiriApp"
    static var description = IntentDescription("Searches notes and reminders in SiriApp.")

    static var openAppWhenRun: Bool = true

    @Parameter(title: "Search Query")
    var query: String

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let results = AppStore.shared.search(query: query)
        if results.isEmpty {
            return .result(dialog: "Ничего не найдено по запросу «\(query)».")
        }
        let summary = results.prefix(3).joined(separator: ", ")
        let more = results.count > 3 ? " и ещё \(results.count - 3)" : ""
        return .result(dialog: "Найдено: \(summary)\(more).")
    }
}

// Siri: "What's in my notes in SiriApp?"
struct GetNotesCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Notes Count"
    static var description = IntentDescription("Returns how many notes you have in SiriApp.")

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let count = AppStore.shared.notes.count
        return .result(dialog: "У тебя \(count) заметок в SiriApp.")
    }
}

// Siri: "How many reminders do I have in SiriApp?"
struct GetRemindersCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Reminders Count"
    static var description = IntentDescription("Returns how many reminders you have in SiriApp.")

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let pending = AppStore.shared.reminders.filter { !$0.isCompleted }.count
        return .result(dialog: "У тебя \(pending) активных напоминаний в SiriApp.")
    }
}
