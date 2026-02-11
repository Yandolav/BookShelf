import UIKit

public protocol Coordinator: AnyObject {
    func start()
    func showAddScreen()
    func showUpdateScreen()
    func showDeleteScreen()
    func showSearchScreen()
    func backToMainScreen()
    func finish()
}

public final class MainCoordinator: Coordinator {

    // MARK: Private properties

    private let navigationController: UINavigationController
    private let dependencyContainer: Dependencycontainer

    // MARK: Init

    public init(navigationController: UINavigationController, dependencyContainer: Dependencycontainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    // MARK: Public methods

    public func start() {
        let viewController = dependencyContainer.getMainScreenViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    public func showAddScreen() {
        let viewController = dependencyContainer.getAddViewcontroller()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func showUpdateScreen() {
        let viewController = dependencyContainer.getUpdateViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func showDeleteScreen() {
        let viewController = dependencyContainer.getDeleteViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func showSearchScreen() {
        let viewController = dependencyContainer.getSearchViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func backToMainScreen() {
        navigationController.popViewController(animated: true)
    }

    public func finish() {
        exit(0)
    }
}
