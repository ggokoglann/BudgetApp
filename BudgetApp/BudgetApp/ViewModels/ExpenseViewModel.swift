//
//  ExpenseViewModel.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import Foundation

class ExpenseViewModel {
        var expenses: [Expense] = [Expense(name: "Test Expense", cost: 200)]

        func addUp() -> Double {
                var sum: Double = 0
                for i in expenses {
                    sum += i.cost!
                }
            return sum
        }
        
        func numberOfExpenses() -> Int {
            return expenses.count
        }
        
        func expense(at index: Int) -> Expense {
            return expenses[index]
        }
}
