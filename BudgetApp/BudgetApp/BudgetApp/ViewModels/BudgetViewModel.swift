//
//  BudgetViewModel.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 16.08.2023.
//

import Foundation

protocol IncomeUpdateDelegate: AnyObject {
    func incomeAdded()
}

class BudgetViewModel {
    static let shared = BudgetViewModel()
    private init() {}
    
    let expenseModel = ExpenseViewModel.shared
    let incomeModel = IncomeViewModel.shared
    
    var assets: [Asset] = []
    
    var monthlyData: [String: (totalIncome: Double, totalExpense: Double, difference: Double)] = [:]
    
    weak var incomeUpdateDelegate: IncomeUpdateDelegate?

    var mainBudgetString: String {
        let currentMonth = getCurrentMonth()
        let totalIncome = getMonthlyTotalIncome(for: currentMonth)
        let totalExpense = getMonthlyTotalExpense(for: currentMonth)
        return String(format: "$ %.2f", totalIncome - totalExpense)
    }
    
    func addToAssets() {
        let totalIncome = incomeModel.calculateTotalIncome(from: incomeModel.incomes)
        let totalExpense = expenseModel.calculateTotalExpense(from: expenseModel.expenses)
        assets.append(Asset(name: "Incomes", cost: totalIncome))
        assets.append(Asset(name: "Expenses", cost: totalExpense))
        updateMonthlyData()
    }
    
    func updateMonthlyData() {
        let currentMonth = getCurrentMonth()
        let totalIncome = incomeModel.calculateTotalIncome(from: incomeModel.incomes)
        let totalExpense = expenseModel.calculateTotalExpense(from: expenseModel.expenses)
        let difference = totalIncome - totalExpense
        monthlyData[currentMonth] = (totalIncome, totalExpense, difference)
        incomeUpdateDelegate?.incomeAdded()
    }
    
    func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Use "MMMM" to get the full month name
        return dateFormatter.string(from: Date())
    }
    
    func recalculateAssets() {
        let totalIncome = incomeModel.calculateTotalIncome(from: incomeModel.incomes)
        let totalExpense = expenseModel.calculateTotalExpense(from: expenseModel.expenses)
            
        if let incomesIndex = assets.firstIndex(where: { $0.name == "Incomes" }),
           let expensesIndex = assets.firstIndex(where: { $0.name == "Expenses" }) {
           
            assets[incomesIndex].cost = totalIncome
            assets[expensesIndex].cost = totalExpense
        }
    }
    
    func numberOfAssets() -> Int {
        return assets.count
    }
    
    func asset(at index: Int) -> Asset {
        return assets[index]
    }
    
    func getMonthlyTotalIncome(for month: String) -> Double {
        return monthlyData[month]?.totalIncome ?? 0.0
    }

    func getMonthlyTotalExpense(for month: String) -> Double {
        return monthlyData[month]?.totalExpense ?? 0.0
    }

    func getMonthlyDifference(for month: String) -> Double {
        return monthlyData[month]?.difference ?? 0.0
    }
}
