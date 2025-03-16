//
//  TasksListTableViewCell.swift
//  ToDo List
//
//  Created by Глеб Капустин on 16.03.2025.
//

import UIKit

final class TasksListTableViewCell: UITableViewCell {

    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func confugure(with model: TodoEntity, isLast: Bool) {
        checkmarkImageView.image = model.completed ?
            .init(resource: .todoCheckmark) :
            .init(resource: .todoCircle)

        let titleAttributedString = NSMutableAttributedString(string: model.title)

        if model.completed {
            titleAttributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: titleAttributedString.length))
            titleAttributedString.addAttribute(.strikethroughColor, value: UIColor.gray, range: NSRange(location: 0, length: titleAttributedString.length))
            titleLabel.textColor = .gray
        } else {
            titleLabel.textColor = .systemBackground
        }
        titleLabel.attributedText = titleAttributedString

        descriptionLabel.text = model.description
        descriptionLabel.textColor = model.completed ? .gray : .systemBackground

        dateLabel.text = TodoDateFormatter.formatted(date: model.date)

        divider.isHidden = isLast
    }
}

private extension TasksListTableViewCell {

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func layoutUI() {
        [checkmarkImageView, labelStackView, divider].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }

        [titleLabel, descriptionLabel, dateLabel].forEach { view in
            labelStackView.addArrangedSubview(view)
        }

        NSLayoutConstraint.activate([
            checkmarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkmarkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),

            labelStackView.topAnchor.constraint(equalTo: checkmarkImageView.topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            labelStackView.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 6),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.leadingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
        ])
    }

}

