import UIKit
import PlaygroundSupport


let navigationController = UINavigationController()
let dependencyContainer = Dependencycontainer()
let coordinator: Coordinator = MainCoordinator(navigationController: navigationController, dependencyContainer: dependencyContainer)

coordinator.start()
PlaygroundPage.current.liveView = navigationController

