//
//  MainViewPresenter.swift
//  KaryshkyrApp
//
//  Created by User on 10/24/22.
//

import Foundation
import UIKit

protocol MainViewPresenterDelegate: AnyObject {
    init(view: MainView)
    
    func updateRightBarOnFavourites()
    
    func updateRightBarOnSlangList()
    
    func updateFavouriteViewWhenRightItemTapped()
    
}

class MainViewPresenter: MainViewPresenterDelegate {
    
    public var view: MainView!
    
    let nc = NotificationCenter.default
    
    
    private var counter = 0
    
    required init(view: MainView) {
        self.view = view
    }
    
    func updateRightBarOnFavourites() {
        DispatchQueue.main.async {
            self.view.clickFavourites()
        }
    }
    
    func updateRightBarOnSlangList() {
        DispatchQueue.main.async {
            self.view.clickSlangList()
        }
    }
    
    
    func updateFavouriteViewWhenRightItemTapped() {
        if counter == 0 {
            DispatchQueue.main.async {
                self.view.editButtonTap()
            }
            counter += 1
        } else {
            DispatchQueue.main.async {
                self.view.deleteButtonTap()
            }
            counter = 0
        }
        
    }
    

}
