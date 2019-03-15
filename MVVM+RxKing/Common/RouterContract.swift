//
//  RouterContract.swift
//  MVVM+RxKing
//
//  Created by Engkit Satia Riswara on 15/03/19.
//  Copyright © 2019 Engkit Satia Riswara. All rights reserved.
//

import UIKit

protocol Router: class {
    
    func route(to nextView: UIViewController)
    
}
