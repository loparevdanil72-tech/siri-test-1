import Foundation

enum TelegramError: LocalizedError {
    case noBotToken
    case contactNotFound
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .noBotToken:            return "Bot token не настроен. Открой вкладку Telegram в приложении."
        case .contactNotFound:       return "Контакт не найден. Добавь его в приложении."
        case .apiError(let message): return "Ошибка Telegram API: \(message)"
        }
    }
}

struct TelegramUpdate: Decodable {
    let updateId: Int
    let message: TelegramMessage?

    enum CodingKeys: String, CodingKey {
        case updateId = "update_id"
        case message
    }
}

struct TelegramMessage: Decodable {
    let messageId: Int
    let from: TelegramUser?
    let chat: TelegramChat
    let text: String?

    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case from, chat, text
    }
}

struct TelegramUser: Decodable {
    let id: Int64
    let firstName: String
    let username: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case username
    }
}

struct TelegramChat: Decodable {
    let id: Int64
    let firstName: String?
    let username: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case username
    }
}

private struct UpdatesResponse: Decodable {
    let ok: Bool
    let result: [TelegramUpdate]
}

private struct SendResponse: Decodable {
    let ok: Bool
    let description: String?
}

struct TelegramService {
    static let shared = TelegramService()
    private init() {}

    func sendMessage(chatId: Int64, text: String, token: String) async throws {
        let url = URL(string: "https://api.telegram.org/bot\(token)/sendMessage")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "chat_id": chatId,
            "text": text,
        ])

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SendResponse.self, from: data)
        if !response.ok {
            throw TelegramError.apiError(response.description ?? "unknown error")
        }
    }

    // Fetches recent messages to the bot — used to discover chat_ids
    func getUpdates(token: String) async throws -> [TelegramUpdate] {
        let url = URL(string: "https://api.telegram.org/bot\(token)/getUpdates")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(UpdatesResponse.self, from: data)
        if !response.ok { throw TelegramError.apiError("getUpdates failed") }
        return response.result
    }
}
