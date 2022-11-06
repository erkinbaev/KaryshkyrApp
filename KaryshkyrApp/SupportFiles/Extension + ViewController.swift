//
//  Extension + ViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/16/22.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


extension UIViewController {
    
    func createCustomButton(image: String, title: String, selector: Selector) -> UIBarButtonItem {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 160, height: 27)

        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .center
        let tap = UITapGestureRecognizer(target: self, action: selector)
        imageView.addGestureRecognizer(tap)
        view.addSubview(imageView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.frame = CGRect(x: 42, y: 0, width: 195, height: 25.78)
        titleLabel.font = UIFont(name: "Roboto-Light", size: 22)
        titleLabel.textColor = .black
        view.addSubview(titleLabel)

        let menuBarButtonItem = UIBarButtonItem(customView: view)
        return menuBarButtonItem
    }
    
    func createCustomBarButton(image: String, selector: Selector) -> UIBarButtonItem {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: selector)
        imageView.tintColor = .black
        imageView.addGestureRecognizer(tap)
        
        let menuBarButtonItem = UIBarButtonItem(customView: imageView)
        
        return menuBarButtonItem
    }
    
    func createCustomView() -> UIBarButtonItem {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 27)
        let menuBarButtonItem = UIBarButtonItem(customView: view)
        return menuBarButtonItem
    }
}




