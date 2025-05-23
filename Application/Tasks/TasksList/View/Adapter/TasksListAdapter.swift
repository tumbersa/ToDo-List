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
    private var currentItems: [TodoEntity] {
        filteredItems.isEmpty ? items : filteredItems
    }

    private var items: [TodoEntity] = []
    private var filteredItems: [TodoEntity] = []

    private lazy var dataSource: UITableViewDiffableDataSource<Section, TodoEntity> = {
        UITableViewDiffableDataSource<Section, TodoEntity>(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
                let cell = tableView.reuse(TasksListTableViewCell.self, indexPath)
                guard let self else { return cell }
                let isLast = indexPath.row == currentItems.count - 1
                cell.confugure(with: itemIdentifier, isLast: isLast)
                return cell
            })
    }()

    init(output: TasksListAdapterOutput, tableView: UITableView, searchController: UISearchController) {
        self.output = output
        self.tableView = tableView
        self.searchController = searchController
        super.init()
        setup()
    }

}

private extension TasksListAdapter {

    func setup() {
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TasksListTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        searchController.searchResultsUpdater = self
    }

    func updateData(on items: [TodoEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TodoEntity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func previewViewController(for item: TodoEntity) -> UIViewController {
        let previewController = UIViewController()
        previewController.view.backgroundColor = UIColor(resource: .todoGray)
        let cell = tableView.visibleCells.compactMap { cell -> TasksListTableViewCell? in
            guard let cell = cell as? TasksListTableViewCell, item.id == cell.model?.id else {
                return nil
            }
            return cell
        }.first
        previewController.preferredContentSize = cell?.contentView.frame.size ?? .zero

        let previewView = TasksListPreviewView(
            title: item.title,
            description: item.description,
            date: TodoDateFormatter.formatted(date: item.date)
        )
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewController.view.addSubview(previewView)

        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: previewController.view.topAnchor),
            previewView.bottomAnchor.constraint(equalTo: previewController.view.bottomAnchor),
            previewView.leadingAnchor.constraint(equalTo: previewController.view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: previewController.view.trailingAnchor)
        ])

        return previewController
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

        Task {
            let filteredItems = self.items.filter { $0.title.lowercased().contains(searchText.lowercased()) }

            Task { @MainActor in
                self.filteredItems = filteredItems
                self.updateData(on: filteredItems)
            }
        }
    }

}

extension TasksListAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didSelectCell?(currentItems[indexPath.row])
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = currentItems[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: { [weak self] in
            return self?.previewViewController(for: item)
        }) { suggestedActions in
            let editAction = UIAction(title: "Редактировать", image: UIImage(resource: .todoPencil)) { [weak self] _ in
                self?.output?.onEditItem?(item)
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(resource: .todoSquareArrow)) { [weak self] _ in
                self?.output?.onShareItem?(item)
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(resource: .todoTrash), attributes: .destructive) { [weak self] _ in
                self?.output?.onDeleteItem?(item)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }

}

extension TasksListAdapter: TasksListAdapterInput {

    func configure(with items: [TodoEntity]) {
        self.items = items
        updateData(on: items)
    }

    func viewDidAppear() {
        updateData(on: currentItems)
    }

    func update(items: [TodoEntity]) {
        self.items = items

        if let searchText = searchController.searchBar.text,
           !searchText.isEmpty {
            filteredItems = items.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            updateData(on: filteredItems)
        } else {
            filteredItems.removeAll()
            updateData(on: items)
        }
    }

}


