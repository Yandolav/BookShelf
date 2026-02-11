import UIKit

final class MainScreenViewController: UIViewController {

    // MARK: Public properties

    weak var coordinator: Coordinator?
    var presenter: MainScreenPresenterProtocol?

    // MARK: Private properties

    private let addButton = makeButton(title: Constants.addTitle)
    private let updateButton = makeButton(title: Constants.updateTitle)
    private let deleteButton = makeButton(title: Constants.deleteTitle)
    private let searchButton = makeButton(title: Constants.searchTitle)
    private let historyButton = makeButton(title: Constants.historyTitle)

    private let printButton = makeButton(title: Constants.printTitle)
    private let printSortWithAuthorButton = makeButton(title: Constants.printSortWithAuthor)
    private let printSortWithTitleButton = makeButton(title: Constants.printSortWithTitle)
    private let printSortWithDateButton = makeButton(title: Constants.printSortWithDate)
    private let printWithuUndatedButton = makeButton(title: Constants.printWithUndated)

    private let exitButton = makeButton(title: Constants.exitTitle)

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.stackSpacing
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()

    private let printStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.stackSpacing
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Private methods

    private func setupUI() {
        view.addSubview(stack)
        view.addSubview(printStack)

        stack.addArrangedSubview(addButton)
        stack.addArrangedSubview(updateButton)
        stack.addArrangedSubview(deleteButton)
        stack.addArrangedSubview(searchButton)
        stack.addArrangedSubview(historyButton)

        printStack.addArrangedSubview(printButton)
        printStack.addArrangedSubview(printSortWithAuthorButton)
        printStack.addArrangedSubview(printSortWithTitleButton)
        printStack.addArrangedSubview(printSortWithDateButton)
        printStack.addArrangedSubview(printWithuUndatedButton)
        printStack.addArrangedSubview(exitButton)

        addButton.addTarget(self, action: #selector(tapInAddButton), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(tapInUpdateButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(tapInDeleteButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(tapInSearchButton), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(tapInHistoryButton), for: .touchUpInside)

        printButton.addTarget(self, action: #selector(tapInPrintButton), for: .touchUpInside)
        printSortWithAuthorButton.addTarget(self, action: #selector(tapInPrintSortWithAuthorButton), for: .touchUpInside)
        printSortWithTitleButton.addTarget(self, action: #selector(tapInPrintSortWithTitleButton), for: .touchUpInside)
        printSortWithDateButton.addTarget(self, action: #selector(tapInPrintSortWithDateButton), for: .touchUpInside)
        printWithuUndatedButton.addTarget(self, action: #selector(tapInPrintWithuUndatedButton), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(tapInExitButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.stackTopInset),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackSideInset),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackSideInset),

            printStack.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: Constants.printStackTopInset),
            printStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackSideInset),
            printStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackSideInset)
        ])
    }

    @objc private func tapInAddButton() {
        coordinator?.showAddScreen()
    }

    @objc private func tapInUpdateButton() {
        coordinator?.showUpdateScreen()
    }

    @objc private func tapInDeleteButton() {
        coordinator?.showDeleteScreen()
    }

    @objc private func tapInPrintButton() {
        presenter?.printBooks(printStyle: .ordinary)
    }

    @objc private func tapInPrintSortWithAuthorButton() {
        presenter?.printBooks(printStyle: .byAuthor)
    }

    @objc private func tapInPrintSortWithTitleButton() {
        presenter?.printBooks(printStyle: .byTitle)
    }

    @objc private func tapInPrintSortWithDateButton() {
        presenter?.printBooks(printStyle: .byDate)
    }

    @objc private func tapInPrintWithuUndatedButton() {
        presenter?.printBooks(printStyle: .noDate)
    }

    @objc private func tapInSearchButton() {
        coordinator?.showSearchScreen()
    }

    @objc private func tapInHistoryButton() {
        presenter?.printHistory()
    }

    @objc private func tapInExitButton() {
        coordinator?.finish()
    }

    private static func makeButton(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.buttonFontSize)
        button.backgroundColor = .blue
        button.layer.cornerRadius = Constants.buttonCornerRadius
        return button
    }
}

// MARK: - Constants

private extension MainScreenViewController {
    enum Constants {
        static let addTitle = "Добавить книгу"
        static let updateTitle = "Изменить книгу"
        static let deleteTitle = "Удалить книгу"
        static let searchTitle = "Найти книги"
        static let historyTitle = "Вывести историю операций"
        static let exitTitle = "Выйти"

        static let printTitle = "Вывести список книг"
        static let printSortWithAuthor = "Вывести книги отсортированые по автору"
        static let printSortWithTitle = "Вывести книги отсортрованные по названию"
        static let printSortWithDate = "Вывести книги отсортрованные по дате"
        static let printWithUndated = "Вывести книги без дат"

        static let stackSpacing: CGFloat = 5
        static let stackTopInset: CGFloat = 20
        static let stackSideInset: CGFloat = 10

        static let printStackTopInset: CGFloat = 30

        static let buttonFontSize: CGFloat = 24
        static let buttonCornerRadius: CGFloat = 15
    }
}
