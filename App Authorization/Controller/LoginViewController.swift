//
//  LoginViewController.swift
//  App Authorization
//
//  Created by Mike on 12/19/18.
//  Copyright © 2018 William Nau. All rights reserved.
//

import UIKit

/**
 * Controls the login view
 */
class LoginViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorNotifLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorNotifLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    // MARK: Local variables
    private var hasError = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clear()
    }
    
    // MARK: - Functions
    
    // MARK: Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        performLogin()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toRegisterVC", sender: self)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        clear()
    }
    
    // MARK: Helper functions
    private func performLogin() {
        hasError = false
        let email = Validate.isEmpty(text: emailTextField.text)
        let password = Validate.isEmpty(text: passwordTextField.text)
        if let _ = email.error { hasError = true }
        displayError(textField: emailTextField, exlamationLabel: emailErrorNotifLabel, errorLabel: emailErrorLabel, error: email.error, type: "Email address")
        if let _ = password.error { hasError = true }
        displayError(textField: passwordTextField, exlamationLabel: passwordErrorNotifLabel, errorLabel: passwordErrorLabel, error: password.error, type: "Password")
        if hasError { return }
        guard let emailAddress = email.data else { return }
        guard let pwd = password.data else { return }
        // MARK - TODO: Try to login through database
        print(emailAddress, pwd)
    }

    private func clear() {
        displayError(textField: emailTextField, exlamationLabel: emailErrorNotifLabel, errorLabel: emailErrorLabel, error: nil, type: "Email address")
        emailTextField.text = ""
        displayError(textField: passwordTextField, exlamationLabel: passwordErrorNotifLabel, errorLabel: passwordErrorLabel, error: nil, type: "Password")
        passwordTextField.text = ""
        hasError = false
    }
    
    private func displayError(textField: UITextField, exlamationLabel: UILabel, errorLabel: UILabel, error: String?, type: String) {
        var isHidden: Bool
        if let err = error , err != "" {
            errorLabel.text = "\(type) \(err)"
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 4
            isHidden = false
        } else {
            errorLabel.text = ""
            textField.layer.borderWidth = 0
            isHidden = true
        }
        exlamationLabel.isHidden = isHidden
        errorLabel.isHidden = isHidden
        if type == "Password" {
            passwordTextField.isSecureTextEntry = isHidden
        }
    }
}

// MARK: - Extensions

// MARK: Extends UITextFieldDelegate Protocols
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            textField.resignFirstResponder()
            performLogin()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
}
