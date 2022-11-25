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
    
    private var isFavourite: Bool = false
    
    private let realm = try! Realm()
    
    private var slangs: Results<Slang>?
    
    private let nc = NotificationCenter.default
    
    required init(view: SlangDescriptionView) {
        self.view = view
    }
    
    func addToFavourites(title: String, description: String) {
        
        let slang = Slang()
        slang.title = title
        slang.slangDescription = description

        if isFavourite == false {
            view.favouriteImageStatus()
            isFavourite = true
            
            try! realm.write({
                realm.add(slang)
            })
            
            view.showToast(title: "Добавлено в избранные")
            
        } else if isFavourite == true {
            
            try! self.realm.write({
                self.realm.delete(realm.objects(Slang.self).filter("title=%@",slang.title))
            })
            
            view.unFavouriteImageStatus()
            
            view.showToast(title: "Удалено с избранных")
            
            isFavourite = false
        }
    }
    
    func isFavouriteCheck(title: String) {
        self.slangs = realm.objects(Slang.self)
        for slang in slangs! {
            if slang.title == title {
                isFavourite = true
                break
            } else if slang.title != title {
                isFavourite = false
            }
        }
        
        if isFavourite == true {
            view.favouriteImageStatus()
        } else {
            view.unFavouriteImageStatus()
        }
    }
    
    func dismissMessagesForAnotherViews() {
        nc.post(name: Notification.Name("dismissedAtList"), object: nil)
        nc.post(name: Notification.Name("dismissedAtFavList"), object: nil)
    }
    
}
