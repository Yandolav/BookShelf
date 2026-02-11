protocol MainScreenPresenterProtocol: AnyObject {
    func printBooks(printStyle: PrintStyle)
    func printHistory()
}

class MainScreenPresenter: MainScreenPresenterProtocol {

    // MARK: Private properties

    private let bookService: BookShelfServiceProtocol
    private let historyService: HistoryServiceProtocol

    // MARK: Init

    init(bookService: BookShelfServiceProtocol, historyService: HistoryServiceProtocol) {
        self.bookService = bookService
        self.historyService = historyService
    }

    // MARK: Public methods

    func printBooks(printStyle: PrintStyle) {
        let books = bookService.list()
        guard books.count != 0 else {
            print(Constants.notFoundBook)
            return
        }
        print("Книги:")
        switch printStyle {
        case .ordinary:
            for book in books {
                print(book)
            }
        case .byAuthor:
            for book in books.sorted(by: { $0.author < $1.author }) {
                print(book)
            }
        case .byTitle:
            for book in books.sorted(by: { $0.title < $1.title }) {
                print(book)
            }
        case .byDate:
            for book in books.sorted(by: { $0.publicationYear ?? Int.max < $1.publicationYear ?? Int.max }) {
                print(book)
            }
        case .noDate:
            for book in books.filter({ $0.publicationYear == nil }) {
                print(book)
            }
        }
    }

    func printHistory() {
        let history = historyService.getHistoryItems()
        guard history.count != 0 else {
            print(Constants.notFoundHistory)
            return
        }

        for historyItem in history {
            print(historyItem)
        }
    }
}

// MARK: - Constants

private extension MainScreenPresenter {
    enum Constants {
        static let notFoundBook = "Книг нет :("
        static let notFoundHistory = "История пуста :("
    }
}
