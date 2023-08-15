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
    var groupedIncomes: [String: [Income]] = [:]
    
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
        groupIncomesByMonth()
        updateUI?()
    }
    
    private func groupIncomesByMonth() {
        groupedIncomes.removeAll()
        
        for income in incomes {
            guard let date = income.date else {
                continue
            }
            
            let monthKey = monthYearFormatter.string(from: date)
            if groupedIncomes[monthKey] == nil {
                groupedIncomes[monthKey] = [income]
            } else {
                groupedIncomes[monthKey]?.append(income)
            }
        }
    }
    
    let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()
    
    func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Use "MMMM" to get the full month name
        return dateFormatter.string(from: Date())
    }
    
    func numberOfIncomes() -> Int {
        return incomes.count
    }
    
    func income(at index: Int) -> Income {
        return incomes[index]
    }
}
