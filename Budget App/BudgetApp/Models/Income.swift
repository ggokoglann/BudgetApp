//
//  Income.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import Foundation
import UIKit

struct Income: Codable, Equatable {
    var name: String?
    var cost: Double?
    var date: Date?
}
