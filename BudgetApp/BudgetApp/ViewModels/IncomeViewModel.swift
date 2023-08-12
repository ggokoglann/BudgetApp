//
//  IncomeViewModel.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import Foundation

class IncomeViewModel {
        var incomes: [Income] = [Income(name: "Test Income", cost: 100)]

        func addUp() -> Double {
                var sum: Double = 0
                for i in incomes {
                    sum += i.cost!
                }
            return sum
        }
    
        func numberOfIncomes() -> Int {
            return incomes.count
        }
        
        func income(at index: Int) -> Income {
            return incomes[index]
        }
}
