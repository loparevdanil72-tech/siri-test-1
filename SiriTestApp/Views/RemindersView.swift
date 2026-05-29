import SwiftUI

struct RemindersView: View {
    @StateObject private var store = AppStore.shared
    @State private var showingAdd = false
    @State private var newTitle = ""
    @State private var newDate: Date = .now
    @State private var setDate = false

    var body: some View {
        NavigationStack {
            List {
                ForEach($store.reminders) { $reminder in
                    HStack {
                        Button {
                            reminder.isCompleted.toggle()
                        } label: {
                            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(reminder.isCompleted ? .green : .secondary)
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(reminder.title)
                                .strikethrough(reminder.isCompleted)
                                .foregroundStyle(reminder.isCompleted ? .secondary : .primary)
                            if let due = reminder.dueDate {
                                Text(due, style: .relative)
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }
                .onDelete { offsets in
                    store.reminders.remove(atOffsets: offsets)
                }
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                addReminderSheet
            }
        }
    }

    private var addReminderSheet: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Reminder title", text: $newTitle)
                }
                Section {
                    Toggle("Set due date", isOn: $setDate)
                    if setDate {
                        DatePicker("Due", selection: $newDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAdd = false
                        newTitle = ""
                        setDate = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !newTitle.isEmpty else { return }
                        store.addReminder(title: newTitle, dueDate: setDate ? newDate : nil)
                        showingAdd = false
                        newTitle = ""
                        setDate = false
                    }
                    .disabled(newTitle.isEmpty)
                }
            }
        }
    }
}
