import SwiftUI

struct SearchView: View {
    @StateObject private var store = AppStore.shared
    @State private var query = ""

    private var results: [String] {
        query.isEmpty ? [] : store.search(query: query)
    }

    var body: some View {
        NavigationStack {
            List {
                if results.isEmpty && !query.isEmpty {
                    ContentUnavailableView.search(text: query)
                } else {
                    ForEach(results, id: \.self) { result in
                        Label(result, systemImage: result.hasPrefix("Заметка") ? "note.text" : "checklist")
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}
