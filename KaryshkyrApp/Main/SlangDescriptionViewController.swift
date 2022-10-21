//
//  SlangDescriptionViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/17/22.
//

import Foundation
import UIKit

class SlangDescriptionViewController: UIViewController {

   lazy var slangTitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = UIColor.rgb(red: 2, green: 126, blue: 216)
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    lazy var addToFavouritesImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var slangDescriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        
        
    }
    
    func setupSubviews() {
        view.addSubview(addToFavouritesImageView)
        addToFavouritesImageView.translatesAutoresizingMaskIntoConstraints = false
        addToFavouritesImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.65).isActive = true
        addToFavouritesImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -29).isActive = true
        addToFavouritesImageView.heightAnchor.constraint(equalToConstant: 18.35).isActive = true
        addToFavouritesImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(slangTitleLabel)
        slangTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        slangTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        slangTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        slangTitleLabel.rightAnchor.constraint(equalTo: addToFavouritesImageView.leftAnchor, constant: 45).isActive = true
        
        view.addSubview(slangDescriptionLabel)
        slangDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        slangDescriptionLabel.topAnchor.constraint(equalTo: slangTitleLabel.bottomAnchor, constant: 20).isActive = true
        slangDescriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        slangDescriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -27).isActive = true
    }
    
}


