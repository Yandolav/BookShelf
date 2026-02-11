protocol BookRepositoryProtocol {
    func load() -> [Book]
    func save(_ books: [Book])
}

final class BookRepository: BookRepositoryProtocol {

    // MARK: Private properties

    private let storage: StorageProtocol

    // MARK: Init

    init(storage: StorageProtocol) {
        self.storage = storage
    }

    // MARK: Public methods

    func load() -> [Book] {
        storage.getBooks()
    }

    func save(_ books: [Book]) {
        storage.saveBooks(books)
    }
}

