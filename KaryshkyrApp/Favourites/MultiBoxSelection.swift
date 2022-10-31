//
//  MultiBoxSelection.swift
//  KaryshkyrApp
//
//  Created by User on 10/28/22.
//

import Foundation

class MultiBoxSelection {
    
    static var singleTone = MultiBoxSelection()
    
    var selectedIndexs: [IndexPath] = []
    
    func addSelectedIndex(indexPath: IndexPath) {
        self.selectedIndexs.append(indexPath)
    }
    
    func removeIndex(indexPath: IndexPath) {
        for (index, value) in selectedIndexs.enumerated() {
            if indexPath == value {
                selectedIndexs.remove(at: index)
            }
        }
    }
    
    func clearIndexs() {
        selectedIndexs.removeAll()
    }
    
}
