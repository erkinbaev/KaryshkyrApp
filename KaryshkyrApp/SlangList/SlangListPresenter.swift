//
//  SlangListPresenter.swift
//  KaryshkyrApp
//
//  Created by User on 10/21/22.
//

import Foundation
import UIKit

protocol SlangListPresenterDelegate: AnyObject {
    init(view: SlangListView)
    
    func presentBottomSheet(at index: Int)
    
    func presentFavourites(viewController: UIViewController)
    
    func presentSlangAddView(viewController: UIViewController)
    
    func searchSlang(text: String, searchBar: UISearchBar)
    
    func reloadCellWhenDescriptionViewDismissed(viewController: UIViewController, selector: Selector)
    
    func dismissKeyboard()
    
    func observeData()
    
    func loadWords()

}

class SlangListPresenter : SlangListPresenterDelegate {
    
    var model: WordsResponse? = nil
    
    var offset = 0
    
    private let nc = NotificationCenter.default
    
    public weak var view: SlangListView!
    
    var filteredResults: [WordModel] = []
    
    var data: [WordModel] = []
    
    var heightForNoResultsLabel: NSLayoutConstraint? = nil
    
    var heightForTableView: NSLayoutConstraint? = nil
    
    private var networkApi = NetworkApi()
    
    required init(view: SlangListView) {
        self.view = view
    }
    
    func observeData() {
        if model?.results.count == 0 {
            view.refreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    func loadWords() {
        networkApi.loadWord(offset: offset) { [self] response in
            switch response {
            case .success(let data):
                self.view.reciveWords(words: data.results)
                self.model = data
            case .failure(let error):
                view.reciveErrorMessage(message: error.localizedDescription)
            }
        }
    }

    func presentBottomSheet(at index: Int) {
        view.cellTap(at: index)
    }
    
    func presentFavourites(viewController: UIViewController) {
        view.navigate(viewController: viewController)
    }
    
    func presentSlangAddView(viewController: UIViewController) {
        view.navigate(viewController: viewController)
    }
    
    func searchSlang(text: String, searchBar: UISearchBar) {
        
        filteredResults = []

        if text == "" {
            filteredResults = data
            self.heightForNoResultsLabel?.constant = 0
            view.unhideSearchImage(searchBar: searchBar)
        } else {
            view.hideSearchImage(searchBar: searchBar)
            for i in 0..<self.data.count {
                    if data[i].title.uppercased().contains(text.uppercased()) {
                        filteredResults.append(data[i])
                    }
            }
        }

        if filteredResults.count == 0 {
            DispatchQueue.main.async {
                self.heightForNoResultsLabel?.constant = 80
            }
        } else {
            DispatchQueue.main.async {
                self.heightForNoResultsLabel?.constant = 0
            }
        }
        
        DispatchQueue.main.async {
            self.view.updateSlangList()
        }
    }
    
    func dismissKeyboard() {
        DispatchQueue.main.async {
            self.view.dismissKeyboardWhenSearchDidFinish()
        }
    }
    
    func reloadCellWhenDescriptionViewDismissed(viewController: UIViewController, selector: Selector) {
        nc.addObserver(viewController.self, selector: selector, name: Notification.Name("dismissedAtList"), object: nil)
    }
    
}


