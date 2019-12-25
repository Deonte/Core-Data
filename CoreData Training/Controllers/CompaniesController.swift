//
//  CompaniesController.swift
//  CoreData Training
//
//  Created by Deonte on 12/25/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit
import SwiftUI

class CompaniesController: UITableViewController {
    let cellID = "cellID"
    
    let companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Amazon", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Facebook", founded: Date())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNaviagationBar()
       
    }
    
    func setupNaviagationBar() {
        setupNavigationStyle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.rightBarButtonItem?.tintColor = .white
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
        present(createCompanyController, animated: true, completion: nil)
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
        
        cell.backgroundColor = .teal
        cell.textLabel?.text = company.name
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
