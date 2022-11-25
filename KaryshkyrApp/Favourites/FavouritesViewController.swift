//
//  FavouritesViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/14/22.
//

import Foundation
import UIKit
import RealmSwift
import Toast_Swift

protocol FavouritesView: AnyObject {
    func reloadTableView()
    
    func editTableView(selectedIndexs: [IndexPath])
    
    func presentAlert(alert: UIAlertController)
    
    func cellTap(at index: Int)
    
    func showToast()
    
    func selectRows() -> UITableView
    
    func removeData()
}

class FavouritesViewController: UIViewController {
    
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
        view.textColor = .black
        return view
    }()
   
    lazy var favouritesTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        view.delegate = self
        view.dataSource = self
        view.register(SlangCell.self, forCellReuseIdentifier: "test_cell")
        view.allowsMultipleSelection = true
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
       
        setupSubviews()
        //updateView()
        presenter.observeEditingActions()
        presenter.dismissDescriptionView(selector: #selector(reloadCell), viewController: self)
    }
    
    func updateView(){
        presenter.favourites.removeAll()
        presenter.reversedFavourites.removeAll()
        presenter.getFavourites()
        presenter.fillTableView()
        favouritesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
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
        
        cell.slangLabel.text = presenter.reversedFavourites[indexPath.row].title
        if presenter.isEnabled == true {
            cell.selectionStyle = .none
        }
        cell.descriptionImageView.image = UIImage(named: presenter.image)
        cell.descriptionImageView.isUserInteractionEnabled = presenter.isEnabled
       
        return cell
    }

}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = favouritesTableView.cellForRow(at: indexPath) as! SlangCell
        if presenter.isEnabled != true {
            cell.contentView.backgroundColor = .white
            cell.descriptionImageView.image = UIImage(named: "chevron_down")
            cellTap(at: indexPath.row)
        } else {
            cell.descriptionImageView.image = UIImage(named: "checkmark")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = favouritesTableView.cellForRow(at: indexPath) as! SlangCell
        cell.descriptionImageView.image = UIImage(named: "box")
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
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .none
            
        }
        slangDescriptionViewController.slangTitleLabel.text = presenter.reversedFavourites[index].title
        slangDescriptionViewController.slangDescriptionLabel.text = presenter.reversedFavourites[index].description
        slangDescriptionViewController.addToFavouritesImageView.isHidden = true
        present(slangDescriptionViewController, animated: true, completion: nil)
    }
    
    func showToast() {
        self.view.makeToast("Cленги удалены", duration: 2.0, position: .bottom)
    }
    
    func selectRows() -> UITableView {
        return favouritesTableView
    }
    
    func removeData() {
        if let selectedRows = favouritesTableView.indexPathsForSelectedRows {
                   // 1
                    
                   var items = [FavouriteModel]()
                   for indexPath in selectedRows  {
                       items.append(presenter.reversedFavourites[indexPath.row])
                       let slang = Slang()
                       slang.title = presenter.reversedFavourites[indexPath.row].title
                       slang.slangDescription = presenter.reversedFavourites[indexPath.row].description
                       presenter.slangsToRemove.append(slang)
                   }
                   // 2
                   for item in items {
                       if let index = presenter.reversedFavourites.firstIndex(of: item) {
                           presenter.reversedFavourites.remove(at: index)
                       }
                   }
                   // 3
            presenter.removeFromData()

        favouritesTableView.beginUpdates()
            
            favouritesTableView.deleteRows(at: selectedRows, with: .fade)
        favouritesTableView.endUpdates()
        favouritesTableView.reloadData()
            
        showToast()
        } else {
            
        }
    }
    
}
