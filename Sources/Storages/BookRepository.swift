protocol BookRepositoryProtocol {
    func load() -> [Book]
    func save(_ books: [Book])
}

final class BookRepository: BookRepositoryProtocol {

    // MARK: Private properties

    private let storage: CodableStorageProtocol
    private let fileName = "books.json"

    // MARK: Init

    init(storage: CodableStorageProtocol) {
        self.storage = storage
    }

    // MARK: Public methods

    func load() -> [Book] {
        storage.load([Book].self, fileName: fileName, default: [])
    }

    func save(_ books: [Book]) {
        storage.save(books, fileName: fileName)
    }
}

