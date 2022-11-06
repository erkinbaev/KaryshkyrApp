//
//  SlangCell.swift
//  KaryshkyrApp
//
//  Created by User on 10/14/22.
//

import Foundation
import UIKit

class SlangCell: UITableViewCell {
    
    lazy var slangLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Roboto-Light", size: 16)
        view.textColor = .black
        return view
    }()
    
    lazy var descriptionImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "chevron_right")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var underLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 158, green: 155, blue: 155)
        return view
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

             if selected {
             } else {
                 contentView.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
             }
    }
    
    
    override func layoutSubviews() {
       backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        
        addSubview(slangLabel)
        slangLabel.translatesAutoresizingMaskIntoConstraints = false
        slangLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        slangLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 28).isActive = true
        slangLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        addSubview(descriptionImageView)
        descriptionImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -22.88).isActive = true
        descriptionImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        descriptionImageView.widthAnchor.constraint(equalToConstant: 15.81).isActive = true
        descriptionImageView.heightAnchor.constraint(equalToConstant: 15.81).isActive = true
        
        addSubview(underLine)
        underLine.translatesAutoresizingMaskIntoConstraints = false
        underLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        underLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 21).isActive = true
        underLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -21).isActive = true
        underLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    
}
