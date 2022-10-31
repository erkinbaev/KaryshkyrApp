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
    
    func removeFromFavourites()
    
    func dismissDescriptionView(selector: Selector)
}


class FavouritesPresenter: FavouritesPresenterDelegate {
    
    let nc = NotificationCenter.default
    
    var image: String = "chevron_right"
    
    var isEnabled: Bool = false
    
    let realm = try! Realm()
    
    var slangs: Results<Slang>?
    
    var counter = 0
    
    var multiBoxSelection = MultiBoxSelection.singleTone
    
    var favourites: [String] = []
    
    var reversedFavourites: [String] = []
    
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
        
        if multiBoxSelection.selectedIndexs.count > 0 {
            let alert = UIAlertController(title: "Удаление!", message: "Ты уверен?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "УВЕРЕН", style: .cancel) { action in
                self.removeFromFavourites()
            }
            
            let noAction = UIAlertAction(title: "НЕТ", style: .default) { action in
                ()
            }
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.view.presentAlert(alert: alert)
        } else {
            let alert = UIAlertController(title: "Нечего удалять!", message: "Поставь сначала галочки.", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "ОК", style: .cancel) { action in
                ()
            }
            alert.addAction(yesAction)
            
            self.view.presentAlert(alert: alert)
        }
        
        
    }
    
    func removeFromFavourites() {
        let selectedRows = multiBoxSelection.selectedIndexs
        var items = [String]()
        var slangs: [Slang] = []
        for indexPath in selectedRows  {
            items.append(reversedFavourites[indexPath.row])
            let slang = Slang()
            slang.title = reversedFavourites[indexPath.row]
            slangs.append(slang)
        }
        // 2
        for item in items {
            if let index = reversedFavourites.firstIndex(of: item) {
                reversedFavourites.remove(at: index)
            }
        }
        
        for slang in slangs {
            
                try! self.realm.write({
                    self.realm.delete(realm.objects(Slang.self).filter("title=%@",slang.title))
                })
            
        }
        print(selectedRows)
        print(reversedFavourites)
        view.editTableView(selectedIndexs: selectedRows)
        
        multiBoxSelection.clearIndexs()
        
        view.reloadTableView()
        
        
        
    }
    
    func fillTableView() {
        for i in 0..<slangs!.count {
            favourites.append(slangs![i].title)
        }
        reversedFavourites = favourites.reversed()
    }
    
    func dismissDescriptionView(selector: Selector) {
        nc.addObserver(view.self!, selector: selector, name: Notification.Name("dis2"), object: nil)
    }
    
    
}
