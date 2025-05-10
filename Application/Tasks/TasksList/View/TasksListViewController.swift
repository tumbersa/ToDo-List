//
//  TasksListViewController.swift
//  ToDo List
//
//  Created by Глеб Капустин on 13.03.2025.
//

import UIKit

final class TasksListViewController: UIViewController {

    private var adapter: TasksListAdapterInput?

    private lazy var bottomContainerView: UIView = {
        let bottomContainerView = UIView()
        bottomContainerView.backgroundColor = .darkGray
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        let divider = UIView()
        divider.backgroundColor = .gray
        divider.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            divider.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5)
        ])

        return bottomContainerView
    }()

    private lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.font = .systemFont(ofSize: 11, weight: .regular)
        bottomLabel.textColor = .white
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        return bottomLabel
    }()

    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setImage(UIImage(resource: .todoCreate), for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return createButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .label
        return tableView
    }()

    private lazy var searchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        return searchController
    }()

    var output: TasksListViewOutput?

    var didSelectCell: ((TodoEntity) -> ())?
    var onEditItem: ((TodoEntity) -> ())?
    // TODO: - Share Item
    var onShareItem: ((TodoEntity) -> ())?
    var onDeleteItem: ((TodoEntity) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        didSelectCell = output?.didSelectCell
        onEditItem = output?.onEditItem
        onDeleteItem = output?.onDeleteItem
        output?.viewLoaded()
        configureAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        adapter?.viewDidAppear()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomInset = bottomContainerView.frame.height
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

}

private extension TasksListViewController {

    func configureAppearance() {
        title = "Задачи"
        navigationController?.navigationBar.tintColor = UIColor(resource: .todoYellow)
        navigationController?.navigationBar.barStyle = .black
        navigationItem.backButtonTitle = "Назад"
        view.backgroundColor = .label
        layoutUI()
    }

    func layoutUI() {
        view.addSubview(tableView)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(bottomLabel)
        bottomContainerView.addSubview(createButton)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let bottomPadding = window.safeAreaInsets.bottom
            NSLayoutConstraint.activate([
                bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bottomContainerView.heightAnchor.constraint(equalToConstant: bottomPadding + 49)
            ])
        }

        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 20.5),
            bottomLabel.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor),
            bottomLabel.leadingAnchor.constraint(greaterThanOrEqualTo: bottomContainerView.leadingAnchor, constant: 16),
            bottomLabel.trailingAnchor.constraint(lessThanOrEqualTo: createButton.leadingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            createButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 5),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 68)
        ])

        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
    }

    @objc func createButtonTapped() {
        output?.onCreateButtonTapped?()
    }

}

extension TasksListViewController: TasksListViewInput {

    func setupInitialState(_ tasksList: [TodoEntity]) {
        adapter = TasksListAdapter(output: self, tableView: tableView, searchController: searchController)
        adapter?.configure(with: tasksList)
        let localized = NSLocalizedString("tasks_count", comment: "")
        bottomLabel.text = String.localizedStringWithFormat(localized, tasksList.count)
    }

    func updateItems(_ tasksList: [TodoEntity]) {
        adapter?.update(items: tasksList)
        let localized = NSLocalizedString("tasks_count", comment: "")
        bottomLabel.text = String.localizedStringWithFormat(localized, tasksList.count)
    }

}

extension TasksListViewController: TasksListAdapterOutput {}
