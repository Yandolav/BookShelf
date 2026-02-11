import XCTest

public final class BookShelfServiceTests: XCTestCase {

    func test_addBook_success_savesAndAddsHistory() throws {
        let repo = BookRepositoryMock(initial: [])
        let history = HistoryServiceMock()
        let sut = BookShelfService(bookRepository: repo, historyService: history)

        try sut.addBook(
            title: "  Dune ",
            author: " Frank Herbert ",
            publicationYear: "1965",
            genre: "scifi",
            tags: " Classic, sci-fi, classic  ,  "
        )

        let books = sut.list()
        XCTAssertEqual(books.count, 1)

        let b = try XCTUnwrap(books.first)
        XCTAssertEqual(b.title, "dune")
        XCTAssertEqual(b.author, "frank herbert")
        XCTAssertEqual(b.publicationYear, 1965)
        XCTAssertEqual(b.genre, .sciFi)
        XCTAssertEqual(b.tags, ["classic", "sci-fi"])

        XCTAssertEqual(repo.savedSnapshots.count, 1)
        XCTAssertEqual(repo.savedSnapshots[0].count, 1)

        XCTAssertEqual(history.items.count, 1)
        if case .add(let book, _) = history.items[0] {
            XCTAssertEqual(book.id, b.id)
        } else {
            XCTFail("Expected .add history item")
        }
    }

    func test_addBook_invalidYear_throws() {
        let repo = BookRepositoryMock()
        let history = HistoryServiceMock()
        let sut = BookShelfService(bookRepository: repo, historyService: history)

        let currentYear = Calendar.current.component(.year, from: Date())
        XCTAssertThrowsError(
            try sut.addBook(
                title: "a",
                author: "b",
                publicationYear: "\(currentYear + 1)",
                genre: "fiction",
                tags: nil
            )
        )
    }

    func test_addBook_invalidGenre_throws() {
        let repo = BookRepositoryMock()
        let history = HistoryServiceMock()
        let sut = BookShelfService(bookRepository: repo, historyService: history)

        XCTAssertThrowsError(
            try sut.addBook(
                title: "a",
                author: "b",
                publicationYear: "2000",
                genre: "unknownGenre",
                tags: nil
            )
        )
    }

    func test_delete_removes_saves_andAddsHistory() throws {
        let b1 = Book(id: UUID(), title: "a", author: "aa", publicationYear: nil, genre: .fiction, tags: [])
        let b2 = Book(id: UUID(), title: "b", author: "bb", publicationYear: nil, genre: .mystery, tags: [])

        let repo = BookRepositoryMock(initial: [b1, b2])
        let history = HistoryServiceMock()
        let sut = BookShelfService(bookRepository: repo, historyService: history)

        try sut.delete(id: b1.id.uuidString)

        XCTAssertEqual(sut.list().map(\.id), [b2.id])
        XCTAssertEqual(repo.savedSnapshots.count, 1)
        XCTAssertEqual(history.items.count, 1)

        if case .delete(let book, _) = history.items[0] {
            XCTAssertEqual(book.id, b1.id)
        } else {
            XCTFail("Expected .delete history item")
        }
    }

    func test_search_filtersByAuthorAndTag() throws {
        let b1 = Book(id: UUID(), title: "a", author: "john", publicationYear: 2000, genre: .fiction, tags: ["swift"])
        let b2 = Book(id: UUID(), title: "b", author: "john", publicationYear: 2001, genre: .fiction, tags: ["ios"])
        let b3 = Book(id: UUID(), title: "c", author: "mike", publicationYear: 2000, genre: .mystery, tags: ["swift"])

        let repo = BookRepositoryMock(initial: [b1, b2, b3])
        let history = HistoryServiceMock()
        let sut = BookShelfService(bookRepository: repo, historyService: history)

        let result = sut.search(queries: [.author("john"), .tag("swift")])
        XCTAssertEqual(result.map(\.id), [b1.id])
    }
}

