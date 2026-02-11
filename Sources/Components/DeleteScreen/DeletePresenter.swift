import Foundation

protocol DeletePresenterProtocol {
    func deleteBook(id: String?)
}

final class DeletePresenter: DeletePresenterProtocol {

    // MARK: Private properties

    private let bookService: BookShelfServiceProtocol

    // MARK: Public properties

    weak var viewController: DeleteViewControllerProtocol?

    // MARK: Init

    init(bookService: BookShelfServiceProtocol) {
        self.bookService = bookService
    }

    // MARK: Public methods

    func deleteBook(id: String?) {
        do {
            try bookService.delete(id: id)
            print(Constants.successDelete)
            viewController?.successDeleteBook()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Constants

private extension DeletePresenter {
    enum Constants {
        static let successDelete = "Успешно удалено"
    }
}
