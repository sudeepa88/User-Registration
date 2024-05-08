//
//  ViewController.swift
//  TestApp
//
//  Created by Sudeepa Pal on 02/05/24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var patients: [String] = ["Sudeepa", "Google","Netflix", "Swiggy" ]
    var humanBeings: [String] = []
    private var people = [People]()
    let realm = try! Realm()
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(addUserButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Password Manager"
        
        people = realm.objects(People.self).map({$0})
        
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        view.addSubview(addButton)
        setupTableView()
        
    }
    
    
    
    
    func setupTableView() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -67),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func addUserButtonTapped() {
        //tableView.reloadData()
        
        let userDetailsViewController = PopUpVC()
        userDetailsViewController.completionHandler = {
            [weak self] in
            self?.refresh()
        }
        
        if let sheet = userDetailsViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(userDetailsViewController, animated: false, completion: nil)
        
        tableView.reloadData()
    }
    
    
    func refresh(){
        people = realm.objects(People.self).map({$0})
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //print("Here is numberOfRowsInSection ->", people.count)
        return people.count
        //return humanBeings.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.reloadData()
        let userDetailsViewController = EditVC()
        let item = people[indexPath.row]
        userDetailsViewController.contactDetails = item
        userDetailsViewController.accountName = people[indexPath.row].accountName
        userDetailsViewController.accountEmailID  = people[indexPath.row].emailID
        userDetailsViewController.passwordIS = people[indexPath.row].passWord
        
       // userDetailsViewController.deleteAccount = people?[indexPath.row]
        userDetailsViewController.deletionHandler = {
        [weak self] in
        self?.refresh()
        }
        
        if let sheet = userDetailsViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(userDetailsViewController, animated: false, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountTableViewCell
        
        //cell.textLabel?.text = people[indexPath.row].accountName
        cell.nameLabel.text = people[indexPath.row].accountName

        cell.emailLabel.text = "*********"
        cell.containerView.layer.cornerRadius = 30
       // tableView.reloadData()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

