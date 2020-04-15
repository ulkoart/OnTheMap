//
//  ViewController.swift
//  OnTheMap
//
//  Created by user on 12.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUI()
    }
    
    @IBAction func singUpButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        loginLoader(true)
        
        UdacityClient.login(username: username, password: password, completionHandler: self.handlerLoginResponse(result:error:))
    }
    
    func configUI() -> Void {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.text = ""
        passwordTextField.text = ""
        loginLoader(false)
        
    }
    
    func loginLoader(_ state: Bool) {
        usernameTextField.isEnabled = !state
        passwordTextField.isEnabled = !state
        loginButton.isHidden = state
        loginActivityIndicator.isHidden = !state
//        loginActivityIndicator.stopAnimating()
    }
    
    func handlerLoginResponse(result: Bool?, error: Error?) -> Void {
        if let result = result {
            if result {
                performSegue(withIdentifier: "completeLogin", sender: nil)
            } else {
                loginLoader(false)
                showLoginFailure(message: error?.localizedDescription ?? "")
                
            }
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

