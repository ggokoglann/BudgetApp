//
//  BudgetView.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class BudgetView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var budgetShownLabel: UILabel!
    @IBOutlet weak var assetsTableView: UITableView!
    
    let expenseModel = ExpenseViewModel.shared
    let incomeModel = IncomeViewModel.shared
    let budgetModel = BudgetViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assetsTableView.delegate = self
        assetsTableView.dataSource = self
        budgetModel.addToAssets()
        updateUi()
    }
    
    @IBAction func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
                UIView.animate(withDuration: 0.3, animations: {
                    // Apply a scaling and opacity animation
                    self.budgetShownLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.budgetShownLabel.alpha = 0.5
                    self.assetsTableView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.assetsTableView.alpha = 0.5
                }, completion: { _ in
                    // Perform the update or data fetch here
                    self.updateUiAndReloadTableView()

                    // Reset the label's state after the animation
                    UIView.animate(withDuration: 0.3, animations: {
                        self.budgetShownLabel.transform = .identity
                        self.budgetShownLabel.alpha = 1.0
                        self.assetsTableView.transform = .identity
                        self.assetsTableView.alpha = 1.0
                    })
                })
            }
    }
    
    func updateUi() {
        budgetShownLabel.text = budgetModel.mainBudgetString
        budgetModel.recalculateAssets()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetModel.numberOfAssets()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetCell", for: indexPath)
        let assets = budgetModel.asset(at: indexPath.row)
        
        cell.textLabel?.text = assets.name
        cell.detailTextLabel?.text = String(format: "$%.2f", assets.cost!)
        
        return cell
    }
    
    func updateUiAndReloadTableView() {
        DispatchQueue.main.async {
            self.updateUi()
            self.assetsTableView.reloadData()
        }
    }
}
