//
//  ExpenseViewModel.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import Foundation

class ExpenseViewModel {
    static let shared = ExpenseViewModel()    
    private init() {}
    
    var updateUI: (() -> Void)?
    
    var expenses: [Expense] =  []
    
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
        updateUI?()
    }
        
    func numberOfExpenses() -> Int {
        return expenses.count
    }
    
    func expense(at index: Int) -> Expense {
        return expenses[index]
    }
}
