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
    
    func createCustomNavigatioBar() {
      // let colors = Colors()
        navigationController?.navigationBar.backgroundColor = UIColor.rgb(red: 121, green: 195, blue: 249)
        
//        navigationController?.navigationBar.backgroundColor = UIColor.clear
//        let backgroundLayer = colors.gl
//        backgroundLayer?.frame = (navigationController?.navigationBar.frame)!
//        navigationController?.navigationBar.layer.insertSublayer(backgroundLayer!, at: 4)
//
//        navigationController?.navigationBar.layer.insertSublayer(backgroundLayer!, at: 0)
        
        
    }
    
    func setupClearNavBar() {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.barTintColor = .clear
            navigationController?.navigationBar.isTranslucent = true
        }
        
    func setupGradient(height: CGFloat, topColor: CGColor, bottomColor: CGColor) ->  CAGradientLayer {
             let gradient: CAGradientLayer = CAGradientLayer()
             gradient.colors = [topColor,bottomColor]
             gradient.locations = [0.0 , 1.0]
             gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
             gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
             gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: height)
             return gradient
    }
//    func createCustomTitleView(image: String, title: String, selector: Selector) -> UIView {
//        let view = UIView()
//        view.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: selector)
//        view.addGestureRecognizer(tap)
//        view.frame = CGRect(x: 50, y: 0, width: 160, height: 27)
//
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: image)
//        imageView.layer.cornerRadius = imageView.frame.height / 2
//        imageView.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
//        view.addSubview(imageView)
//
//        let titleLabel = UILabel()
//        titleLabel.text = title
//        titleLabel.frame = CGRect(x: 33, y: 10, width: 141, height: 15)
//        view.addSubview(titleLabel)
//
//        return view
//
//    }
    
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
        titleLabel.font = UIFont.systemFont(ofSize: 22)
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
    
    func createCustomBarImage(image: String) -> UIBarButtonItem {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
        
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

class Colors {
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor(red: 121 / 255.0, green: 195 / 255.0, blue: 249 / 255.0, alpha: 1.0).cgColor
        //let colorBottom = UIColor(red: 121 / 255.0, green: 195 / 255.0, blue: 249 / 255.0, alpha: 0.5).cgColor
        let colorBottom = UIColor.white.cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}

extension UIView {
    func createGradientBlur(view: UIView) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor.clear.withAlphaComponent(0).cgColor,
                UIColor.black.withAlphaComponent(0.5).cgColor
            ]
            let effectView = UIVisualEffectView()
            effectView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.size.height)
            gradientLayer.frame = effectView.bounds
            gradientLayer.locations = [0, 1]
            effectView.autoresizingMask = [.flexibleHeight]
            effectView.layer.mask = gradientLayer
            effectView.backgroundColor = UIColor.init(named: "#3530FA")
            effectView.isUserInteractionEnabled = false //Use this to pass touches under this blur effect
            effectView.clipsToBounds = true
            addSubview(effectView)
    }
    
}


