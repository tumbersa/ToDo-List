//
//  TasksListViewController.swift
//  ToDo List
//
//  Created by Глеб Капустин on 13.03.2025.
//

import UIKit

final class TasksListViewController: UIViewController {

    private var adapter: TasksListAdapterInput?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
        tableView.backgroundColor = .label
        return tableView
    }()

    private lazy var searchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        return searchController
    }()

    var output: TasksInteractorOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        output?.viewLoaded()
        configureAppearance()
    }

}

private extension TasksListViewController {

    func configureAppearance() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .label
    }

}

extension TasksListViewController: TasksListViewInput {

    func setupInitialState(_ tasksList: [TodoEntity]) {
        adapter = TasksListAdapter(output: self, tableView: tableView, searchController: searchController)
        adapter?.configure(with: tasksList)
    }

}

extension TasksListViewController: TasksListAdapterOutput {

}
