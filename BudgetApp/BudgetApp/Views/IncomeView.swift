//
//  IncomeView.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class IncomeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var IncomeTableView: UITableView!
    @IBOutlet weak var addIncomeButton: UIButton!
        
    let viewModel = IncomeViewModel()
    
    var incomeAddedHandler: ((Income) -> Void)? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IncomeTableView.dataSource = self
        IncomeTableView.delegate = self
        updateUi()
    }
    
    func updateUi() {
        let sum = viewModel.addUp()
        totalIncomeLabel.text = "Total Income:\(sum)"
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addIncomeVC = storyboard.instantiateViewController(withIdentifier: "AddIncomeViewController") as? AddIncomeViewController {
            
            addIncomeVC.incomeAddedHandler = { [weak self] newItem in
                self?.viewModel.incomes.append(newItem)
                self?.IncomeTableView.reloadData()
                self?.updateUi()
            }
            present(addIncomeVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfIncomes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeCell", for: indexPath)
        let income = viewModel.income(at: indexPath.row)
        
        cell.textLabel?.text = income.name
        cell.detailTextLabel?.text = String(format: "$%.2f", income.cost!)
        
        return cell
    }
}