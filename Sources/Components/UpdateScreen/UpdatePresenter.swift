import Foundation

protocol UpdatePresenterProtocol: AnyObject {
    func updateBook(
        id: String?,
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    )
}

final class UpdatePresenter: UpdatePresenterProtocol {

    // MARK: Public properties

    weak var viewController: UpdateViewControllerProtocol?

    // MARK: Private properties

    private let bookService: BookShelfServiceProtocol

    // MARK: Init

    init(bookService: BookShelfServiceProtocol) {
        self.bookService = bookService
    }

    // MARK: Public methods

    func updateBook(
        id: String?,
        title: String?,
        author: String?,
        publicationYear: String?,
        genre: String?,
        tags: String?
    ) {
        do {
            try bookService.update(
                id: id,
                title: title,
                author: author,
                publicationYear: publicationYear,
                genre: genre,
                tags: tags
            )
            viewController?.successUpdateBook()
            print(Constants.bookUpdetedSuccess)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Constants

private extension UpdatePresenter {
    enum Constants {
        static let bookUpdetedSuccess = "Книга успешно обновлена"
    }
}


