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
    
    let budgetModel = BudgetViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        budgetModel.addToAssets()
        updateUi()
    }
    
    func setupTableView() {
        assetsTableView.delegate = self
        assetsTableView.dataSource = self
    }
    
    func updateUi() {
        let currentMonth = budgetModel.getCurrentMonth()
        budgetLabel.text = "\(currentMonth)"
        let total = budgetModel.mainBudgetDouble
        budgetShownLabel.text = "$ \(total)"
        
        if total < 0 {
            budgetShownLabel.textColor = UIColor(red: 0.91, green: 0.314, blue: 0.227, alpha: 1)
        } else if total > 0 {
            budgetShownLabel.textColor = UIColor(red: 0.039, green: 0.698, blue: 0.49, alpha: 1)
        } else {
            budgetShownLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        budgetModel.recalculateAssets()
        budgetModel.updateMonthlyData()
    }
    
    @IBAction func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
                budgetModel.updateMonthlyData() // Update the data
                UIView.animate(withDuration: 0.3, animations: {
                    self.budgetShownLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.budgetShownLabel.alpha = 0.5
                    self.assetsTableView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.assetsTableView.alpha = 0.5
                }, completion: { _ in
                    self.resetUIAnimation()
                    self.updateUiAndReloadTableView()
                })
            }
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetModel.numberOfAssets()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetCell", for: indexPath)
            let assets = budgetModel.asset(at: indexPath.row)

            let currentMonth = budgetModel.getCurrentMonth()
            let monthlyTotalIncome = budgetModel.getMonthlyTotalIncome(for: currentMonth)
            let monthlyTotalExpense = budgetModel.getMonthlyTotalExpense(for: currentMonth)
            let monthlyDifference = budgetModel.getMonthlyDifference(for: currentMonth)

            if indexPath.row == 0 {
                cell.textLabel?.text = "Total Income"
                cell.detailTextLabel?.text = String(format: "$%.2f", monthlyTotalIncome)
                cell.detailTextLabel?.textColor = UIColor(red: 0.039, green: 0.698, blue: 0.49, alpha: 1)
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Total Expense"
                cell.detailTextLabel?.text = String(format: "$%.2f", monthlyTotalExpense)
                cell.detailTextLabel?.textColor = UIColor(red: 0.91, green: 0.314, blue: 0.227, alpha: 1)
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Difference"
                cell.detailTextLabel?.text = String(format: "$%.2f", monthlyDifference)
            } else {
                cell.textLabel?.text = assets.name
                cell.detailTextLabel?.text = String(format: "$%.2f", assets.cost!)
            }
        return cell
    }
    
    func resetUIAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.budgetShownLabel.transform = .identity
            self.budgetShownLabel.alpha = 1.0
            self.assetsTableView.transform = .identity
            self.assetsTableView.alpha = 1.0
        })
    }

    func updateUiAndReloadTableView() {
        DispatchQueue.main.async {
            self.updateUi()
            self.assetsTableView.reloadData()
        }
    }
}
