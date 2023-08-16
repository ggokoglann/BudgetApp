//
//  AddIncomeViewController.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class AddIncomeView: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var mainViewModel = IncomeViewModel.shared
    var budgetViewModel = BudgetViewModel.shared
    var incomeAddedHandler: ((Income) -> Void)?
    var nameInput: String?
    var amountInput: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        name.becomeFirstResponder()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let nameInput = name.text, let amountInputString = amount.text, let amountInput = Double(amountInputString) else {
                return
            }
                
            let newItem = Income(name: nameInput, cost: amountInput, date: Date())
            mainViewModel.addIncome(newItem)
            incomeAddedHandler?(newItem)

            dismiss(animated: true, completion: nil)
        }
    }
