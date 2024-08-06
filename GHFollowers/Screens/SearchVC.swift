//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Mardon Mashrabov on 05/08/2024.
//

import UIKit

class SearchVC: UIViewController {
    private let logo = UIImageView()
    private let usernameTextField = GFTextField()
    private let ctaButton = GFButton(backgroundColor: .systemGreen, text: "Get Followers")
    
    private var isUsernameEntered: Bool {
        if let username = usernameTextField.text {
            return !username.isEmpty
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogo()
        configureTextField()
        configureCTAButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func pushUsernameToFollowersListVC() {
        guard isUsernameEntered else {
            let alertController = UIAlertController(title: "Empty username", message: "You must enter a username to find their followers", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle OK button tap
            }

            alertController.addAction(okAction)

            present(alertController, animated: true, completion: nil)
            return
        }
        
        let followersListVC = FollowersListVC()
        followersListVC.username = usernameTextField.text
        followersListVC.title = usernameTextField.text
        navigationController?.pushViewController(followersListVC, animated: true)
    }
    
    
    func configureLogo() {
        view.addSubview(logo)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 200),
            logo.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureCTAButton() {
        view.addSubview(ctaButton)
        ctaButton.addTarget(self, action: #selector(pushUsernameToFollowersListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            ctaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            ctaButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            ctaButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            ctaButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
}
