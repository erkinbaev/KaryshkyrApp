//
//  FavouritesViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/14/22.
//

import Foundation
import UIKit
import RealmSwift

class FavouritesViewController: UIViewController {
    
    let nc = NotificationCenter.default
    
    var image: String = "chevron_right"
    
    let realm = try! Realm()
    
    var slangs: Results<Slang>?
    
    var colors = Colors()
    
    var selectedCells: [IndexPath] = []
    
    var counter = 0
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        return view
    }()
    
    private lazy var favouritesLabel: UILabel = {
        let view = UILabel()
        view.text = "Вот твои любимые слова"
        view.font = UIFont.systemFont(ofSize: 20)
        return view
    }()
   
    lazy var favouritesTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        view.delegate = self
        view.dataSource = self
        view.register(SlangCell.self, forCellReuseIdentifier: "test_cell")
        return view
    }()
    
    var gradient : CAGradientLayer?
       let gradientView : UIView = {
           let view = UIView()
           return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSubviews()
        slangs = realm.objects(Slang.self)
        nc.addObserver(self, selector: #selector(deleteRows), name: Notification.Name("delete"), object: nil)
    }
    
    @objc func deleteRows() {
        for i in selectedCells {
                try! realm.write({
                        realm.delete(slangs![i.row])
                        favouritesTableView.reloadData()
                })
        }
        //favouritesTableView.deleteRows(at: [selectedCells], with: .automatic)
        favouritesTableView.deleteRows(at: selectedCells, with: .automatic)
        favouritesTableView.reloadData()
    }
    
    
    func setupSubviews() {
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (tabBarController?.tabBar.frame.height)!).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
     
        contentView.addSubview(favouritesLabel)
        favouritesLabel.translatesAutoresizingMaskIntoConstraints = false
        favouritesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 34).isActive = true
        favouritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        
        contentView.addSubview(favouritesTableView)
        favouritesTableView.translatesAutoresizingMaskIntoConstraints = false
        favouritesTableView.topAnchor.constraint(equalTo: favouritesLabel.bottomAnchor, constant: 0).isActive = true
        favouritesTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        favouritesTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        favouritesTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
}


extension FavouritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if slangs?.count != 0 {
            return slangs?.count ?? 0
        }
        return 0
        
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 31)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test_cell", for: indexPath) as! SlangCell
        cell.slangLabel.text = slangs?[indexPath.row].title
        cell.descriptionImageView.image = UIImage(named: image)
        return cell
    }

}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCells.append(indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            for i in selectedCells {
//                try! realm.write({
//                    realm.delete(slangs![i.row])
//                    favouritesTableView.reloadData()
//                })
//            }
//            tableView.deleteRows(at: selectedCells, with: .automatic)
//        }
    }
}

class Favourites: Object {
   let favourites = List<Slang>()
}


