//
//  IncomeViewModel.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import Foundation

class IncomeViewModel {
    static let shared = IncomeViewModel()
    private init() {}
    
    var updateUI: (() -> Void)?

    var incomes: [Income] = []
    
    var totalIncomeString: String {
        let totalIncome = calculateTotalIncome(from: incomes)
        return String(format: "%.2f", totalIncome)
    }
    
    func calculateTotalIncome(from incomes: [Income]) -> Double {
        let totalIncome = incomes.reduce(0) { (result, income) in
            return result + income.cost!
        }
        return totalIncome
    }

    func addIncome(_ income: Income) {
        incomes.append(income)
        updateUI?()
    }
    
    func numberOfIncomes() -> Int {
        return incomes.count
    }
    
    func income(at index: Int) -> Income {
        return incomes[index]
    }
}
