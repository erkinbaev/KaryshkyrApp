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
    
    func searchSlang(text: String)
    
    func reloadCellWhenDescriptionViewDismissed(viewController: UIViewController, selector: Selector)
    
    func dismissKeyboard()
    
    func getWords(isRefresh: Bool, refreshControl: UIRefreshControl)
    
    func getNextWords(isRefresh: Bool)
    
    func observeData()
    
}

class SlangListPresenter : SlangListPresenterDelegate {
    
    private let nc = NotificationCenter.default
    
    public weak var view: SlangListView!
    
    static var words: [WordModel] = []
    
    private var result = WordsResponse(count: 0, next: "", results: words)
    
    var filteredResults: [WordModel] = []
    
    private var data: [WordModel] = []
    
    private var slangs: [WordModel] = []
    
    var heightForNoResultsLabel: NSLayoutConstraint? = nil
    
    private var networkApi = NetworkApi()
    
    private var offset = 0
    
    private var limit = 0
    
    required init(view: SlangListView) {
        self.view = view
    }
    
    private func getVerifiedSlangs(words: [WordModel]) {
        for i in result.results {
            if i.is_verified {
                filteredResults.append(i)
                data.append(i)
            }
        }
    }
    
    func observeData() {
        if result.count == 0 {
            view.refreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    func getWords(isRefresh: Bool, refreshControl: UIRefreshControl) {
       
        networkApi.getWords(isRefresh: isRefresh, refreshControl: refreshControl) { words in
            self.result = WordsResponse(count: words.count, next: words.next, previous: words.previous, results: words.results)
            for i in words.results {
                if i.is_verified {
                    self.filteredResults.append(i)
                    self.data.append(i)
                }
            }
            self.view.updateSlangList()
        }
    }
    
    func getNextWords(isRefresh: Bool) {
        
        if result.next != nil {
            networkApi.getNextWords(next: result.next!) { words in
    
                self.result.next = words.next
                
                for i in words.results {
                    if i.is_verified {
                        self.filteredResults.append(i)
                        self.data.append(i)
                    }
                }
                
                self.view.updateSlangList()
                
            }
        } else {
            DispatchQueue.main.async {
                self.view.endRefreshing()
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
    
    func searchSlang(text: String) {
        filteredResults = []
        
        if text == "" {
            filteredResults = data
            self.heightForNoResultsLabel?.constant = 0
        }
        
        for slang in self.data{
            if slang.title.uppercased().contains(text.uppercased()) {
                filteredResults.append(slang)
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


