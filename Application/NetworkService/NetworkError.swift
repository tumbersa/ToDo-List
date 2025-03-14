//
//  NetworkError.swift
//  ToDo List
//
//  Created by Глеб Капустин on 13.03.2025.
//

import Foundation

//MARK: - Network Error

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case invalidUrl
    case otherError
}
