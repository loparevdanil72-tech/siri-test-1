import SwiftUI
import AppIntents

struct SiriGuideView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Как использовать Siri") {
                    Text("Просто скажи фразы ниже — они работают сразу, без настройки!")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                siriCommandsSection(
                    title: "Навигация",
                    icon: "square.grid.2x2",
                    commands: [
                        ("Открой Notes в SiriApp", "Переходит к разделу заметок"),
                        ("Открой Reminders в SiriApp", "Переходит к напоминаниям"),
                        ("Открой Camera в SiriApp", "Переходит к камере"),
                    ]
                )

                siriCommandsSection(
                    title: "Заметки",
                    icon: "note.text",
                    commands: [
                        ("Добавь заметку в SiriApp", "Создаёт новую заметку"),
                        ("Сколько заметок в SiriApp", "Говорит количество заметок"),
                    ]
                )

                siriCommandsSection(
                    title: "Напоминания",
                    icon: "checklist",
                    commands: [
                        ("Напомни мне в SiriApp", "Создаёт напоминание"),
                        ("Сколько напоминаний в SiriApp", "Говорит количество"),
                    ]
                )

                siriCommandsSection(
                    title: "Поиск",
                    icon: "magnifyingglass",
                    commands: [
                        ("Найди покупки в SiriApp", "Ищет по заметкам и напоминаниям"),
                        ("Search ideas in SiriApp", "Works in English too"),
                    ]
                )

                Section("Добавить в Shortcuts") {
                    SiriShortcutButtonsView()
                }
            }
            .navigationTitle("Siri Integration")
        }
    }

    private func siriCommandsSection(title: String, icon: String, commands: [(String, String)]) -> some View {
        Section {
            ForEach(commands, id: \.0) { command, description in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "mic.fill")
                            .foregroundStyle(.purple)
                            .font(.caption)
                        Text("«\(command)»")
                            .font(.subheadline.bold())
                    }
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
        } header: {
            Label(title, systemImage: icon)
        }
    }
}

// Buttons that open the "Add to Siri" sheet for each shortcut
private struct SiriShortcutButtonsView: View {
    var body: some View {
        VStack(spacing: 8) {
            shortcutRow(intent: AddNoteIntent(),      label: "Add Note to Siri",     icon: "note.text.badge.plus")
            shortcutRow(intent: AddReminderIntent(),  label: "Add Reminder to Siri", icon: "checklist.checked")
            shortcutRow(intent: SearchIntent(),       label: "Search to Siri",       icon: "magnifyingglass")
        }
    }

    @ViewBuilder
    private func shortcutRow(intent: some AppIntent, label: String, icon: String) -> some View {
        HStack {
            Label(label, systemImage: icon)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .contentShape(Rectangle())
    }
}
