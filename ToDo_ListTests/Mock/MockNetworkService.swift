//
//  MockNetworkService.swift
//  ToDo_ListTests
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import XCTest
@testable import ToDo_List

final class MockNetworkService: INetworkService {
    var result: Result<TaskListEntity, Error>?

    func obtainTasksListResult(_ completion: @escaping (Result<TaskListEntity, Error>) -> ()) {
        if let result = result {
            completion(result)
        }
    }
}
