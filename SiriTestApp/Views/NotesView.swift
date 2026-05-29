import SwiftUI

struct NotesView: View {
    @StateObject private var store = AppStore.shared
    @State private var showingAdd = false
    @State private var newTitle = ""
    @State private var newBody = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.notes) { note in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title).font(.headline)
                        Text(note.body).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { offsets in
                    store.notes.remove(atOffsets: offsets)
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                addNoteSheet
            }
        }
    }

    private var addNoteSheet: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Note title", text: $newTitle)
                }
                Section("Content") {
                    TextEditor(text: $newBody)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAdd = false
                        newTitle = ""
                        newBody = ""
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !newTitle.isEmpty else { return }
                        store.addNote(title: newTitle, body: newBody)
                        showingAdd = false
                        newTitle = ""
                        newBody = ""
                    }
                    .disabled(newTitle.isEmpty)
                }
            }
        }
    }
}
