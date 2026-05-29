import AppIntents
import SwiftUI

// Siri: "Open Notes in SiriApp"
// Siri: "Open Camera in SiriApp"
struct OpenSectionIntent: AppIntent {
    static var title: LocalizedStringResource = "Open App Section"
    static var description = IntentDescription("Opens a specific section of SiriApp.")

    static var openAppWhenRun: Bool = true

    @Parameter(title: "Section", description: "Which section to open")
    var section: AppSection

    @MainActor
    func perform() async throws -> some IntentResult {
        AppStore.shared.currentSection = section
        return .result()
    }
}

// Siri: "Open SiriApp"
struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Open SiriApp"
    static var description = IntentDescription("Opens SiriApp.")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
