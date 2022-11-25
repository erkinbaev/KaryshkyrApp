//
//  FavouritesPresenter.swift
//  KaryshkyrApp
//
//  Created by User on 10/26/22.
//

import Foundation
import RealmSwift

protocol FavouritesPresenterDelegate: AnyObject {
    init(view: FavouritesView)
    
    func getFavourites()
    
    func observeEditingActions()
    
    func dismissDescriptionView(selector: Selector, viewController: UIViewController)
}


class FavouritesPresenter: FavouritesPresenterDelegate {
    
    private let nc = NotificationCenter.default
    
    var image: String = "chevron_right"
    
    var isEnabled: Bool = false
    
    private let realm = try! Realm()
    
    private var slangs: Results<Slang>?
    
    var slangsToRemove: [Slang] = []
    
    private var counter = 0
    
    
    var favourites: [FavouriteModel] = []
    
    var reversedFavourites: [FavouriteModel] = []
    
    public weak var view: FavouritesView!
    
    required init(view: FavouritesView) {
        self.view = view
    }
    
    func getFavourites() {
        self.slangs = realm.objects(Slang.self)
    }
    
    func observeEditingActions() {
        self.nc.addObserver(self, selector: #selector(startEditing), name: Notification.Name("edit"), object: nil)
        self.nc.addObserver(self, selector: #selector(stopEditing), name: Notification.Name("stop_edit"), object: nil)
      
    }
    
    @objc func startEditing() {
        image = "box"
        isEnabled = true
    }
    
    @objc func stopEditing() {
        image = "chevron_right"
        isEnabled = false
        
        if view.selectRows().indexPathsForSelectedRows?.count ?? 0 > 0 {
            let alert = UIAlertController(title: "Удаление!", message: "Ты уверен?", preferredStyle: .alert)
            
            let noAction = UIAlertAction(title: "НЕТ", style: .cancel) { action in
                ()
            }
            
            let yesAction = UIAlertAction(title: "УВЕРЕН", style: .default) { action in
                self.view.removeData()
            }
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            
            self.view.presentAlert(alert: alert)
        } else if view.selectRows().indexPathsForSelectedRows == nil {
            let alert = UIAlertController(title: "Нечего удалять!", message: "Поставь сначала галочки.", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "ОК", style: .cancel) { action in
                self.image = "chevron_right"
                self.view.reloadTableView()
            }
            alert.addAction(yesAction)
            
            self.view.presentAlert(alert: alert)
        }
        
        
    }
    
    func fillTableView() {
        for i in 0..<slangs!.count {
            let favourite = FavouriteModel(title: slangs![i].title, description: slangs![i].slangDescription)
            favourites.append(favourite)
        }
        reversedFavourites = favourites.reversed()
    }
    
    func removeFromData() {
        for slang in slangsToRemove {
            try! self.realm.write({
                self.realm.delete(realm.objects(Slang.self).filter("title=%@",slang.title))
            })
        }
    }
    
    func dismissDescriptionView(selector: Selector, viewController: UIViewController) {
        nc.addObserver(viewController.self, selector: selector, name: Notification.Name("dismissedAtFavList"), object: nil)
    }

    
}
