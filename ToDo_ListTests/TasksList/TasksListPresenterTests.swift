//
//  TasksListPresenterTests.swift
//  ToDo_ListTests
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import XCTest
@testable import ToDo_List

final class TasksListPresenterTests: XCTestCase {

    var presenter: TasksListPresenter!
    var mockView: MockTasksListViewInput!
    var mockInteractor: MockTasksListInteractorInput!
    var mockRouter: MockTasksListRouterInput!

    override func setUp() {
        super.setUp()
        mockView = MockTasksListViewInput()
        mockInteractor = MockTasksListInteractorInput()
        mockRouter = MockTasksListRouterInput()
        presenter = TasksListPresenter()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testViewLoaded_ShouldCallFetchTasksList() {
        // Arrange
        let task = TodoEntity(id: "1", title: "Test Task", description: "Test", date: Date(), completed: false)
        mockInteractor.tasksList = [task]

        // Act
        presenter.viewLoaded()

        // Assert
        XCTAssertTrue(mockInteractor.fetchTasksListCalled)
        XCTAssertTrue(mockView.setupInitialStateCalled)
        XCTAssertEqual(mockView.updatedItems.count, 1)
        XCTAssertEqual(mockView.updatedItems.first?.title, "Test Task")
    }

    func testDidSelectCell_ShouldUpdateEntityAndView() {
        // Arrange
        let task = TodoEntity(id: "1", title: "Test Task", description: "Test", date: Date(), completed: false)
        let expectation = self.expectation(description: "Entity Updated and View Refreshed")

        // Act
        presenter.didSelectCell?(task)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertTrue(self.mockInteractor.updateEntityCalled)
            XCTAssertTrue(self.mockView.updateItemsCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testOnCreateButtonTapped_ShouldNavigateToDetails() {
        presenter.onCreateButtonTapped?()

        XCTAssertTrue(mockRouter.navigateToDetailsCalled)
    }

    func testOnEditItem_ShouldNavigateToDetails() {
        // Arrange
        let task = TodoEntity(id: "1", title: "Test Task", description: "Test", date: Date(), completed: false)
        // Act
        presenter.onEditItem?(task)
        // Assert
        XCTAssertTrue(mockRouter.navigateToDetailsCalled)
    }

    func testOnDeleteItem_ShouldDeleteEntityAndUpdateView() {
        // Arrange
        let task = TodoEntity(id: "1", title: "Test Task", description: "Test", date: Date(), completed: false)
        mockInteractor.tasksList = [task]
        let expectation = self.expectation(description: "Entity Deleted and View Updated")

        // Act
        presenter.onDeleteItem?(task)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertTrue(self.mockInteractor.deleteEntityCalled)
            XCTAssertTrue(self.mockView.updateItemsCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testCreateTask_ShouldAddEntityAndUpdateView() {
        // Arrange
        let newTask = TodoEntity(id: "2", title: "New Task", description: "New", date: Date(), completed: false)
        let expectation = self.expectation(description: "Task Created and View Refreshed")

        // Act
        presenter.createTask(entity: newTask)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertTrue(self.mockInteractor.addEntityCalled)
            XCTAssertTrue(self.mockView.updateItemsCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testUpdateTask_ShouldUpdateEntityAndUpdateView() {
        // Arrange
        let task = TodoEntity(id: "1", title: "Test Task", description: "Test", date: Date(), completed: false)
        let updatedTask = TodoEntity(id: task.id, title: "Updated Task", description: task.description, date: task.date, completed: task.completed)
        let expectation = self.expectation(description: "Task Updated and View Refreshed")

        // Act
        presenter.updateTask(entity: updatedTask)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertTrue(self.mockInteractor.updateEntityCalled)
            XCTAssertTrue(self.mockView.updateItemsCalled)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
