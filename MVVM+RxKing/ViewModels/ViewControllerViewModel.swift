//
//  ViewControllerViewModel.swift
//  MVVM+RxKing
//
//  Created by Engkit Satia Riswara on 13/03/19.
//  Copyright © 2019 Engkit Satia Riswara. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewControllerViewModel {
    
    private let appService: AppService
    
    var routerDelegate: Router?

    private let _asd = BehaviorRelay<String>(value: "")
    private let _blockView = BehaviorRelay<Bool>(value: false)
    private let _heroesRelay = BehaviorRelay<[FictionCharacter]>(value: [])
    private let _heroesCount = BehaviorRelay<Int>(value: 0)
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    init(url: String, service: AppService) {
        self.appService = service
        self.fetchData(url: url)
        self._asd.accept("asdasdasd")
    }
    
    var asd : Driver<String> {
        return _asd.asDriver()
    }
    
    var blockView: Driver<Bool> {
        
        return _blockView.asDriver()
    }
    
    var isFetching: Driver<Bool> {
        
        return _isFetching.asDriver()
    }
    
    var fictionChars: Driver<[FictionCharacter]> {
        
        return _heroesRelay.asDriver()
        
    }
    
    var heroesCount: Int {
        
        return _heroesRelay.value.count
        
    }
    
    func routeToNextView() {
        
        routerDelegate?.route(to: UIViewController())
        
    }
    
    func viewModelForCharacter(at index: Int) -> TableViewModel? {
        
        guard index < _heroesRelay.value.count else { return nil }
        
        return TableViewModel(character: _heroesRelay.value[index])
    }
    
    func fetchData(url: String) {
        
        self._isFetching.accept(true)
        self._blockView.accept(false)
        
        appService.getHeroes(url: url, successBlock: { (characters) in
            
            self._heroesRelay.accept(characters)
            self._isFetching.accept(false)
            self._blockView.accept(true)
            self._asd.accept("Finished fetching")
            
        }) { (error) in
            
            
            
        }
        
    }
    
}
