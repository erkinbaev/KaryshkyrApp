//
//  ViewController.swift
//  KaryshkyrApp
//
//  Created by User on 10/14/22.
//

import UIKit

protocol SlangListView: AnyObject {
    func cellTap(at index: Int)
    
    func navigate(viewController: UIViewController)
    
    func updateSlangList()
    
    func dismissKeyboardWhenSearchDidFinish()
    
    func refreshing()
    
    func endRefreshing()
    
    func showAlert(alert: UIAlertController)
    
    func hideSearchImage(searchBar: UISearchBar)
    
    func unhideSearchImage(searchBar: UISearchBar)
    
    func reciveWords(words: [WordModel])
    
    func reciveErrorMessage(message: String?)
    
    
}

class SlangListViewController: UIViewController, UIGestureRecognizerDelegate {
   
    private var presenter: SlangListPresenter!
    
    private var lastContentOffset: CGFloat = 0
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        return view
    }()
    
    private lazy var slangSearchBar: UISearchBar = {
        let view = UISearchBar()
        view.searchBarStyle = .default
        view.isTranslucent = false
        view.barStyle = .default
        view.searchTextField.backgroundColor = .clear
        view.searchTextField.leftView?.tintColor = UIColor.rgb(red: 37, green: 37, blue: 37)
        view.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Поиск по словам", attributes: [NSAttributedString.Key.foregroundColor:UIColor.rgb(red: 37, green: 37, blue: 37)])
        view.tintColor = UIColor.rgb(red: 2, green: 126, blue: 216)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        view.setImage(UIImage(named: "close"), for: .clear, state: .normal)
        view.setImage(UIImage(named: "search"), for: .search, state: .normal)
        view.delegate = self
        view.searchTextField.delegate = self
        view.searchTextField.addTarget(self, action: #selector(dismissKeyBoard), for: .editingChanged)
        return view
    }()
    
    private lazy var noSlangsLabel: UILabel = {
        let view = UILabel()
        view.text = "По запросу ничего не найдено"
        view.font = UIFont(name: "Roboto-Light", size: 16)
        view.textColor = .black
        return view
    }()
    
    lazy var slangsTableView: UITableView = {
        let view = UITableView()
        view.register(SlangCell.self, forCellReuseIdentifier: "slang_cell")
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var addSlangView: HighlightView = {
        let view = HighlightView()
        view.backgroundColor = UIColor.rgb(red: 2, green: 126, blue: 216)
        view.layer.cornerRadius = 8
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(addNewSlangTap))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var addSlangLabel: UILabel = {
        let view = UILabel()
        view.text = "ДОБАВИТЬ СЛЭНГ"
        view.textColor = .white
        view.font = UIFont(name: "Roboto-Light", size: 18)
        return view
    }()
    
    private lazy var addSlangImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "add")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = SlangListPresenter(view: self)
        presenter.heightForNoResultsLabel?.constant = 0
        setupSubviews()
        
        presenter.loadWords()
        presenter.observeData()
        
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        presenter.dismissKeyboard()
        presenter.reloadCellWhenDescriptionViewDismissed(viewController: self, selector: #selector(reloadRow))
    }
    
    @objc func refreshView() {
        presenter.loadWords()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func reloadRow() {
        view.endEditing(true)
        if let test = slangsTableView.indexPathForSelectedRow {
            let cell = slangsTableView.cellForRow(at: test) as! SlangCell
            cell.descriptionImageView.image = UIImage(named: "chevron_right")
            slangsTableView.reloadRows(at: [test], with: .automatic)
        }
    }
    
    @objc func dismissKeyBoard() {
        if slangSearchBar.searchTextField.text!.count < 1 {
            view.endEditing(true)
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
 
    func setupSubviews() {

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (tabBarController?.tabBar.frame.height)!).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        contentView.addSubview(slangSearchBar)
        slangSearchBar.translatesAutoresizingMaskIntoConstraints = false
        slangSearchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        slangSearchBar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21).isActive = true
        slangSearchBar.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -21).isActive = true
        slangSearchBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        contentView.addSubview(noSlangsLabel)
        noSlangsLabel.translatesAutoresizingMaskIntoConstraints = false
        noSlangsLabel.topAnchor.constraint(equalTo: slangSearchBar.bottomAnchor, constant: 20).isActive = true
        noSlangsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 28).isActive = true
        noSlangsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        presenter.heightForNoResultsLabel = noSlangsLabel.heightAnchor.constraint(equalToConstant: 0)
        presenter.heightForNoResultsLabel?.isActive = true
        
        contentView.addSubview(slangsTableView)
        slangsTableView.translatesAutoresizingMaskIntoConstraints = false
        slangsTableView.topAnchor.constraint(equalTo: noSlangsLabel.bottomAnchor, constant: 0).isActive = true
        slangsTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        slangsTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        slangsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        slangsTableView.refreshControl = refreshControl

        view.addSubview(addSlangView)
        addSlangView.translatesAutoresizingMaskIntoConstraints = false
        addSlangView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -31).isActive = true
        addSlangView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        addSlangView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        addSlangView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        addSlangView.addSubview(addSlangLabel)
        addSlangLabel.translatesAutoresizingMaskIntoConstraints = false
        addSlangLabel.leftAnchor.constraint(equalTo: addSlangView.leftAnchor, constant: 92.5).isActive = true
        addSlangLabel.centerYAnchor.constraint(equalTo: addSlangView.centerYAnchor, constant: 0).isActive = true
        
        addSlangView.addSubview(addSlangImageView)
        addSlangImageView.translatesAutoresizingMaskIntoConstraints = false
        addSlangImageView.centerYAnchor.constraint(equalTo: addSlangView.centerYAnchor, constant: 0).isActive = true
        addSlangImageView.leftAnchor.constraint(equalTo: addSlangLabel.rightAnchor, constant: 13).isActive = true
        addSlangImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        addSlangImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    @objc func addNewSlangTap() {
        presenter.presentSlangAddView(viewController: SlangAddViewController())
    }
    
    @objc func favouritesButtonTap() {
        presenter.presentFavourites(viewController: FavouritesViewController())
    }
    
}

