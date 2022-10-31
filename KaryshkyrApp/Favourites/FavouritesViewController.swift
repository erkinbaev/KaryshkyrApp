//
//  FavouritesViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/14/22.
//

import Foundation
import UIKit
import RealmSwift

protocol FavouritesView: AnyObject {
    func reloadTableView()
    
    func editTableView(selectedIndexs: [IndexPath])
    
    func presentAlert(alert: UIAlertController)
    
    func cellTap(at index: Int)
}

class FavouritesViewController: UIViewController {
    
//    var image: String = "chevron_right"
//
//    var isEnabled: Bool = false
//
//    let realm = try! Realm()
//
//    var slangs: Results<Slang>?
//
//    var counter = 0
    
    private var presenter: FavouritesPresenter!
    
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
        
        self.presenter = FavouritesPresenter(view: self)
        view.backgroundColor = .white
        setupSubviews()
        presenter.getFavourites()
        presenter.fillTableView()
        presenter.observeEditingActions()
        
       // slangs = realm.objects(Slang.self)
       // print(slangs!)
        presenter.dismissDescriptionView(selector: #selector(reloadCell))
    }
    
    @objc func reloadCell() {
        if let test = favouritesTableView.indexPathForSelectedRow {
            let cell = favouritesTableView.cellForRow(at: test) as! SlangCell
            cell.descriptionImageView.image = UIImage(named: "chevron_right")
            favouritesTableView.reloadRows(at: [test], with: .automatic)
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if presenter.reversedFavourites.count != 0 {
            return presenter.reversedFavourites.count
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
        //cell.slangLabel.text = presenter.slangs?.reversed()[indexPath.row].title
        cell.slangLabel.text = presenter.reversedFavourites[indexPath.row]
        if presenter.isEnabled == true {
            cell.selectionStyle = .none
        }
        cell.descriptionImageView.image = UIImage(named: presenter.image)
        cell.descriptionImageView.isUserInteractionEnabled = presenter.isEnabled
        cell.currentIndexPath = indexPath
        return cell
    }

}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if presenter.isEnabled != true {
            let cell = favouritesTableView.cellForRow(at: indexPath) as! SlangCell
            cell.contentView.backgroundColor = .white
            cell.descriptionImageView.image = UIImage(named: "chevron_down")
            cellTap(at: indexPath.row)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle(rawValue: 3) ?? .delete
    }
}

extension FavouritesViewController: FavouritesView {
    func reloadTableView() {
        favouritesTableView.reloadData()
    }
    
    func editTableView(selectedIndexs: [IndexPath]) {
        favouritesTableView.beginUpdates()
        favouritesTableView.deleteRows(at: selectedIndexs, with: .automatic)
        favouritesTableView.endUpdates()
    }
    
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func cellTap(at index: Int) {
        let slangDescriptionViewController = SlangDescriptionViewController()
        if let sheet = slangDescriptionViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .none
            
        }
        slangDescriptionViewController.slangTitleLabel.text = presenter.reversedFavourites[index]
        //slangDescriptionViewController.slangDescriptionLabel.text = presenter.filteredResults[index].description
        slangDescriptionViewController.addToFavouritesImageView.isHidden = true
        present(slangDescriptionViewController, animated: true, completion: nil)
    }
    
}
