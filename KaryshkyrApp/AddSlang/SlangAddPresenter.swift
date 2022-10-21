//
//  SlangAddPresenter.swift
//  KaryshkyrApp
//
//  Created by User on 10/18/22.
//

import Foundation

protocol SlangAddViewPresenter: AnyObject {
    init(view: SlangAddView)
    
    func postRequest(title: String, description: String, contact: String, is_verified: Bool)
}

class SlangAddPresenter: SlangAddViewPresenter {
    public weak var view: SlangAddView!
    
    required init(view: SlangAddView) {
        self.view = view
    }
    
    func postRequest(title: String, description: String, contact: String, is_verified: Bool) {
        guard let url = URL(string: "https://karyshkyr.geekstudio.kg/api/v1/words/") else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: AnyHashable] = [
            "title": title,
            "description": description,
            "contact": contact,
            "is_verified": is_verified
        ]
        
        request.httpBody =
        try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                
                
                //let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                let response = try JSONDecoder().decode(SlangPostModel.self, from: data)
                print("Success: \(response)")
                
            } catch {
                print("error")
            }
            
        }
        task.resume()
    }
}

struct SlangPostModel: Codable {
   
        var title: String
        var description: String
        var contact: String
        var is_verified: Bool


}

//func postRequest(title: String, body: String, userId: Int) {
//
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
//        else {return}
//
//        var request = URLRequest(url: url)
//
//        request.httpMethod = "POST"
//
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    let body: [String: AnyHashable] = [
//        "userId": userId,
//        "title": title,
//        "body": body
//    ]
//
//    request.httpBody =
//    try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//        guard let data = data, error == nil else {
//            return
//        }
//
//        do {
//
//
//            //let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//
//            let response = try JSONDecoder().decode(PostModel.self, from: data)
//            print("Success: \(response)")
//        } catch {
//            print("error")
//        }
//
//    }
//    task.resume()
//
//}
