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
    
    func observeAlertActions()
    
    func dismissAlertController()
    
    func updateFavouriteViewWhenRightItemTapped()
    
}

class MainViewPresenter: MainViewPresenterDelegate, CustomAlertDelegate {
    
    public var view: MainView!
    
    let nc = NotificationCenter.default
    
    private let alert = FavouriteAlertController()
    
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
    
    func observeAlertActions() {
        DispatchQueue.main.async {
            self.view.observeFavouriteClick(notificationCenter: self.nc)
        }
    }
    
    func alertPresentation() {
                alert.delegate = self
                alert.modalPresentationStyle = .overCurrentContext
                alert.providesPresentationContextTransitionStyle = true
                alert.definesPresentationContext = true
                alert.modalTransitionStyle = .crossDissolve

        DispatchQueue.main.async {
            self.view.changeTitleValue(with: "")
            self.view.presentViewController(viewController: self.alert)
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when){
                self.dismissAlertController()
                self.view.changeTitleValue(with: "Главный")  // nil
            }
        }
        
        
    }
    
    func dismissAlertController() {
        DispatchQueue.main.async {
            self.alert.dismissAlert()
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
