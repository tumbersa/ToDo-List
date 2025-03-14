//
//  NetworkService.swift
//  ToDo List
//
//  Created by Глеб Капустин on 13.03.2025.
//

import Foundation

protocol INetworkService {
    func obtainTasksListResult(_ completion: @escaping (Result<TaskListEntity, Error>) -> ())
}

final class NetworkService: INetworkService {

    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()

    func obtainTasksListResult(_ completion: @escaping (Result<TaskListEntity, Error>) -> ()) {
        guard let url = URL(string: Constants.baseUrl + "/todos") else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                completion(.failure(NetworkError.otherError))
                return
            }

            if let error {
                completion(.failure(NetworkError.urlRequestError(error)))
                return
            }

            guard
                let response = response as? HTTPURLResponse,
                let data else {
                completion(.failure(NetworkError.otherError))
                return
            }

            guard 200..<300 ~= response.statusCode else {
                completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }

            do {
                let entry = try decoder.decode(TaskListEntry.self, from: data)
                let entity = TaskListEntity(entry: entry)
                completion(.success(entity))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

}
