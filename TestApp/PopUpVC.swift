//
//  PopUpVC.swift
//  TestApp
//
//  Created by Sudeepa Pal on 02/05/24.
//

import UIKit
import RealmSwift
import CryptoKit


class PopUpVC: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    public var completionHandler: (() -> Void)?
    // MARK: - Properties
    let accountNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Account name"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add New Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 35
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        accountNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(accountNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            accountNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            accountNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accountNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            accountNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: accountNameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - Button Action
    @objc private func submitButtonTapped() {
        // Handle submit button tapped event
        
        
        // Check if any field is empty
            if accountNameTextField.text?.isEmpty ?? true {
                displayWarning(message: "Please enter account name")
                return
            }
            
            if emailTextField.text?.isEmpty ?? true {
                displayWarning(message: "Please enter email address")
                return
            }
            
            if passwordTextField.text?.isEmpty ?? true {
                displayWarning(message: "Please enter password")
                return
            }
        
        print("This is user Account Name->",accountNameTextField.text!)
        print("This is user Email Address->", emailTextField.text!)
        print("This is user Password->", passwordTextField.text!)
        
        guard let password = passwordTextField.text else {
                return
            }
            
            let hashedPassword = sha256(password: password)
            print("This is user Password (SHA-256 hashed)->", hashedPassword)
        
        
        // CRUD : Create
                let person = People()
                person.accountName = accountNameTextField.text!
                person.emailID = emailTextField.text!
                person.passWord = hashedPassword
        
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(person)
                    }
                } catch {
                    print("Error Inilization new realm, \(error)")
                }
        

        
        completionHandler?()
        
        accountNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        
        dismiss(animated: true, completion: nil)
        // tableView.reloadData()
    }
    
    private func sha256(password: String) -> String {
        let inputData = Data(password.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashedString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashedString
    }
    
    private func displayWarning(message: String){
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = .red
        present(alert, animated: true, completion: nil)
    }
    
}
