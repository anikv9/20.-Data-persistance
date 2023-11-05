//
//  ViewController.swift
//  pleasepleasework
//
//  Created by ani kvitsiani on 05.11.23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(mainStackView)
        mainStackView.frame = self.view.bounds
        
        setupMainStackViewConstraints()
        //        mainStackView.addArrangedSubview(signinLabel)
        mainStackView.addArrangedSubview(usernameTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(signInButton)
        
        setupFieldConstraints()
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        
        
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 16
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    //    private let signinLabel: UILabel = {
    //        let label = UILabel()
    //        label.text = "Sign In"
    //        label.textColor = .black
    //        label.textAlignment = .center
    //        label.font = UIFont.systemFont(ofSize: 28)
    //        return label
    //    }()
    
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.placeholder = "username"
        textField.textColor = .black
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.backgroundColor = .white
        textField.text = "password"
        textField.textColor = .black
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue
        
        return button
    }()
    
    
    private func setupMainStackViewConstraints(){
        mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        //        mainStackView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 140).isActive = true
        
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setupFieldConstraints(){
        usernameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 16).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: mainStackView.frame.size.width).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16).isActive = true
        
        
        
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: mainStackView.frame.size.width).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 16+30+16).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16).isActive = true
        
        
        signInButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 46).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: mainStackView.frame.size.width).isActive = true
        signInButton.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 16+30+16+30+16).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16).isActive = true
        
        
        
    }
    
    @objc func signInButtonTapped() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !password.isEmpty else {
            
            let alert = UIAlertController(title: "Missing Information", message: "Please enter both username and password.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        
    }
    
    enum KeyChainErrors: Error {
        case sameItemFound
        case unknown
        case noSuchDataFound
    }
    
    func saveCredentials(
        username: String,
        password: String
    )  throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "YourAppKeychainService",
            kSecAttrAccount as String: username as AnyObject,
            kSecValueData as String: password as AnyObject
        ]
        
        
        let status = SecItemAdd(query as CFDictionary, nil) //whether the item was saved or not
        
        if status != errSecDuplicateItem {
            throw KeyChainErrors.sameItemFound
        }
        
    }
    
    
    func validateCredentials(
        username: String,
        password: String) -> Bool {
            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrService as String: "YourAppKeychainService",
                kSecAttrAccount as String: username,
                kSecReturnData as String: true
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            if status == errSecSuccess,
               let keychainItem = item as? [String: Any],
               let storedPasswordData = keychainItem[kSecValueData as String] as? Data,
               let storedPassword = String(data: storedPasswordData, encoding: .utf8) {
                return password == storedPassword
            }
            
            return false
        }
    
    func login(username: String, password: String) {
        if validateCredentials(username: username, password: password) {
            let userDefaults = UserDefaults.standard
            if !userDefaults.bool(forKey: "hasLoggedBefore") {
                userDefaults.set(true, forKey: "hasLoggedBefore")
                userDefaults.synchronize()
                
                let alert = UIAlertController(title: "Welcome!", message: "This is your first login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            print("Invalid username or password")
        }
    }
    
}





