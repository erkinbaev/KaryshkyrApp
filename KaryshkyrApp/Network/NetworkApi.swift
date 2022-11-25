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
    
    func loadWord(limit: Int = 50, offset: Int = 0, completion: @escaping (Result<WordsResponse,Error>) -> ()){
        let url = URL(string: "https://karyshkyr.geekstudio.kg/api/v1/words/?limit=\(limit)&offset=\(offset)")
        
        guard let url = url else {
            return
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                
                    guard let data = data,
                      let response = try? JSONDecoder().decode(WordsResponse.self, from: data) else {
                          completion(.failure(NetworkError.dataCouldtParse))
                   
                    return
                }
                
                completion(.success(response))
                
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case dataCouldtParse
}
