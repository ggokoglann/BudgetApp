//
//  ExpenseViewModel.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import Foundation

class ExpenseViewModel {
    static let shared = ExpenseViewModel()
    
    private init() {
        self.expenses = DataManager.shared.loadExpenses()
        groupExpensesByMonth()
    }
    
    var updateUI: (() -> Void)?
    
    var expenses: [Expense] =  []
    var groupedExpenses: [String: [Expense]] = [:]

    var totalExpenseString: String {
    let totalExpense = calculateTotalExpense(from: expenses)
        return String(format: "%.2f", totalExpense)
    }

    func calculateTotalExpense(from expenses: [Expense]) -> Double {
        let totalExpense = expenses.reduce(0) { (result, expense) in
            return result + expense.cost!
        }
        return totalExpense
    }
    
    func addExpense(_ expense: Expense) {
            expenses.append(expense)
            groupExpensesByMonth()
            updateUI?()
            DataManager.shared.saveExpenses(expenses) // Save the updated expenses
        }
    
    private func groupExpensesByMonth() {
        groupedExpenses.removeAll()
        
        for expense in expenses {
            guard let date = expense.date else {
                continue
            }
            
            let monthKey = monthYearFormatter.string(from: date)
            if groupedExpenses[monthKey] == nil {
                groupedExpenses[monthKey] = [expense]
            } else {
                groupedExpenses[monthKey]?.append(expense)
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
        
    func numberOfExpenses() -> Int {
        return expenses.count
    }
    
    func expense(at index: Int) -> Expense {
        return expenses[index]
    }
    
    func deleteExpense(at index: Int) {
        if index >= 0 && index < expenses.count {
            expenses.remove(at: index)
            groupExpensesByMonth() // Regroup the expenses
            updateUI?()
        }
    }
    
    func saveExpenses() {
        DataManager.shared.saveExpenses(expenses)
    }

    func loadExpenses() {
        expenses = DataManager.shared.loadExpenses()
    }
}
