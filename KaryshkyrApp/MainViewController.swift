//
//  MainViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/19/22.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    
    var counter = 0
    let nc = NotificationCenter.default
    
    let alert = FavoriteViewController()
    
    let slangListViewController = SlangListViewController()
    let favouritesViewController = FavouritesViewController()
    
    private lazy var navBarSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 158, green: 158, blue: 155)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        title = "Главный"
        //slangListViewController.title = "Список"
        //favouritesViewController.title = "Избранное"
        slangListViewController.tabBarItem.image = UIImage(named: "list_text")
        favouritesViewController.tabBarItem.image = UIImage(named: "fav_text")
        tabBar.tintColor = .black
        //slangListViewController.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.circle.fill")
       // favouritesViewController.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        slangListViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        favouritesViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        self.setViewControllers([slangListViewController, favouritesViewController], animated: false)
       
        let tabBar = tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.rgb(red: 2, green: 126, blue: 216), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 1.0)
     
        setupSubviews()
        
//        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("UserLoggedIn"), object: nil)
//        nc.addObserver(self, selector: #selector(dismissTest), name: Notification.Name("dismissed"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        tabBar.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
    }
    
    func setupSubviews() {
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
    
    @objc func test() {
        
        if counter == 0 {
            favouritesViewController.image = "box"
            favouritesViewController.favouritesTableView.reloadData()
            let editBarButton = createCustomBarButton(image: "delete", selector: #selector(test))
            navigationItem.rightBarButtonItem = editBarButton
            counter += 1
        } else {
            favouritesViewController.image = "chevron_right"
            favouritesViewController.favouritesTableView.reloadData()
            let editBarButton = createCustomBarButton(image: "edit", selector: #selector(test))
            navigationItem.rightBarButtonItem = editBarButton
            counter = 0
            nc.post(name: Notification.Name("delete"), object: nil)
            
            
        }
        
    }
    
    @objc func userLoggedIn() {
        title = ""
        scanButtonTapped()
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
         
         // alert.dismiss(animated: true, completion: nil)
            self.alert.dismissAlert()
            self.title = "Главный"
        }
    }
    
    @objc func dismissTest() {
        alert.dismissAlert()
        
    }
    
}

extension MainViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        ()
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == favouritesViewController {
            let editBarButton = createCustomBarButton(image: "edit", selector: #selector(test))
            navigationItem.rightBarButtonItem = editBarButton
            favouritesViewController.favouritesTableView.reloadData()
        } else {
            let rightBarItem = createCustomView()
            navigationItem.rightBarButtonItem = rightBarItem
        }
    }
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: size.height - lineWidth, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension MainViewController: CustomAlertDelegate {
    func scanButtonTapped() {
        //let alert = FavoriteViewController()
        alert.delegate = self
        alert.modalPresentationStyle = .overCurrentContext
        alert.providesPresentationContextTransitionStyle = true
        alert.definesPresentationContext = true
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: true, completion: nil)
        
       
    }
    
    
    
    
}


