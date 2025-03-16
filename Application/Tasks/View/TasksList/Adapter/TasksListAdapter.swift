//
//  TasksListAdapter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation
import UIKit

final class TasksListAdapter: NSObject {

    private enum Section {
        case main
    }

    private let tableView: UITableView
    private let searchController: UISearchController

    private weak var output: TasksListAdapterOutput?
    private let concurrentQueue = DispatchQueue(label: "com.ToDo_List.tasksListConcurrentQueue", attributes: .concurrent)
    private var searchSerialQueue = DispatchQueue(label: "com.ToDo_List.tasksListSearchSerialQueue")
    private var _items: [TodoEntity] = []

    private var items: [TodoEntity] {
        get {
            return concurrentQueue.sync {
                _items
            }
        }
        set {
            concurrentQueue.async(flags: .barrier) {
                self._items = newValue
            }
        }
    }
    private var filteredItems: [TodoEntity] = []

    private lazy var dataSource: UITableViewDiffableDataSource<Section, TodoEntity> = {
        UITableViewDiffableDataSource<Section, TodoEntity>(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
                let cell = UITableViewCell() // tableView.reuse(UITableViewCell.self, indexPath)
                cell.textLabel?.text = itemIdentifier.title
                return cell
            })
    }()

    init(output: TasksListAdapterOutput, tableView: UITableView, searchController: UISearchController) {
        self.output = output
        self.tableView = tableView
        self.searchController = searchController
        super.init()
        _ = dataSource
        setup()
    }

}

private extension TasksListAdapter {

    func setup() {
        tableView.delegate = self
        searchController.searchResultsUpdater = self
    }

    func updateData(on items: [TodoEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TodoEntity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension TasksListAdapter: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {
            filteredItems.removeAll()
            updateData(on: items)
            return
        }

        searchSerialQueue.async { [weak self] in
            guard let self = self else { return }
            let filteredItems = self.items.filter { $0.title.lowercased().contains(searchText.lowercased()) }

            DispatchQueue.main.sync { [weak self] in
                guard let self = self else { return }
                self.filteredItems = filteredItems
                self.updateData(on: filteredItems)
            }
        }
    }

}

extension TasksListAdapter: UITableViewDelegate {

}

extension TasksListAdapter: TasksListAdapterInput {

    func configure(with items: [TodoEntity]) {
        self.items = items
        updateData(on: items)
    }

}
