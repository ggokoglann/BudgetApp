//
//  AddExpenseViewController.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class AddExpenseView: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var mainViewModel = ExpenseViewModel.shared
    var expenseAddedHandler: ((Expense) -> Void)?
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
                
                let newItem = Expense(name: nameInput, cost: amountInput)
                mainViewModel.addExpense(newItem)
                expenseAddedHandler?(newItem) 

                dismiss(animated: true, completion: nil)
        }
    }
