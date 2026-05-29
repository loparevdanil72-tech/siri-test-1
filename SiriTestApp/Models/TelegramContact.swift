import Foundation
import AppIntents

struct TelegramContact: Codable, Identifiable {
    var id: Int64       // Telegram chat_id
    var name: String
    var username: String?
}

// Wraps TelegramContact as an AppEntity so Siri can resolve names by voice
struct TelegramContactEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Telegram Contact"
    static var defaultQuery = TelegramContactQuery()

    var id: Int64
    var name: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
    }
}

struct TelegramContactQuery: EntityQuery {
    func entities(for identifiers: [Int64]) async throws -> [TelegramContactEntity] {
        ContactStore.shared.contacts
            .filter { identifiers.contains($0.id) }
            .map { TelegramContactEntity(id: $0.id, name: $0.name) }
    }

    func suggestedEntities() async throws -> [TelegramContactEntity] {
        ContactStore.shared.contacts
            .map { TelegramContactEntity(id: $0.id, name: $0.name) }
    }
}

final class ContactStore: ObservableObject {
    static let shared = ContactStore()

    @Published var contacts: [TelegramContact] = [] {
        didSet { saveContacts() }
    }

    @Published var botToken: String = "" {
        didSet { UserDefaults.standard.set(botToken, forKey: "tg_bot_token") }
    }

    private init() {
        botToken = UserDefaults.standard.string(forKey: "tg_bot_token") ?? ""
        if let data = UserDefaults.standard.data(forKey: "tg_contacts"),
           let decoded = try? JSONDecoder().decode([TelegramContact].self, from: data) {
            contacts = decoded
        }
    }

    func add(name: String, chatId: Int64, username: String? = nil) {
        contacts.append(TelegramContact(id: chatId, name: name, username: username))
    }

    func delete(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }

    private func saveContacts() {
        if let data = try? JSONEncoder().encode(contacts) {
            UserDefaults.standard.set(data, forKey: "tg_contacts")
        }
    }
}
