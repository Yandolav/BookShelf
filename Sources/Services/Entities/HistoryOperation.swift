import Foundation

enum HistoryItem: CustomStringConvertible {
    case add(Book, Date)
    case delete(Book, Date)
    case update(old: Book, new: Book, Date)
    
    var description: String {
        switch self {
        case .add(let book, let date):
            return "Добавлена книга: \"\(book.title)\" (\(formatDate(date)))"
            
        case .delete(let book, let date):
            return "Удалена книга: \"\(book.title)\" (\(formatDate(date)))"
            
        case .update(let oldBook, let newBook, let date):
            return """
            Изменена книга:
            Было: \(oldBook)
            Стало: \(newBook)
            Время: \(formatDate(date))
            """
        }
    }

    var time: Date {
        switch self {
        case .add(_, let date):
            return date
            
        case .delete(_, let date):
            return date
            
        case .update(_, _, let date):
            return date
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: date)
    }
}
