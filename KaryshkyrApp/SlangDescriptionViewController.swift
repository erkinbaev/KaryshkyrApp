//
//  SlangDescriptionViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/17/22.
//

import Foundation
import UIKit
import RealmSwift
import Toast_Swift

class SlangDescriptionViewController: UIViewController {
    
    let nc = NotificationCenter.default
    
    
    var counter = 0
    
    let realm = try! Realm()
    
    var slangs: Results<Slang>?
    
    let favouritesViewController = FavouritesViewController()
    
    let mainViewController = MainViewController()
    
    let slangListViewController = SlangListViewController()

   lazy var slangTitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
       view.textAlignment = .justified
        view.textColor = UIColor.rgb(red: 2, green: 126, blue: 216)
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    lazy var addToFavouritesImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "fav")
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(addToFavouritesTap))
        view.addGestureRecognizer(tap)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        nc.post(name: Notification.Name("dis"), object: nil)
        nc.post(name: Notification.Name("dis2"), object: nil)
        print("dismissed")
    }
    
    @objc func addToFavouritesTap() {
        if counter == 0 {
            addToFavouritesImageView.image = UIImage(named: "fav_fill")
            counter += 1
            
           // let favorites = realm.objects(Favourites.self).first
            
            let slang = Slang()
            slang.title = slangTitleLabel.text!
            
            try! realm.write({
                realm.add(slang)
                //favorites?.favourites.insert(slang, at: 0)
            })
            
            nc.post(name: Notification.Name("addedToFavorites"), object: nil)
            self.view.makeToast("Добавлено в избранное", duration: 2.0, position: .bottom)
            
        } else {
            addToFavouritesImageView.image = UIImage(named: "fav")
            counter = 0
            let slang = Slang()
            slang.title = slangTitleLabel.text!
            
//            for index in 0..<slangs!.count {
//                if slangs![index].title == slang.title {
//                    try! realm.write({
//                        realm.delete(slang)
//                    })
//                }
//            }
            
        }
        
      
       
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
        slangTitleLabel.widthAnchor.constraint(equalToConstant: 298).isActive = true
        
        view.addSubview(slangDescriptionLabel)
        slangDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        slangDescriptionLabel.topAnchor.constraint(equalTo: slangTitleLabel.bottomAnchor, constant: 20).isActive = true
        slangDescriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        slangDescriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -27).isActive = true
    }
    
}

class Slang: Object {
    @objc dynamic var title = ""
}

class Favourites: Object {
   let favourites = List<Slang>()
}

