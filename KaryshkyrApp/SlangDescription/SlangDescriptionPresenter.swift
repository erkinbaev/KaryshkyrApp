//
//  SlangDescriptionPresenter.swift
//  KaryshkyrApp
//
//  Created by User on 11/6/22.
//

import Foundation
import RealmSwift

protocol SlangDescriptionPresenterDelegate: AnyObject {
    init(view: SlangDescriptionView)
    
    func addToFavourites(title: String, description: String)
    
    func dismissMessagesForAnotherViews()
}

class SlangDescriptionPresenter: SlangDescriptionPresenterDelegate{
    
    public weak var view: SlangDescriptionView!
    
    private var counter = 0
    
    private let realm = try! Realm()
    
    private var slangs: Results<Slang>?
    
    private let nc = NotificationCenter.default
    
    required init(view: SlangDescriptionView) {
        self.view = view
    }
    
    func addToFavourites(title: String, description: String) {
        if counter == 0 {
            view.favouriteImageStatus()
            counter += 1
            
            let slang = Slang()
            slang.title = title
            slang.slangDescription = description
            
            try! realm.write({
                realm.add(slang)
               
            })
            
            nc.post(name: Notification.Name("addedToFavorites"), object: nil)
            DispatchQueue.main.async {
                self.view.showToast()
            }
            
        } else {
            DispatchQueue.main.async {
                self.view.unFavouriteImageStatus()
            }
            counter = 0
            
        }
    }
    
    func dismissMessagesForAnotherViews() {
        nc.post(name: Notification.Name("dismissedAtList"), object: nil)
        nc.post(name: Notification.Name("dismissedAtFavList"), object: nil)
    }
    
}
