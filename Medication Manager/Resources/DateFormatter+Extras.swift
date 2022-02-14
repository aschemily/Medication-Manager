//
//  DateFormatter+Extras.swift
//  Medication Manager
//
//  Created by Emily Asch on 2/14/22.
//

import Foundation

extension DateFormatter{
    static let medicationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
