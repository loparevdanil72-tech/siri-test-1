import Foundation
import AppIntents

enum AppSection: String, CaseIterable, AppEnum {
    case notes     = "notes"
    case reminders = "reminders"
    case search    = "search"
    case settings  = "settings"
    case camera    = "camera"
    case music     = "music"
    case weather   = "weather"
    case maps      = "maps"

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "App Section")
    }

    static var caseDisplayRepresentations: [AppSection: DisplayRepresentation] {
        [
            .notes:     DisplayRepresentation(title: "Notes",     image: .init(systemName: "note.text")),
            .reminders: DisplayRepresentation(title: "Reminders", image: .init(systemName: "checklist")),
            .search:    DisplayRepresentation(title: "Search",    image: .init(systemName: "magnifyingglass")),
            .settings:  DisplayRepresentation(title: "Settings",  image: .init(systemName: "gearshape")),
            .camera:    DisplayRepresentation(title: "Camera",    image: .init(systemName: "camera")),
            .music:     DisplayRepresentation(title: "Music",     image: .init(systemName: "music.note")),
            .weather:   DisplayRepresentation(title: "Weather",   image: .init(systemName: "cloud.sun")),
            .maps:      DisplayRepresentation(title: "Maps",      image: .init(systemName: "map")),
        ]
    }
}

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var body: String
    var createdAt: Date = .now
}

struct Reminder: Identifiable {
    let id = UUID()
    var title: String
    var dueDate: Date?
    var isCompleted: Bool = false
}

// Shared in-memory store for demo purposes
final class AppStore: ObservableObject {
    static let shared = AppStore()

    @Published var notes: [Note] = [
        Note(title: "Покупки", body: "Молоко, хлеб, яблоки"),
        Note(title: "Идеи", body: "Интеграция Siri с приложениями"),
    ]

    @Published var reminders: [Reminder] = [
        Reminder(title: "Позвонить маме", dueDate: Calendar.current.date(byAdding: .hour, value: 2, to: .now)),
        Reminder(title: "Купить продукты"),
    ]

    @Published var currentSection: AppSection = .notes

    func addNote(title: String, body: String) {
        notes.insert(Note(title: title, body: body), at: 0)
    }

    func addReminder(title: String, dueDate: Date? = nil) {
        reminders.insert(Reminder(title: title, dueDate: dueDate), at: 0)
    }

    func search(query: String) -> [String] {
        let noteResults = notes
            .filter { $0.title.localizedCaseInsensitiveContains(query) || $0.body.localizedCaseInsensitiveContains(query) }
            .map { "Заметка: \($0.title)" }
        let reminderResults = reminders
            .filter { $0.title.localizedCaseInsensitiveContains(query) }
            .map { "Напоминание: \($0.title)" }
        return noteResults + reminderResults
    }
}
