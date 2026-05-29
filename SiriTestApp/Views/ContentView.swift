import SwiftUI
import AppIntents

struct ContentView: View {
    @StateObject private var store = AppStore.shared

    var body: some View {
        TabView(selection: $store.currentSection) {
            NotesView()
                .tabItem { Label("Notes", systemImage: "note.text") }
                .tag(AppSection.notes)

            RemindersView()
                .tabItem { Label("Reminders", systemImage: "checklist") }
                .tag(AppSection.reminders)

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(AppSection.search)

            SiriGuideView()
                .tabItem { Label("Siri", systemImage: "waveform") }
                .tag(AppSection.settings)
        }
        .onAppear {
            // Donate shortcuts so Siri learns about this app
            SiriTestAppShortcuts.updateAppShortcutParameters()
        }
    }
}
