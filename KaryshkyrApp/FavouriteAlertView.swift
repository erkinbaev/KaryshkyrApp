//
//  FavouriteAlertView.swift
//  KaryshkyrApp
//
//  Created by User on 10/22/22.
//

import Foundation
import UIKit

protocol CustomAlertDelegate {
        func alertPresentation()
    
}

class FavouriteAlertController: UIViewController {
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.text = "Добавлено в избранное"
        view.textAlignment = .left
        view.numberOfLines = 1
        view.textColor = .black
        return view
    }()
    

    var delegate: CustomAlertDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        setupSubviews()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
       // view.backgroundColor = UIColor.black.withAlphaComponent(0.05)
       
    }
    
    func animateView() {
        alertView.alpha = 0
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 0
        UIView.animate(withDuration: 0.0) {
            self.alertView.alpha = 1
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 0
            self.alertView.backgroundColor = .white
        }
    }
    
    func setupSubviews() {
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 42).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        alertView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 16).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: alertView.centerYAnchor, constant: 0).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -8).isActive = true
        
    }
}
