//
//  TasksDetailsViewController.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import UIKit

final class TasksDetailsViewController: UIViewController {

    private lazy var titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.font = .systemFont(ofSize: 34, weight: .bold)
        titleTextField.textColor = .systemBackground
        let placeholderText = "Название задачи"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]

        titleTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        return titleTextField
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = TodoDateFormatter.formatted(date: Date.now)
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.textColor = .lightGray
        descriptionTextView.text = "Описание задачи"
        descriptionTextView.backgroundColor = .label
        descriptionTextView.delegate = self
        return descriptionTextView
    }()

    private var model: TodoEntity?

    var output: TasksDetailsViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        output?.viewLoaded()
        configureAppearance()
        setupTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        
        output?.viewWillDisappear?(
            .init(
                id: model?.id ?? UUID().uuidString,
                title: titleTextField.text ?? "Название задачи",
                description: descriptionTextView.text ?? "",
                date: TodoDateFormatter.date(from: dateLabel.text ?? "") ?? .now,
                completed: model?.completed ?? false
            )
        )
    }

}

private extension TasksDetailsViewController {

    func configureAppearance() {
        view.backgroundColor = .label
        layoutUI()
    }

    func layoutUI() {
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 41),

            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),

            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension TasksDetailsViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray && textView.text == "Описание задачи" {
            textView.text = ""
            textView.textColor = .systemBackground
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Описание задачи"
            textView.textColor = .lightGray
        }
    }

}

extension TasksDetailsViewController: TasksDetailsViewInput {

    func setupInitialState(_ entity: TodoEntity) {
        titleTextField.text = entity.title
        descriptionTextView.text = entity.description
        dateLabel.text = TodoDateFormatter.formatted(date: entity.date)
    }

}
