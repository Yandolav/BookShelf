public final class Dependencycontainer {

    // MARK: Private properties

    private let storage: StorageProtocol
    private let bookRepository: BookRepositoryProtocol
    private let historyService: HistoryServiceProtocol
    private let bookService: BookShelfServiceProtocol

    // MARK: Init

    public init() {
        self.storage = Storage()
        self.bookRepository = BookRepository(storage: storage)
        self.historyService = HistoryService(maxSize: Constants.maxSize)
        self.bookService = BookShelfService(bookRepository: bookRepository, historyService: historyService)
    }

    // MARK: Publiс methods

    func getMainScreenViewController() -> MainScreenViewController {
        let presenter = MainScreenPresenter(bookService: bookService, historyService: historyService)
        let viewController = MainScreenViewController()
        viewController.presenter = presenter
        return viewController
    }

    func getAddViewcontroller() -> AddViewController {
        let presenter = AddPresenter(bookService: bookService)
        let viewController = AddViewController()
        viewController.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

    func getDeleteViewController() -> DeleteViewController {
        let presenter = DeletePresenter(bookService: bookService)
        let viewController = DeleteViewController()
        presenter.viewController = viewController
        viewController.presenter = presenter
        return viewController
    }

    func getSearchViewController() -> SearchViewController {
        let presenter = SearchPresenter(bookService: bookService)
        let viewController = SearchViewController()
        viewController.presenter = presenter
        return viewController
    }

    func getUpdateViewController() -> UpdateViewController {
        let presenter = UpdatePresenter(bookService: bookService)
        let viewController = UpdateViewController()
        presenter.viewController = viewController
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Constants

private extension Dependencycontainer {
    enum Constants {
        static let maxSize = 10
    }
}
