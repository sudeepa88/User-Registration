//
//  EditVC.swift
//  TestApp
//
//  Created by Sudeepa Pal on 06/05/24.
//

import UIKit
import RealmSwift
import CryptoKit

class EditVC: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    public var completionHandler: (() -> Void)?
    public var deletionHandler: (() -> Void)?
    var contactDetails : People?
    // MARK: - Properties
    let accountNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Edit Account name"
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
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    var accountName = ""
    var accountEmailID = ""
    var passwordIS = ""
    
     var deleteAccount = ""
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        accountNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        print("Edit is Here: ", accountName)
        print("Edit is Here: ", passwordIS)
        
        accountNameTextField.text = accountName
        emailTextField.text = accountEmailID
        passwordTextField.text = passwordIS
        
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(accountNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
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
            
            editButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -200),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            deleteButton.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -190),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalTo: editButton.widthAnchor)
            
        ])
    } //setupUI
    
    @objc func editButtonTapped() {
        
        
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
        
        guard let password = passwordTextField.text else {
                return
            }
        
        let hashedPassword = sha256(password: password)
        print("This is user Password (SHA-256 hashed)->", hashedPassword)
        
        print("Previous Value :", accountName)
        print("Present Value :", accountNameTextField.text!)


        
        guard let existingContact = realm.objects(People.self).filter("accountName = %@", accountName).first else {
            print("Contact with account name \(accountName) not found.")
            return
        }
        
        do {
            try realm.write {
                existingContact.accountName = accountNameTextField.text!
                existingContact.emailID = emailTextField.text!
                existingContact.passWord = hashedPassword
            }
            print("Contact updated successfully!")
        } catch {
            print("Error updating contact: \(error)")
        }
        
        completionHandler?()
        
        dismiss(animated: true, completion: nil)
        
    }// Edit button
    
    
    @objc func deleteButtonTapped() {
        
        guard let deleteContact = contactDetails else {
            print("There is something wrong")
        return
        }
        print("Here is the deleted Contact: ",deleteContact)
       
        realm.beginWrite()
        realm.delete(deleteContact)
        try! realm.commitWrite()
        
        do {
            try realm.write {
                
            }
            print("Contact updated successfully!")
        } catch {
            print("Error updating contact: \(error)")
        }
       
        deletionHandler?()
        
        dismiss(animated: true, completion: nil)

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
