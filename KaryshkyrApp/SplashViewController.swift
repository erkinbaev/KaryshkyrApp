//
//  SplashViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/24/22.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "launch")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var wolfImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wolf_logo")
        return view
    }()
    
    private lazy var brandLabel: UILabel = {
        let view = UILabel()
        view.text = "Made by GeekStudio"
        view.textColor = .white
        view.font = UIFont(name: "RobotoLight", size: 19)
        view.numberOfLines = 1
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        imageDownAnimation()
    }
    
    func setupSubviews() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        view.addSubview(brandLabel)
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        brandLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        brandLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        brandLabel.widthAnchor.constraint(equalToConstant: 165).isActive = true
    }
    
    func imageDownAnimation() {
        view.addSubview(wolfImageView)
        wolfImageView.frame = CGRect(x: view.frame.midX, y: -300, width: 73, height: 69)
        
        UIView.animate(withDuration: 1.38, animations:  {
            self.wolfImageView.center = self.view.center
        
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 1.5, animations:  {
                    self.wolfImageView.frame = CGRect(x: self.view.frame.midX - (183 / 2), y: self.view.frame.midY - (100 + (173 / 2)), width: 183, height: 173)
                
                }, completion: { done in
                    if done {
                        UIView.animate(withDuration: 1.5, animations: {
                            //self.wolfImageView.alpha = 0
                            self.presentingMainViewAnimation()
                        })
                    }
                })
                
            }
        })
    }
    
    func presentingMainViewAnimation() {
        UIView.animate(withDuration: 1.5, animations: {
            self.wolfImageView.alpha = 0
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    let mainViewController = MainViewController()
                    mainViewController.modalTransitionStyle = .crossDissolve
                    mainViewController.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(mainViewController, animated: false)
                })
            }
        })
    }
    
}
