//
//  SlangAddViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/16/22.
//

import Foundation
import UIKit

protocol SlangAddView: AnyObject {
    //func addSlangTap()
}

class SlangAddViewController: UIViewController {
    
    private var presenter: SlangAddPresenter!
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        return view
    }()
    
    private lazy var enterTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Введите слово:"
        return view
    }()
    
    private lazy var starLabelOne: UILabel = {
        let view = UILabel()
        view.text = "*"
        view.textColor = .red
        return view
    }()
    
    private lazy var slangTitleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Input"
        return view
    }()
    
    private lazy var titleUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 28, green: 27, blue: 31)
        return view
    }()
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        return view
    }()
    
    private lazy var enterDescriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "Введите пояснение:"
        return view
    }()
    
    private lazy var starLabelTwo: UILabel = {
        let view = UILabel()
        view.text = "*"
        view.textColor = .red
        return view
    }()
    
    private lazy var slangDescriptionTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        return view
    }()
    
    private lazy var descriptionUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 28, green: 27, blue: 31)
        return view
    }()
    
    private lazy var descriptionCharactersAmountLabel: UILabel = {
        let view = UILabel()
        view.text = "0/1000"
        view.textAlignment = .right
        view.textColor = UIColor.rgb(red: 158, green: 158, blue: 155)
        return view
    }()
    
    private lazy var contactView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        return view
    }()
    
    private lazy var enterContactLabel: UILabel = {
        let view = UILabel()
        view.text = "Введите контактные данные:"
        return view
    }()
    
    private lazy var contactTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Input"
        return view
    }()
    
    private lazy var contactUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 28, green: 27, blue: 31)
        return view
    }()
    
    private lazy var saveSlangButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Добавить", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor.rgb(red: 218, green: 218, blue: 218)
        view.layer.cornerRadius = 8
        view.addTarget(self, action: #selector(saveSlangTap), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        setupSubviews()
        presenter = SlangAddPresenter(view: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func saveSlangTap() {
        presenter.postRequest(title: slangTitleTextField.text!, description: slangDescriptionTextView.text!, contact: contactTextField.text!, is_verified: false)
    }
    
    @objc func backToMainTap() {
        self.navigationController?.pushViewController(MainViewController(), animated: false)
    }
    
    func setupSubviews() {
        
        let leftButtonItem = createCustomButton(image: "arrow_back", title: "Добавление слова", selector: #selector(backToMainTap))
        
        navigationItem.leftBarButtonItem = leftButtonItem
        
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 141).isActive = true
        titleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        titleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        titleView.addSubview(enterTitleLabel)
        enterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        enterTitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 8).isActive = true
        enterTitleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 16).isActive = true
        enterTitleLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        titleView.addSubview(starLabelOne)
        starLabelOne.translatesAutoresizingMaskIntoConstraints = false
        starLabelOne.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 8).isActive = true
        starLabelOne.leadingAnchor.constraint(equalTo: enterTitleLabel.trailingAnchor, constant: 4).isActive = true
        
        titleView.addSubview(slangTitleTextField)
        slangTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        slangTitleTextField.topAnchor.constraint(equalTo: enterTitleLabel.bottomAnchor, constant: 0).isActive = true
        slangTitleTextField.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 16).isActive = true
        slangTitleTextField.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -16).isActive = true
        slangTitleTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        titleView.addSubview(titleUnderline)
        titleUnderline.translatesAutoresizingMaskIntoConstraints = false
        titleUnderline.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 0).isActive = true
        titleUnderline.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: 0).isActive = true
        titleUnderline.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0).isActive = true
        titleUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24).isActive = true
        descriptionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        descriptionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        descriptionView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        
        descriptionView.addSubview(enterDescriptionLabel)
        enterDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        enterDescriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 8).isActive = true
        enterDescriptionLabel.leftAnchor.constraint(equalTo: descriptionView.leftAnchor, constant: 16).isActive = true
        enterDescriptionLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        descriptionView.addSubview(starLabelTwo)
        starLabelTwo.translatesAutoresizingMaskIntoConstraints = false
        starLabelTwo.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 8).isActive = true
        starLabelTwo.leadingAnchor.constraint(equalTo: enterDescriptionLabel.trailingAnchor, constant: 4).isActive = true
        
        descriptionView.addSubview(slangDescriptionTextView)
        slangDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        slangDescriptionTextView.topAnchor.constraint(equalTo: enterDescriptionLabel.bottomAnchor, constant: 0).isActive = true
        slangDescriptionTextView.leftAnchor.constraint(equalTo: descriptionView.leftAnchor, constant: 16).isActive = true
        slangDescriptionTextView.rightAnchor.constraint(equalTo: descriptionView.rightAnchor, constant: -16).isActive = true
        slangDescriptionTextView.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -8).isActive = true
        
        descriptionView.addSubview(descriptionUnderline)
        descriptionUnderline.translatesAutoresizingMaskIntoConstraints = false
        descriptionUnderline.leftAnchor.constraint(equalTo: descriptionView.leftAnchor, constant: 0).isActive = true
        descriptionUnderline.rightAnchor.constraint(equalTo: descriptionView.rightAnchor, constant: 0).isActive = true
        descriptionUnderline.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 0).isActive = true
        descriptionUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(descriptionCharactersAmountLabel)
        descriptionCharactersAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionCharactersAmountLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 8).isActive = true
        descriptionCharactersAmountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        descriptionCharactersAmountLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        view.addSubview(contactView)
        contactView.translatesAutoresizingMaskIntoConstraints = false
        contactView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 40).isActive = true
        contactView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        contactView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        contactView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        contactView.addSubview(enterContactLabel)
        enterContactLabel.translatesAutoresizingMaskIntoConstraints = false
        enterContactLabel.topAnchor.constraint(equalTo: contactView.topAnchor, constant: 8).isActive = true
        enterContactLabel.leftAnchor.constraint(equalTo: contactView.leftAnchor, constant: 16).isActive = true
        enterContactLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        contactView.addSubview(contactTextField)
        contactTextField.translatesAutoresizingMaskIntoConstraints = false
        contactTextField.topAnchor.constraint(equalTo: enterContactLabel.bottomAnchor, constant: 0).isActive = true
        contactTextField.leftAnchor.constraint(equalTo: contactView.leftAnchor, constant: 16).isActive = true
        contactTextField.rightAnchor.constraint(equalTo: contactView.rightAnchor, constant: -16).isActive = true
        contactTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contactView.addSubview(contactUnderline)
        contactUnderline.translatesAutoresizingMaskIntoConstraints = false
        contactUnderline.leftAnchor.constraint(equalTo: contactView.leftAnchor, constant: 0).isActive = true
        contactUnderline.rightAnchor.constraint(equalTo: contactView.rightAnchor, constant: 0).isActive = true
        contactUnderline.bottomAnchor.constraint(equalTo: contactView.bottomAnchor, constant: 0).isActive = true
        contactUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(saveSlangButton)
        saveSlangButton.translatesAutoresizingMaskIntoConstraints = false
        saveSlangButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true
        saveSlangButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        saveSlangButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        saveSlangButton.heightAnchor.constraint(equalToConstant: 53).isActive = true
    }
    
}

extension SlangAddViewController: SlangAddView {
    
    
}
