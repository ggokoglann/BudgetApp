//
//  BudgetView.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class BudgetView: UIViewController {
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var budgetShownLabel: UILabel!
    
    let expenseModel = ExpenseViewModel()
    let incomeModel = IncomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSums()
    }
    
    func addSums() {
        let totalIncome = incomeModel.addUp()
        let totalExpense = expenseModel.addUp()
        
        let totalSum = totalIncome - totalExpense
        budgetShownLabel.text = "\(totalSum)"        
    }
}
