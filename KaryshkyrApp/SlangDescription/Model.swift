//
//  Model.swift
//  KaryshkyrApp
//
//  Created by User on 11/6/22.
//

import Foundation
import RealmSwift

public class Slang: Object {
    @objc dynamic var title = ""
    @objc dynamic var slangDescription = ""
}

class Favourites: Object {
   let favourites = List<Slang>()
}