extension SlangListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.filteredResults.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "slang_cell", for: indexPath) as! SlangCell
        cell.slangLabel.text = presenter.filteredResults[indexPath.row].title
        cell.selectionStyle = .blue
        return cell

    }
    
}

extension SlangListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = slangsTableView.cellForRow(at: indexPath) as! SlangCell
        cell.contentView.backgroundColor = .white
        cell.descriptionImageView.image = UIImage(named: "chevron_down")
        
        presenter.presentBottomSheet(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = slangsTableView.cellForRow(at: indexPath) as! SlangCell
        cell.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
        cell.descriptionImageView.image = UIImage(named: "chevron_right")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            addSlangView.isHidden = true
            self.lastContentOffset = 0
            } else {
               addSlangView.isHidden = false
            }
    
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
        if (presenter.filteredResults.count - indexPath.row) < 10 {
            if (presenter.model?.next) != nil {
                presenter.offset += 50
                presenter.loadWords()
               
            }
        }
    }
    
}

extension SlangListViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setImage(UIImage(), for: .search, state: .normal)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        presenter.searchSlang(text: searchText, searchBar: searchBar)
                                                              
        slangsTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
       
        textField.resignFirstResponder()
      
        if textField.text?.count == 0 {
            view.endEditing(true)
        }
        return true
    }
}

extension SlangListViewController: SlangListView {
    func dismissKeyboardWhenSearchDidFinish() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    func cellTap(at index: Int) {
        let slangDescriptionViewController = SlangDescriptionViewController()
        if let sheet = slangDescriptionViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .none
            
        }
        slangDescriptionViewController.slangTitleLabel.text = presenter.filteredResults[index].title
        slangDescriptionViewController.slangDescriptionLabel.text = presenter.filteredResults[index].description
        present(slangDescriptionViewController, animated: true, completion: nil)
    }
    
    func navigate(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func updateSlangList() {
        DispatchQueue.main.async {
            self.slangsTableView.reloadData()
        }
        
    }
    
    func refreshing() {
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
        }
    }
    
    func endRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func hideSearchImage(searchBar: UISearchBar) {
        searchBar.setImage(UIImage(), for: .search, state: .normal)
    }
    
    func unhideSearchImage(searchBar: UISearchBar) {
        searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
        self.view.endEditing(true)
    }
    func reciveWords(words: [WordModel]) {
        var arrayVerified: [WordModel] = []
        for word in words {
            if word.is_verified {
                arrayVerified.append(word)
            }
        }
        presenter.data.append(contentsOf: arrayVerified)
        presenter.filteredResults.append(contentsOf: arrayVerified)
        slangsTableView.reloadData()
    }
    
    func reciveErrorMessage(message: String?) {
        if let msg = message {
            print(msg)
        } else {
            print("Что-то пошло не так")
        }
    }
    
    
}

