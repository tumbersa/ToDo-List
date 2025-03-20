//
//  TasksListInteractorTests.swift
//  ToDo_ListTests
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import XCTest
@testable import ToDo_List

class TasksListInteractorTests: XCTestCase {

    var interactor: TasksListInteractor<MockStore>!
    var mockNetworkService: MockNetworkService!
    var mockStore: MockStore!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockStore = MockStore()
        interactor = TasksListInteractor(networkService: mockNetworkService, todoStore: mockStore)
    }

    override func tearDown() {
        interactor = nil
        mockNetworkService = nil
        mockStore = nil
        super.tearDown()
    }

    func testFetchTasksList_SuccessfulNetworkCall() {
        // Arrange
        let mockTodo = TodoEntity(id: "1", title: "Test Task", description: "Description", date: Date(), completed: false)
        let taskListEntity = TaskListEntity(todos: [mockTodo])
        mockNetworkService.result = .success(taskListEntity)

        let expectation = self.expectation(description: "Fetch tasks list")

        UserDefaults.standard.set(false, forKey: Constants.firstSetup)

        // Act
        interactor.fetchTasksList {[weak self] result in
            guard let self else { return }
            switch result {
                case .success(let tasks):
                    // Assert
                    XCTAssertEqual(tasks.count, 1)
                    XCTAssertEqual(tasks.first?.title, "Test Task")
                    XCTAssertEqual(mockStore.entities.count, 1)
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success, but got failure")
            }
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFetchTasksList_WhenFirstSetupDone_ShouldUseLocalData() {
        // Arrange
        let mockTodo = TodoEntity(id: "1", title: "Local Task", description: "Description", date: Date(), completed: false)
        mockStore.addEntity(mockTodo)

        UserDefaults.standard.set(true, forKey: Constants.firstSetup)

        let expectation = self.expectation(description: "Fetch tasks list")

        // Act
        interactor.fetchTasksList { result in
            switch result {
                case .success(let tasks):
                    // Assert
                    XCTAssertEqual(tasks.count, 1)
                    XCTAssertEqual(tasks.first?.title, "Local Task")
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success, but got failure")
            }
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFetchTasksList_FailureNetworkCall() {
        // Arrange
        mockNetworkService.result = .failure(NetworkError.urlRequestError(NSError(domain: "", code: -1, userInfo: nil)))

        UserDefaults.standard.set(false, forKey: Constants.firstSetup)

        let expectation = self.expectation(description: "Failure callback")

        // Act
        interactor.fetchTasksList { result in
            switch result {
                case .success:
                    XCTFail("Expected failure, but got success")
                case .failure:
                    // Assert
                    expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testUpdateTask() {
        // Arrange
        let mockTodo = TodoEntity(id: "1", title: "Old Task", description: "Description", date: Date(), completed: false)
        mockStore.addEntity(mockTodo)

        let updatedTodo = TodoEntity(id: "1", title: "Updated Task", description: "Updated Description", date: Date(), completed: true)

        // Act
        interactor.update(entity: updatedTodo)

        // Assert
        XCTAssertEqual(mockStore.entities.count, 1)
        XCTAssertEqual(mockStore.entities.first?.title, "Updated Task")
    }

    func testDeleteTask() {
        // Arrange
        let mockTodo = TodoEntity(id: "1", title: "Task to delete", description: "Description", date: Date(), completed: false)
        mockStore.addEntity(mockTodo)

        // Act
        interactor.delete(entity: mockTodo)

        // Assert
        XCTAssertEqual(mockStore.entities.count, 0)
    }

    func testAddTask() {
        // Arrange
        let mockTodo = TodoEntity(id: "1", title: "New Task", description: "Description", date: Date(), completed: false)

        // Act
        interactor.add(entity: mockTodo)

        // Assert
        XCTAssertEqual(mockStore.entities.count, 1)
        XCTAssertEqual(mockStore.entities.first?.title, "New Task")
    }
}
