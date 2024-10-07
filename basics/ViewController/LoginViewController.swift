//
//  ViewController.swift
//  basics
//
//  Created by Linus Widing on 02.10.24.
//

import UIKit

class LoginViewController: UIViewController {
    
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let signupStackView  = UIStackView()
    let myView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupMyView(padding: 20.0)
        setupLoginButton()
        setupPasswordTextField()
        setupUsernameTextField()
        setupSignupStackView()
        
    }
    
    func setupSignupStackView(){
        myView.addSubview(signupStackView)
        signupStackView.translatesAutoresizingMaskIntoConstraints = false
        
        signupStackView.axis = .vertical
        signupStackView.distribution = .fillEqually
        signupStackView.spacing = 5
        signupStackView.alignment = .center
        
        let signUpLabel = UILabel()
        signUpLabel.text = "Not signed up yet?"
        signUpLabel.textAlignment = .center
        
        let signUpButton = UIButton()
        signUpButton.configuration = .plain()
        signUpButton.configuration?.title = "Sign Up"
        
        
        signupStackView.addArrangedSubview(signUpLabel)
        signupStackView.addArrangedSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signupStackView.leadingAnchor.constraint(equalTo: myView.leadingAnchor),
            signupStackView.trailingAnchor.constraint(equalTo: myView.trailingAnchor),
            signupStackView.bottomAnchor.constraint(equalTo: myView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func setupPasswordTextField(){
        myView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: myView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: myView.trailingAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupUsernameTextField(){
        myView.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "Username"
        usernameTextField.autocapitalizationType = .none
        
        NSLayoutConstraint.activate([
            usernameTextField.leadingAnchor.constraint(equalTo: myView.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: myView.trailingAnchor),
            usernameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -10),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    func setupMyView(padding: CGFloat = 0){
        view.addSubview(myView)
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            myView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            myView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding)
        ])
        
    }
    
    func setupLoginButton(){
        myView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.configuration = .borderedProminent()
        loginButton.configuration?.baseBackgroundColor = .systemBlue
        loginButton.configuration?.title = "Login"
        
        loginButton.addAction(UIAction{_ in
            buttonPressed()
        }, for: .primaryActionTriggered)
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: myView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: myView.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: myView.safeAreaLayoutGuide.topAnchor, constant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        func buttonPressed() {
            guard let username=usernameTextField.text, let password=passwordTextField.text else{
                present(UIUtil.getAlert(message: "Enter credentials!"), animated: true)
                return
            }
            print("Username: \(username), Password: \(password)")
            
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.center = myView.center
            spinner.startAnimating()
            myView.addSubview(spinner)
            
            loginButton.isEnabled = false
            
            Task {
                do {
                    let tokenResponse = try await APIService.shared.login(username: username, password: password)
                    print("Login successful: \(tokenResponse.access_token)")
                    
                    let nextScreen = TodosViewController()
                    self.navigationController?.setViewControllers([nextScreen], animated: true)
                } catch {
                    print("Login failed: \(error.localizedDescription)")
                    present(UIUtil.getAlert(message: error.localizedDescription), animated: true)
                }
                
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                self.loginButton.isEnabled = true
            }
        }
    }
}

