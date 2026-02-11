protocol AddPresenterProtocol: AnyObject {
    func addBook(
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    )
}

final class AddPresenter: AddPresenterProtocol {

    // MARK: Public properties

    weak var viewController: AddViewControllerProtocol?

    // MARK: Private properties

    private let bookService: BookShelfServiceProtocol

    // MARK: Init

    init(bookService: BookShelfServiceProtocol) {
        self.bookService = bookService
    }

    // MARK: Public methods

    func addBook(
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    ) {
        do {
            try bookService.addBook(
                title: title,
                author: author,
                publicationYear: publicationYear,
                genre: genre,
                tags: tags
            )
            viewController?.successAddBook()
            print(Constants.bookAddedSuccess)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Constants

private extension AddPresenter {
    enum Constants {
        static let bookAddedSuccess = "Книга успешно добавлена"
    }
}

