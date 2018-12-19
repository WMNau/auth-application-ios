//
//  RegisterViewController.swift
//  App Authorization
//
//  Created by Mike on 12/19/18.
//  Copyright © 2018 William Nau. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorNotifLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var confirmEmailErrorNotifLabel: UILabel!
    @IBOutlet weak var confirmEmailErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorNotifLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorNotifLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    private let acceptedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*_"
    private let minPasswordLength = 6
    private let maxPasswordLength = 14
    private let rules = 1
    private var hasError = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clear()
    }
    
    @IBAction func generatePasswordPressed(_ sender: Any) {
        do {
            let randomPW = try RandomPasswordGenerator(minLength: minPasswordLength, maxLength: maxPasswordLength, acceptedCharacters: acceptedCharacters, uppercase: rules, lowercase: rules, numeric: rules, specialCharacter: rules)
            let password = randomPW.getPassword()
            passwordTextField.isSecureTextEntry = false
            passwordTextField.text = password
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        performRegister()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        clear()
    }
    
    private func performRegister() {
        hasError = false
        let email = Validate.isEmpty(text: emailTextField.text)
        let confirmEmail = Validate.isEmpty(text: confirmEmailTextField.text)
        let password = Validate.isEmpty(text: passwordTextField.text)
        let confirmPassword = Validate.isEmpty(text: confirmPasswordTextField.text)
        if let _ = email.error { hasError = true }
        displayError(textField: emailTextField, exlamationLabel: emailErrorNotifLabel, errorLabel: emailErrorLabel, error: email.error, type: "Email address")
        if let _ = confirmEmail.error { hasError = true }
        displayError(textField: confirmEmailTextField, exlamationLabel: confirmEmailErrorNotifLabel, errorLabel: confirmEmailErrorLabel, error: confirmEmail.error, type: "Confirm email address")
        if let _ = password.error { hasError = true }
        displayError(textField: passwordTextField, exlamationLabel: passwordErrorNotifLabel, errorLabel: passwordErrorLabel, error: password.error, type: "Password")
        
        if let _ = confirmPassword.error { hasError = true }
        displayError(textField: confirmPasswordTextField, exlamationLabel: confirmPasswordErrorNotifLabel, errorLabel: confirmPasswordErrorLabel, error: confirmPassword.error, type: "Confirm password")
        if hasError { return }
        guard let emailAddress = email.data else { return }
        guard let confirmEmailAddress = confirmEmail.data else { return }
        guard let pwd = password.data else { return }
        guard let confirmPwd = confirmPassword.data else { return }
        if emailAddress.lowercased() != confirmEmailAddress.lowercased() {
            displayError(textField: emailTextField, exlamationLabel: emailErrorNotifLabel, errorLabel: emailErrorLabel, error: "does not match the confirm email address.", type: "Email Address")
            hasError = true
        }
        if pwd != confirmPwd {
            displayError(textField: passwordTextField, exlamationLabel: passwordErrorNotifLabel, errorLabel: passwordErrorLabel, error: "does not match the confirm password.", type: "Password")
            hasError = true
        }
        if hasError { return }
        // MARK - TODO: Try to register through database
        print(emailAddress, confirmEmailAddress, pwd, confirmPwd)
    }
    
    private func clear() {
        displayError(textField: emailTextField, exlamationLabel: emailErrorNotifLabel, errorLabel: emailErrorLabel, error: nil, type: "Email address")
        emailTextField.text = ""
        displayError(textField: confirmEmailTextField, exlamationLabel: confirmEmailErrorNotifLabel, errorLabel: confirmEmailErrorLabel, error: nil, type: "Confirm email address")
        confirmEmailTextField.text = ""
        displayError(textField: passwordTextField, exlamationLabel: passwordErrorNotifLabel, errorLabel: passwordErrorLabel, error: nil, type: "Password")
        passwordTextField.text = ""
        passwordTextField.isSecureTextEntry = true
        hasError = false
        displayError(textField: confirmPasswordTextField, exlamationLabel: confirmPasswordErrorNotifLabel, errorLabel: confirmPasswordErrorLabel, error: nil, type: "Password")
        confirmPasswordTextField.text = ""
        confirmPasswordTextField.isSecureTextEntry = true
        hasError = false
    }
    
    private func displayError(textField: UITextField, exlamationLabel: UILabel, errorLabel: UILabel, error: String?, type: String) {
        var isHidden: Bool
        if let err = error , err != "" {
            errorLabel.text = "* \(type) \(err)"
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
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            textField.resignFirstResponder()
            confirmEmailTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            textField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField.tag == 3 {
            textField.resignFirstResponder()
            performRegister()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
}
