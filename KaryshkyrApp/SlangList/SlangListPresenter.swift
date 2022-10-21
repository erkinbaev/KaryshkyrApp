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
    
}

class SlangListPresenter : SlangListPresenterDelegate {
    public weak var view: SlangListView!
    
    static var words: [WordModel] = []
    
    var result = WordsResponse(count: 0, next: "", results: words)
    
    required init(view: SlangListView) {
        self.view = view
    }
    
    func retrieve(completion: @escaping () -> ()) {
        let url = URL(string: "https://karyshkyr.geekstudio.kg/api/v1/words/")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    let test = try JSONDecoder().decode(WordsResponse.self, from: data!)
                    print(test)
                    self.result.results = test.results
                    print(test.results.count)
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                print("myau")
                }
            }
           
        }.resume()
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
}
