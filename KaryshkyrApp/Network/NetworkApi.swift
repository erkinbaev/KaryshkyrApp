//
//  NetworkApi.swift
//  KaryshkyrApp
//
//  Created by User on 11/5/22.
//

import Foundation
import UIKit

class NetworkApi {

    private let session = URLSession.shared
    private let baseURL = "https://karyshkyr.geekstudio.kg/api/v1/words/"
    
    func getWords(isRefresh: Bool, refreshControl: UIRefreshControl, completion: @escaping (WordsResponse) -> ()) {
        let url = "\(baseURL)"
        let request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                if isRefresh {
                    refreshControl.endRefreshing()
                }
                guard let data = data,
                      let response = try? JSONDecoder().decode(WordsResponse.self, from: data) else {
                          completion(WordsResponse(count: 0, next: "", results: []))
                    return
                }
                
                completion(response)
            }
        }
        task.resume()
    }
    
    func getNextWords(next: String, completion: @escaping (WordsResponse) -> ()) {
        //let url = URL(string: "https://karyshkyr.geekstudio.kg/api/v1/words/?limit=50&offset=50")
        //url comes with http, it need to use https, that's why i insert "s" character
        let localNext = next
        var nextAsCharacterArray = [Character](localNext)
        
        nextAsCharacterArray.insert("s", at: 4)
        let urlWithHttps = String(nextAsCharacterArray)
        
        let url = URL(string: urlWithHttps)
        
        guard let url = url else {
            return
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data,
                      let response = try? JSONDecoder().decode(WordsResponse.self, from: data) else {
                          completion(WordsResponse(count: 0, next: "", results: []))
                    return
                }
                
                completion(response)
            }
        }
        task.resume()
    }
    
}
