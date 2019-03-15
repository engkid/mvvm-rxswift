//
//  TableCellViewModel.swift
//  MVVM+RxKing
//
//  Created by Engkit Satia Riswara on 14/03/19.
//  Copyright © 2019 Engkit Satia Riswara. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TableViewModel {
    
    private var char: FictionCharacter
    
    init(character: FictionCharacter) {
        
        self.char = character
        
    }
    
    var name: String {
        return char.description ?? ""
    }
    
    var avatarUrl: String {
        return char.avatarUrl ?? ""
    }

    
}
