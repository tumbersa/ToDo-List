//
//  MockStore.swift
//  ToDo_ListTests
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import XCTest
@testable import ToDo_List

final class MockStore: IStore {
    var entities: [TodoEntity] = []

    func addEntity(_ entity: TodoEntity) {
        entities.append(entity)
    }

    func updateEntity(_ entity: TodoEntity) {
        if let index = entities.firstIndex(where: { $0.id == entity.id }) {
            entities[index] = entity
        }
    }

    func delete(entity: TodoEntity) {
        entities.removeAll { $0.id == entity.id }
    }
}
