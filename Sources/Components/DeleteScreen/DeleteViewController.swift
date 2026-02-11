import UIKit

protocol DeleteViewControllerProtocol: AnyObject {
    func successDeleteBook()
}

final class DeleteViewController: UIViewController {

    // MARK: Public properties

    weak var coordinator: Coordinator?
    var presenter: DeletePresenterProtocol?

    // MARK: Private properties

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Constants.textFieldPlaceholder
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = Constants.borderWidth
        textField.textColor = .black
        textField.autocorrectionType = .no

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.textFieldLeftPadding, height: 0))
        textField.leftViewMode = .always

        return textField
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.deleteButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.deleteButtonFontSize)
        button.backgroundColor = .blue
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textField)

        view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)

        setupUI()
    }

    // MARK: Private methods

    private func setupUI() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.textFieldTopPadding),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding),
            textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            deleteButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.deleteButtonTopPadding),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func tapDeleteButton() {
        presenter?.deleteBook(id: textField.text)
    }
}

// MARK: - DeleteViewControllerProtocol

extension DeleteViewController: DeleteViewControllerProtocol {
    func successDeleteBook() {
        coordinator?.backToMainScreen()
    }
}

// MARK: - Constants

private extension DeleteViewController {
    enum Constants {
        static let textFieldPlaceholder = "Введите id книги, которую хотите удалить"
        static let deleteButtonTitle = "Удалить книгу"
        
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 2
        static let deleteButtonFontSize: CGFloat = 24
        
        static let textFieldTopPadding: CGFloat = 50
        static let sidePadding: CGFloat = 20
        static let textFieldHeight: CGFloat = 30
        static let deleteButtonTopPadding: CGFloat = 20
        static let textFieldLeftPadding: CGFloat = 12
    }
}
