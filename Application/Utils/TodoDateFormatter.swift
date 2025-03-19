//
//  TodoDateFormatter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 16.03.2025.
//

import Foundation

enum TodoDateFormatter {

    static let dateFormatter = DateFormatter()

    static func formatted(date: Date) -> String {
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }

    static func date(from string: String) -> Date? {
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.date(from: string)
    }

}
