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
        slangListViewController.title = "Список"
        favouritesViewController.title = "Избранное"
        slangListViewController.tabBarItem.image = UIImage(systemName: "list.bullet.circle")
        favouritesViewController.tabBarItem.image = UIImage(systemName: "heart")
        slangListViewController.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.circle.fill")
        favouritesViewController.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        
        self.setViewControllers([slangListViewController, favouritesViewController], animated: false)
       
        let tabBar = tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.rgb(red: 2, green: 126, blue: 216), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 1.0)
     
        setupSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        tabBar.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
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
        }
        
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
