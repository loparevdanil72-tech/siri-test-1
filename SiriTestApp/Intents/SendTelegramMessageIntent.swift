import AppIntents

// Siri: «Отправь сообщение Васе в Telegram»
// Siri: «Send Telegram message to Vasya»
struct SendTelegramMessageIntent: AppIntent {
    static var title: LocalizedStringResource = "Send Telegram Message"
    static var description = IntentDescription(
        "Sends a Telegram message to a contact without opening the app.",
        categoryName: "Messaging"
    )

    @Parameter(title: "Contact", description: "Who to send the message to")
    var contact: TelegramContactEntity

    @Parameter(title: "Message", description: "Text of the message")
    var message: String

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let token = ContactStore.shared.botToken
        guard !token.isEmpty else { throw TelegramError.noBotToken }

        try await TelegramService.shared.sendMessage(
            chatId: contact.id,
            text: message,
            token: token
        )
        return .result(dialog: "Сообщение отправлено \(contact.name).")
    }
}
