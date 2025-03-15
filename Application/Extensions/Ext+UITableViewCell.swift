//
//  Ext+UITableViewCell.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        String(describing: self)
    }

    var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }

}
