//
//  AddIncomeViewController.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class AddIncomeViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var nameInput: String?
    var amountInput: String?
    
    let mainViewModel = IncomeViewModel()
    let mainView = IncomeView()
    
    var incomeAddedHandler: ((Income) -> Void)? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.becomeFirstResponder()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let nameInput = name.text, let amountInputString = amount.text, let amountInput = Double(amountInputString) else {
                    return
                }
                
                let newItem = Income(name: nameInput, cost: amountInput)
                incomeAddedHandler?(newItem) // Notify the income addition using the closure

                dismiss(animated: true, completion: nil)
        }
    }
