import SwiftUI

struct TelegramSetupView: View {
    @StateObject private var store = ContactStore.shared
    @State private var showingAddContact = false
    @State private var showingScanner = false
    @State private var scanResult: [TelegramUpdate] = []
    @State private var scanError: String?
    @State private var isScanning = false

    var body: some View {
        NavigationStack {
            List {
                botTokenSection
                contactsSection
                scanSection
                howToSection
            }
            .navigationTitle("Telegram Setup")
            .sheet(isPresented: $showingAddContact) {
                AddContactSheet()
            }
        }
    }

    // MARK: — Bot Token

    private var botTokenSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                SecureField("Вставь токен бота сюда…", text: $store.botToken)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                if !store.botToken.isEmpty {
                    Label("Токен сохранён", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                }
            }
        } header: {
            Label("Bot Token", systemImage: "key.fill")
        } footer: {
            Text("Получи токен у @BotFather в Telegram → /newbot")
        }
    }

    // MARK: — Contacts

    private var contactsSection: some View {
        Section {
            ForEach(store.contacts) { contact in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(contact.name).font(.headline)
                        Group {
                            if let username = contact.username {
                                Text("@\(username)")
                            } else {
                                Text("chat_id: \(contact.id)")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.blue)
                        .font(.caption)
                }
            }
            .onDelete { offsets in store.delete(at: offsets) }

            Button {
                showingAddContact = true
            } label: {
                Label("Добавить контакт", systemImage: "plus.circle.fill")
            }
        } header: {
            Label("Контакты", systemImage: "person.2.fill")
        } footer: {
            Text("Каждый контакт нужно добавить вручную с его chat_id. Используй сканер ниже чтобы его узнать.")
        }
    }

    // MARK: — Scanner (auto-discover chat_ids)

    private var scanSection: some View {
        Section {
            Button {
                Task { await scanUpdates() }
            } label: {
                HStack {
                    Label("Сканировать новые сообщения боту", systemImage: "antenna.radiowaves.left.and.right")
                    Spacer()
                    if isScanning {
                        ProgressView().scaleEffect(0.8)
                    }
                }
            }
            .disabled(store.botToken.isEmpty || isScanning)

            if let error = scanError {
                Label(error, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            ForEach(scanResult, id: \.updateId) { update in
                if let msg = update.message {
                    DiscoveredContactRow(message: msg) {
                        let name = msg.from?.firstName ?? msg.chat.firstName ?? "Unknown"
                        store.add(
                            name: name,
                            chatId: msg.chat.id,
                            username: msg.from?.username ?? msg.chat.username
                        )
                        scanResult.removeAll { $0.updateId == update.updateId }
                    }
                }
            }
        } header: {
            Label("Авто-поиск chat_id", systemImage: "radar")
        } footer: {
            Text("Попроси человека написать любое сообщение боту — потом нажми «Сканировать» и добавь его одним тапом.")
        }
    }

    // MARK: — How to

    private var howToSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                step("1", text: "Создай бота: напиши @BotFather → /newbot")
                step("2", text: "Скопируй токен и вставь выше")
                step("3", text: "Каждый контакт должен написать боту любое сообщение")
                step("4", text: "Нажми «Сканировать» и добавь контакт")
                step("5", text: "Скажи Siri: «Отправь сообщение Васе в Telegram»")
            }
            .padding(.vertical, 4)
        } header: {
            Label("Как настроить", systemImage: "info.circle")
        }
    }

    private func step(_ number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(number)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(.blue, in: Circle())
            Text(text).font(.subheadline)
        }
    }

    // MARK: — Scan action

    private func scanUpdates() async {
        isScanning = true
        scanError = nil
        do {
            let updates = try await TelegramService.shared.getUpdates(token: store.botToken)
            let known = Set(store.contacts.map(\.id))
            scanResult = updates.filter { upd in
                guard let chat = upd.message?.chat else { return false }
                return !known.contains(chat.id)
            }
            if scanResult.isEmpty {
                scanError = "Новых контактов не найдено. Попроси кого-нибудь написать боту."
            }
        } catch {
            scanError = error.localizedDescription
        }
        isScanning = false
    }
}

// MARK: — Subviews

private struct DiscoveredContactRow: View {
    let message: TelegramMessage
    let onAdd: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(message.from?.firstName ?? message.chat.firstName ?? "Unknown")
                    .font(.headline)
                if let username = message.from?.username ?? message.chat.username {
                    Text("@\(username)").font(.caption).foregroundStyle(.secondary)
                }
                Text("chat_id: \(message.chat.id)").font(.caption2).foregroundStyle(.tertiary)
            }
            Spacer()
            Button("Добавить", action: onAdd)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
        }
    }
}

private struct AddContactSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = ContactStore.shared
    @State private var name = ""
    @State private var chatIdText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Имя контакта") {
                    TextField("Например: Вася", text: $name)
                }
                Section("chat_id") {
                    TextField("Например: 123456789", text: $chatIdText)
                        .keyboardType(.numbersAndPunctuation)
                }
            }
            .navigationTitle("Новый контакт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        if let chatId = Int64(chatIdText), !name.isEmpty {
                            store.add(name: name, chatId: chatId)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty || Int64(chatIdText) == nil)
                }
            }
        }
    }
}
