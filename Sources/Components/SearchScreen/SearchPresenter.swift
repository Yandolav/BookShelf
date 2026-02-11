protocol SearchPresenterProtocol {
    func searchBooks(
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    )
}

final class SearchPresenter: SearchPresenterProtocol {

    // MARK: Private properties

    let bookService: BookShelfServiceProtocol
    
    // MARK: Init

    init(bookService: BookShelfServiceProtocol) {
        self.bookService = bookService
    }

    // MARK: Public methods

    func searchBooks(
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    ) {
        var queries: [SearchQuery] = []
        let clearTitle = title?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let clearTitle = clearTitle, !clearTitle.isEmpty {
            queries.append(.title(clearTitle.lowercased()))
        }

        let clearAuthor = author?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let clearAuthor = clearAuthor, !clearAuthor.isEmpty {
            queries.append(.author(clearAuthor.lowercased()))
        }

        let year = Int(publicationYear?.trimmingCharacters(in: .whitespacesAndNewlines) ?? Constants.emptyString)
        if let year = year {
            queries.append(.year(year))
        }

        let finalGenre: Genre?
        let lowercasedGenre = genre?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch lowercasedGenre {
        case Constants.genreFiction:
            finalGenre = .fiction
        case Constants.genreNonFiction:
            finalGenre = .nonFiction
        case Constants.genreMystery:
            finalGenre = .mystery
        case Constants.genreSciFi:
            finalGenre = .sciFi
        case Constants.genreBiography:
            finalGenre = .biography
        case Constants.genreFantasy:
            finalGenre = .fantasy
        default:
            finalGenre = nil
        }

        if let finalGenre = finalGenre {
            queries.append(.genre(finalGenre))
        }

        let finalTags = tags?.lowercased()
            .split(separator: Constants.tagsSeparator)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        var seen = Set<String>()
        let uniqueFinalTag = finalTags?.filter { seen.insert(String($0)).inserted } ?? []
        for uniqueFinalTag in uniqueFinalTag {
            queries.append(.tag(uniqueFinalTag))
        }

        let books = bookService.search(queries: queries)
        print(queries)
        if books.count == 0 {
            print(Constants.badSearchString)
        } else {
            for book in books {
                print(book)
            }
        }
    }
}

// MARK: - Constants

private extension SearchPresenter {
    enum Constants {
        static let emptyString = ""

        static let badSearchString = "Не найдено ни одной книги :("

        static let genreFiction = "fiction"
        static let genreNonFiction = "nonfiction"
        static let genreMystery = "mystery"
        static let genreSciFi = "scifi"
        static let genreBiography = "biography"
        static let genreFantasy = "fantasy"

        static let tagsSeparator: Character = ","
    }
}

