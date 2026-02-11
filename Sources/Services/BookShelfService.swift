import Foundation

protocol BookShelfServiceProtocol {
    func addBook(
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    ) throws

    func update(
        id: String?,
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    ) throws

    func delete(id: String?) throws

    func list() -> [Book]

    func search(queries: [SearchQuery]) -> [Book]
}

final class BookShelfService {

    // MARK: Private properties

    private var books: [Book]
    private let bookRepository: BookRepositoryProtocol
    private let historyService: HistoryServiceProtocol

    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }

    // MARK: Init

    init(bookRepository: BookRepositoryProtocol, historyService: HistoryServiceProtocol) {
        self.bookRepository = bookRepository
        self.historyService = historyService
        self.books = bookRepository.load()
    }

    // MARK: Private Methods

    private func normalizeId(id: String?) throws -> UUID {
        guard let id,
              let uuid = UUID(uuidString: id.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            throw LibraryError.invalidUUID(id ?? "")
        }

        return uuid
    }

    private func normalizeRequiredText(_ value: String?, error: LibraryError) throws -> String {
        let cleaned = value?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard let cleaned, !cleaned.isEmpty else { throw error }
        return cleaned
    }

    private func parseOptionalYear(_ value: String?) throws -> Int? {
        let raw = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if raw.isEmpty { return nil }

        guard let year = Int(raw) else {
            throw LibraryError.invalidYearFormat(raw)
        }
        return year
    }

    private func parseOptionalGenreStrict(_ value: String?) throws -> Genre? {
        let raw = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if raw.isEmpty { return nil }

        guard let g = parseGenre(raw) else {
            throw LibraryError.invalidGenre(raw)
        }
        return g
    }

    private func parseGenre(_ value: String?) -> Genre? {
        let lowercasedGenre = value?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let finalGenre: Genre?
        switch lowercasedGenre {
        case "fiction":
            finalGenre = .fiction
        case "nonfiction":
            finalGenre = .nonFiction
        case "mystery":
            finalGenre = .mystery
        case "scifi":
            finalGenre = .sciFi
        case "biography":
            finalGenre = .biography
        case "fantasy":
            finalGenre = .fantasy
        default:
            finalGenre = nil
        }

        return finalGenre
    }

    private func parseTags(_ value: String?) -> [String] {
        let finalTags = value?
            .lowercased()
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        var seen = Set<String>()
        let uniqueFinalTags = finalTags?.filter { seen.insert(String($0)).inserted } ?? []
        return uniqueFinalTags
    }
}

// MARK: - BookShelfServiceProtocol

extension BookShelfService: BookShelfServiceProtocol {
    func addBook(
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    ) throws {
        let normalizedTitle = try normalizeRequiredText(title, error: .emptyTitle)
        let normalizedAuthor = try normalizeRequiredText(author, error: .emptyAuthor)

        let year = try parseOptionalYear(publicationYear)
        if let year, (year < 1500 || year > currentYear) {
            throw LibraryError.invalidYear(year)
        }

        let parsedGenre = parseGenre(genre)
        guard let parsedGenre else {
            throw LibraryError.invalidGenre(genre ?? "")
        }

        let parsedTags = parseTags(tags)

        let id = UUID()
        guard !books.contains(where: { $0.id == id }) else {
            throw LibraryError.duplicateId(id)
        }

        let newBook = Book(
            id: id,
            title: normalizedTitle,
            author: normalizedAuthor,
            publicationYear: year,
            genre:  parsedGenre,
            tags: parsedTags
        )
        books.append(newBook)
        bookRepository.save(books)
        historyService.addHistoryItem(historyItem: .add(newBook, Date()))
    }

    func update(
        id: String?,
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    ) throws {
        let uuid = try normalizeId(id: id)

        guard let index = (books.firstIndex { $0.id == uuid }) else {
            throw LibraryError.notFound(id: uuid)
        }

        let clearTitle = title?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let clearAuthor = author?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        let year = try parseOptionalYear(publicationYear)
        if let year, (year < 1500 || year > currentYear) {
            throw LibraryError.invalidYear(year)
        }

        let genre = try parseOptionalGenreStrict(genre)
        let tags = parseTags(tags)

        let oldBook = books[index]
        let newBook = Book(
            id: uuid,
            title: clearTitle.flatMap { $0.isEmpty ? nil : $0 } ?? oldBook.title,
            author: clearAuthor.flatMap { $0.isEmpty ? nil : $0 } ?? oldBook.author,
            publicationYear: year ?? oldBook.publicationYear,
            genre: genre ?? oldBook.genre,
            tags: tags.isEmpty ? oldBook.tags : tags
        )
        books[index] = newBook
        bookRepository.save(books)
        historyService.addHistoryItem(historyItem: .update(old: oldBook, new: newBook, Date()))
    }

    func delete(id: String?) throws {
        let uuid = try normalizeId(id: id)

        guard let index = (books.firstIndex { $0.id == uuid }) else {
            throw LibraryError.notFound(id: uuid)
        }

        historyService.addHistoryItem(historyItem: .delete(books[index], Date()))
        books.remove(at: index)
        bookRepository.save(books)
    }

    func list() -> [Book] {
        books
    }

    func search(queries: [SearchQuery]) -> [Book] {
        var allBooks = books

        for query in queries {
            switch query {
            case .author(let author):
                allBooks = allBooks.filter { $0.author == author }
            case .title(let title):
                allBooks = allBooks.filter { $0.title == title }
            case .genre(let genre):
                allBooks = allBooks.filter { $0.genre == genre }
            case .tag(let tag):
                allBooks = allBooks.filter { $0.tags.contains { $0 == tag } }
            case .year(let year):
                allBooks = allBooks.filter { $0.publicationYear == year }
            }
        }

        return allBooks
    }
}
