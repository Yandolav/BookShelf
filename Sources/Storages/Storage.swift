import Foundation

protocol StorageProtocol {
    func getBooks() -> [Book]
    func saveBooks(_ books: [Book])
}

final class Storage: StorageProtocol {

    // MARK: Private properties

    private let fileURL: URL

    // MARK: Init

    init() {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = base.appendingPathComponent("books.json")
    }

    // MARK: Public methods

    func getBooks() -> [Book] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }

        do {
            let data = try Data(contentsOf: fileURL)
            guard !data.isEmpty else { return [] }
            return try JSONDecoder().decode([Book].self, from: data)
        } catch {
            print("getBooks error:", error)
            return []
        }
    }

    func saveBooks(_ books: [Book]) {
        do {
            let data = try JSONEncoder().encode(books)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("saveBooks error:", error)
        }
    }
}

