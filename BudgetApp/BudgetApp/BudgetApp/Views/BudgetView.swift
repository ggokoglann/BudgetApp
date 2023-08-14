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
    @IBOutlet weak var calculateButton: UIButton!
    
    let expenseModel = ExpenseViewModel.shared
    let incomeModel = IncomeViewModel.shared
    let budgetModel = BudgetViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUi()
    }
    
    func updateUi() {
        let budgetString = budgetModel.mainBudget()
        budgetShownLabel?.text = "\(budgetString)"
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        let budgetString = budgetModel.mainBudget()
        budgetShownLabel?.text = "\(budgetString)"
    }
}
