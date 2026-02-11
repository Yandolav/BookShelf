import Foundation

enum LibraryError: Error, LocalizedError {
    case emptyTitle
    case emptyAuthor
    case invalidYear(Int)
    case invalidYearFormat(String)
    case invalidGenre(String)
    case notFound(id: UUID)
    case duplicateId(UUID)
    case invalidUUID(String)

    var errorDescription: String? {
        switch self {
        case .emptyTitle: return "Название не может быть пустым"
        case .emptyAuthor: return "Автор не может быть пустым"
        case .invalidYear(let y): return "Некорректный год: \(y)"
        case .invalidYearFormat(let raw): return "Год должен быть числом: \"\(raw)\""
        case .invalidGenre(let raw): return "Некорректный жанр: \"\(raw)\""
        case .notFound(let id): return "Книга с id \(id) не найдена"
        case .duplicateId(let id): return "Книга с id \(id) уже существует"
        case .invalidUUID(let id): return "Неккоректный id: \(id)"
        }
    }
}

