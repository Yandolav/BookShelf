final class BookRepositoryMock: BookRepositoryProtocol {
    private(set) var savedSnapshots: [[Book]] = []
    private var storage: [Book]

    init(initial: [Book] = []) {
        self.storage = initial
    }

    func load() -> [Book] {
        storage
    }

    func save(_ books: [Book]) {
        storage = books
        savedSnapshots.append(books)
    }
}
