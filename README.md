# SiriApp — Siri Integration Demo

iOS-приложение, демонстрирующее полную интеграцию с Siri через **App Intents** (iOS 16+).

## Что умеет

| Фраза Siri | Действие |
|---|---|
| «Открой Notes в SiriApp» | Открывает раздел заметок |
| «Добавь заметку в SiriApp» | Создаёт новую заметку |
| «Напомни мне в SiriApp» | Добавляет напоминание |
| «Найди [запрос] в SiriApp» | Ищет по заметкам и напоминаниям |
| «Сколько заметок в SiriApp» | Siri голосом ответит на вопрос |
| «Search [query] in SiriApp» | Работает и по-английски |

Все фразы работают **сразу без настройки** — через `AppShortcutsProvider`.

## Архитектура

```
SiriTestApp/
├── App/
│   └── SiriTestAppApp.swift       # @main, точка входа
├── Intents/
│   ├── OpenSectionIntent.swift    # Открыть раздел
│   ├── AddNoteIntent.swift        # Добавить заметку / напоминание
│   ├── SearchIntent.swift         # Поиск, подсчёт заметок/напоминаний
│   └── AppShortcuts.swift         # Регистрация фраз Siri
├── Models/
│   └── AppSection.swift           # Модели + AppStore
└── Views/
    ├── ContentView.swift           # Tab bar
    ├── NotesView.swift
    ├── RemindersView.swift
    ├── SearchView.swift
    └── SiriGuideView.swift         # Интерактивный гайд по командам
```

## Запуск

### Требования
- Xcode 15+
- iOS 16+ (симулятор или реальный iPhone/iPad)
- Apple Developer аккаунт (для тестирования Siri на реальном устройстве)

### Вариант 1 — XcodeGen (рекомендуется)
```bash
brew install xcodegen
xcodegen generate          # создаёт SiriTestApp.xcodeproj
open SiriTestApp.xcodeproj
```
Установи свой **Team ID** в `project.yml` или прямо в настройках таргета в Xcode.

### Вариант 2 — вручную
1. Открой Xcode → File → New → Project → App
2. Добавь все файлы из `SiriTestApp/` в проект
3. Убедись, что `AppIntents` framework подключён (добавляется автоматически при импорте)

## Как работает App Intents

Каждый `AppIntent` — это `struct`, соответствующий протоколу `AppIntent`:

```swift
struct AddNoteIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Note"

    @Parameter(title: "Title")
    var title: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        AppStore.shared.addNote(title: title, body: "")
        return .result(dialog: "Заметка «\(title)» добавлена.")
    }
}
```

`AppShortcutsProvider` регистрирует фразы, которые Siri понимает без обучения:

```swift
AppShortcut(
    intent: AddNoteIntent(),
    phrases: ["Добавь заметку в SiriApp", "Add note in SiriApp"],
    shortTitle: "Add Note",
    systemImageName: "note.text.badge.plus"
)
```

## Добавление новых команд

1. Создай новый файл в `Intents/`, реализуй `AppIntent`
2. Добавь `AppShortcut` в `AppShortcuts.swift`
3. Вызови `SiriTestAppShortcuts.updateAppShortcutParameters()` при старте — Siri автоматически подхватит новые фразы

## Отличие от старого SiriKit

| | Старый SiriKit (iOS 12) | App Intents (iOS 16+) |
|---|---|---|
| Реализация | Отдельный Extension target | Код в основном таргете |
| Конфигурация | `.intentdefinition` XML | Swift structs |
| Фразы | Пользователь настраивает вручную | Работают из коробки |
| Типы | Фиксированные домены | Любые кастомные действия |
