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
}

class SlangListViewController: UIViewController {
    var selectedIndex: IndexPath?
    
    private var presenter: SlangListPresenter!
    
    let alert = FavoriteViewController()
    
    let nc = NotificationCenter.default
    
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
        return view
    }()
    
    lazy var slangsTableView: UITableView = {
        let view = UITableView()
        view.register(SlangCell.self, forCellReuseIdentifier: "slang_cell")
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
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
        return view
    }()
    
    private lazy var addSlangImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "add")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        self.presenter = SlangListPresenter(view: self)
        
        presenter.retrieve {
            self.slangsTableView.reloadData()
        }
        
        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("UserLoggedIn"), object: nil)
        nc.addObserver(self, selector: #selector(dismissTest), name: Notification.Name("dismissed"), object: nil)
       
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
 
    func setupSubviews() {

        let addNewSlangBarButton = createCustomButton(image: "plus.circle.fill", title: "Добавить сленг", selector: #selector(addNewSlangTap))
        
        navigationItem.rightBarButtonItem = addNewSlangBarButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favouritesButtonTap))
        
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
        
        contentView.addSubview(slangsTableView)
        slangsTableView.translatesAutoresizingMaskIntoConstraints = false
        slangsTableView.topAnchor.constraint(equalTo: slangSearchBar.bottomAnchor, constant: 0).isActive = true
        slangsTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        slangsTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        slangsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
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
       // return presenter.result.results.count
        return presenter.filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slang_cell", for: indexPath) as! SlangCell
        //cell.slangLabel.text = presenter.result.results[indexPath.row].title
        
        cell.slangLabel.text = presenter.filteredResults[indexPath.row].title
        
        if selectedIndex == indexPath {
            cell.backgroundColor = UIColor.white
            cell.descriptionImageView.image = UIImage(named: "chevron_down")
        } else {
            cell.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 251)
            cell.descriptionImageView.image = UIImage(named: "chevron_right")
        }
        
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
        
        selectedIndex = indexPath
        
        tableView.reloadData()

        presenter.presentBottomSheet(at: indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (model.result.count - indexPath.row < 4) {
//            //request for next page
//        }
//    }
}

extension SlangListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setImage(UIImage(), for: .search, state: .normal)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
        } else {
            searchBar.setImage(UIImage(), for: .search, state: .normal)
        }
        
        presenter.searchSlang(text: searchText)
    }

}

extension SlangListViewController: SlangListView {
    func cellTap(at index: Int) {
        let slangDescriptionViewController = SlangDescriptionViewController()
        if let sheet = slangDescriptionViewController.sheetPresentationController {
            sheet.detents = [.medium()]
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
        slangsTableView.reloadData()
    }
}

extension SlangListViewController: CustomAlertDelegate {
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


