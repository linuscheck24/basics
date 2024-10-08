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
    let contentArea = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        contentArea.addToSafeArea(to: view, padding: 20)
        
        setupLoginButton()
        setupPasswordTextField()
        setupUsernameTextField()
        setupSignupStackView()
        
    }
    
    func setupSignupStackView(){
        contentArea.addSubview(signupStackView)
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
            signupStackView.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            signupStackView.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            signupStackView.bottomAnchor.constraint(equalTo: contentArea.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func setupPasswordTextField(){
        contentArea.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupUsernameTextField(){
        contentArea.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "Username"
        usernameTextField.autocapitalizationType = .none
        
        NSLayoutConstraint.activate([
            usernameTextField.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            usernameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -10),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    func setupLoginButton(){
        contentArea.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.configuration = .borderedProminent()
        loginButton.configuration?.baseBackgroundColor = .systemBlue
        loginButton.configuration?.title = "Login"
        
        loginButton.addAction(UIAction{_ in
            buttonPressed()
        }, for: .primaryActionTriggered)
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: contentArea.safeAreaLayoutGuide.topAnchor, constant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        func buttonPressed() {
            guard let username=usernameTextField.text, let password=passwordTextField.text else{
                present(UIUtil.getAlert(message: "Enter credentials!"), animated: true)
                return
            }
            print("Username: \(username), Password: \(password)")
            
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.center = contentArea.center
            spinner.startAnimating()
            contentArea.addSubview(spinner)
            
            loginButton.isEnabled = false
            
            Task {
                do {
                    let tokenResponse = try await APIService.shared.login(username: username, password: password)
                    print("Login successful: \(tokenResponse.access_token)")
                    
                    let nextScreen = TodosViewController()
                    nextScreen.viewModel = TodosViewModel()
                    self.navigationController?.setViewControllers([nextScreen], animated: true)
                } catch let apiError as APIServiceError{
                    print("Login failed: \(apiError.localizedDescription)")
                    switch apiError{
                    case .unauthorized:
                        present(UIUtil.getAlert(message: "Invalid username or password!"), animated: true)
                    case .invalidResponse:
                        present(UIUtil.getAlert(message: "Error: \(apiError.localizedDescription)"), animated: true)
                    case .invalidURL:
                        present(UIUtil.getAlert(message: "Invalid URL!"), animated: true)
                    }
                }
                
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                self.loginButton.isEnabled = true
            }
        }
    }
}

