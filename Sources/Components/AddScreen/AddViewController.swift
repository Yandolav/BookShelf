import UIKit

protocol AddViewControllerProtocol: AnyObject {
    func successAddBook()
}

final class AddViewController: UIViewController {

    // MARK: Public properties

    weak var coordinator: Coordinator?
    var presenter: AddPresenterProtocol?

    // MARK: Private properties

    private let titleTextField = makeTextField(placeholderText: Constants.titlePlaceholder)
    private let authorTextField = makeTextField(placeholderText: Constants.authorPlaceholder)
    private let genreTextField = makeTextField(placeholderText: Constants.genrePlaceholder)
    private let tagsTextField = makeTextField(placeholderText: Constants.tagsPlaceholder)
    private let publicationYearTextField = makeTextField(placeholderText: Constants.publicationYearPlaceholder)

    private let enableGenre: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let allGenre = Genre.allCases
        var allGenreText = Constants.enableGenrePrefix
        for genre in allGenre {
            allGenreText.append(genre.rawValue)
            allGenreText.append(Constants.genreSeparator)
        }
        allGenreText.remove(at: allGenreText.lastIndex(of: Constants.genreSeparatorChar) ?? allGenreText.endIndex)
        label.text = allGenreText
        label.textColor = .black
        return label
    }()

    private let enableYears: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.enableYearsText
        label.textColor = .black
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.addButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.addButtonFontSize)
        button.backgroundColor = .blue
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleTextField)
        view.addSubview(authorTextField)
        view.addSubview(genreTextField)
        view.addSubview(tagsTextField)
        view.addSubview(publicationYearTextField)

        view.addSubview(enableGenre)
        view.addSubview(enableYears)

        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        setupUI()
    }

    // MARK: Private methods

    private func setupUI() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topInset),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            authorTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Constants.verticalSpacing),
            authorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            authorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            authorTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            enableGenre.topAnchor.constraint(equalTo: authorTextField.bottomAnchor, constant: Constants.verticalSpacing),
            enableGenre.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),

            genreTextField.topAnchor.constraint(equalTo: enableGenre.bottomAnchor, constant: Constants.labelToFieldSpacing),
            genreTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            genreTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            genreTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            tagsTextField.topAnchor.constraint(equalTo: genreTextField.bottomAnchor, constant: Constants.verticalSpacing),
            tagsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            tagsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            tagsTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            enableYears.topAnchor.constraint(equalTo: tagsTextField.bottomAnchor, constant: Constants.verticalSpacing),
            enableYears.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),

            publicationYearTextField.topAnchor.constraint(equalTo: enableYears.bottomAnchor, constant: Constants.labelToFieldSpacing),
            publicationYearTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            publicationYearTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            publicationYearTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            addButton.topAnchor.constraint(equalTo: publicationYearTextField.bottomAnchor, constant: Constants.buttonTopSpacing),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc private func tapAddButton() {
        presenter?.addBook(
            title: titleTextField.text,
            author: authorTextField.text,
            publicationYear: publicationYearTextField.text,
            genre: genreTextField.text,
            tags: tagsTextField.text
        )
    }

    static private func makeTextField(placeholderText: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholderText
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = Constants.borderWidth
        textField.textColor = .black
        textField.autocorrectionType = .no

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.textFieldLeftPadding, height: 0))
        textField.leftViewMode = .always

        return textField
    }
}

// MARK: - AddViewControllerProtocol

extension AddViewController: AddViewControllerProtocol {
    func successAddBook() {
        coordinator?.backToMainScreen()
    }
}

// MARK: - Constants

private extension AddViewController {
    enum Constants {
        static let titlePlaceholder = "Введите названия"
        static let authorPlaceholder = "Введите автора"
        static let genrePlaceholder = "Введите жанр"
        static let tagsPlaceholder = "Введите теги через запятую(опционально)"
        static let publicationYearPlaceholder = "Введите дату публикации(опционально)"

        static let enableGenrePrefix = "Доступные жанры: "
        static let genreSeparator = ", "
        static let genreSeparatorChar: Character = ","
        static let enableYearsText = "Доступный для выбора период: 1500 - \(Calendar.current.component(.year, from: Date()))"
        static let addButtonTitle = "Добавить книгу"

        static let topInset: CGFloat = 50
        static let sideInset: CGFloat = 20
        static let textFieldHeight: CGFloat = 30
        static let verticalSpacing: CGFloat = 20
        static let labelToFieldSpacing: CGFloat = 2
        static let buttonTopSpacing: CGFloat = 50

        static let addButtonFontSize: CGFloat = 24
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 2
        static let textFieldLeftPadding: CGFloat = 12
    }
}

