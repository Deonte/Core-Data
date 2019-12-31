//
//  CompaniesController.swift
//  CoreData Training
//
//  Created by Deonte on 12/25/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelgate {
    func didEditCompany(company: Company) {
        let row = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .fade)
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    let cellID = "cellID"
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCompanies()
        
        setupTableView()
        setupNaviagationBar()
    }
    
    func fetchCompanies() {
        // Initialization of CoreData Stack
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach { (company) in
                print(company.name ?? "")
            }
            
            self.companies = companies
            self.tableView.reloadData()
        } catch let fetchErr{
            print("Failed to fetch companies:", fetchErr)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let company = self.companies[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, _) in
           
            print("Attempting to delete company:", company.name ?? "")
            
            // Remove the company from the tableView
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Delete the company from CoreData
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            
            // Without this the deletion of the object will not persist.
            do {
                try context.save()
            } catch let saveError {
                print("Failed to delete company:", saveError)
            }
            
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, view, _) in
            print("Editing company:", company.name ?? "")
            let editCompanyController = CreateCompanyController()
            editCompanyController.delegate = self
            editCompanyController.company = self.companies[indexPath.row]
            let navController = CustomNavigationController(rootViewController: editCompanyController)
            self.present(navController, animated: true, completion: nil)
        }
        
        deleteAction.backgroundColor = .lightRed
        editAction.backgroundColor = .darkBlue
       
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
   
    
    func setupNaviagationBar() {
        setupNavigationStyle(title: "Companies")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    func setupTableView() {
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }
    
    @objc func handleAddCompany() {
        print("Adding Company")
        let createCompanyController = CreateCompanyController()
        let navController = UINavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let company = companies[indexPath.row]
        
        if let name = company.name, let founded = company.founded {
            
            //MMM dd, yyyy
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            let foundedDateString = dateFormatter.string(from: founded)
//            let locale = Locale(identifier: "EN")
        
            let dateString = "\(name) - Founded: \(foundedDateString)"
            cell.textLabel?.text = dateString
        } else {
            cell.textLabel?.text = company.name
        }
        
        cell.backgroundColor = .teal
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

#if DEBUG
struct CompanyControllerPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<CompanyControllerPreview.ContainerView>) -> UIViewController {
            return CustomNavigationController(rootViewController: CompaniesController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CompanyControllerPreview.ContainerView>) {
        }
    }
}
#endif
