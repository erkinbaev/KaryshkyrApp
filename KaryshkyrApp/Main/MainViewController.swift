//
//  MainViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/19/22.
//

import Foundation
import UIKit

protocol MainView: AnyObject {
    
    func clickFavourites()
    
    func clickSlangList()
    
    func presentViewController(viewController: UIViewController)
    
    func editButtonTap()
    
    func deleteButtonTap()

}

class MainViewController: UITabBarController {
    
    
    let slangListViewController = SlangListViewController()
    let favouritesViewController = FavouritesViewController()
    
    private var presenter: MainViewPresenter!
    
    private lazy var navBarSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 158, green: 158, blue: 155)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupSubviews()
        self.presenter = MainViewPresenter(view: self)
       
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        
          if gesture.direction == .left {
              self.selectedIndex += 1
              presenter.updateRightBarOnFavourites()
          } else if gesture.direction == .right {
              self.selectedIndex -= 1
              presenter.updateRightBarOnSlangList()
          }
    }
    
    override func viewWillLayoutSubviews() {
        tabBar.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
    }
    
    func setupSubviews() {
        title = "Главный"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Light", size: 22)!]
        
        slangListViewController.tabBarItem.image = UIImage(named: "list_text")
        favouritesViewController.tabBarItem.image = UIImage(named: "fav_text")
        tabBar.tintColor = .black
      
        slangListViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        favouritesViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        self.setViewControllers([slangListViewController, favouritesViewController], animated: false)
       
        let tabBar = tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.rgb(red: 2, green: 126, blue: 216), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 1.0)
        
        let leftBatItem = createCustomView()
        navigationItem.leftBarButtonItem = leftBatItem
        
        view.addSubview(navBarSeparator)
        navBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        navBarSeparator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        navBarSeparator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        navBarSeparator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        navBarSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
        
        super.viewDidLayoutSubviews()
    }
    
    @objc func tapRightBarItem() {
        presenter.updateFavouriteViewWhenRightItemTapped()
    }
    
}

extension MainViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == favouritesViewController {
            presenter.updateRightBarOnFavourites()
            favouritesViewController.updateView()
            favouritesViewController.favouritesTableView.reloadData()
            
        } else {
            presenter.updateRightBarOnSlangList()
            slangListViewController.slangsTableView.reloadData()
        }
    }
}

extension MainViewController: MainView {
    
    func editButtonTap() {
        presenter.nc.post(name: Notification.Name("edit"), object: nil)
        favouritesViewController.favouritesTableView.reloadData()
        let editBarButton = createCustomBarButton(image: "delete", selector: #selector(tapRightBarItem))
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    func deleteButtonTap() {
        presenter.nc.post(name: Notification.Name("stop_edit"), object: nil)
        let editBarButton = createCustomBarButton(image: "edit", selector: #selector(tapRightBarItem))
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    func clickFavourites() {
        let rightBarItem = createCustomBarButton(image: "edit", selector: #selector(tapRightBarItem))
        navigationItem.rightBarButtonItem = rightBarItem
        favouritesViewController.favouritesTableView.reloadData()
    }
    
    func clickSlangList() {
        let rightBarItem = createCustomView()
        navigationItem.rightBarButtonItem = rightBarItem
        slangListViewController.slangsTableView.reloadData()
    }
    
    func presentViewController(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
}




