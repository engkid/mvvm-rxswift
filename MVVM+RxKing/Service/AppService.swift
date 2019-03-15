//
//  AppService.swift
//  MVVM+RxKing
//
//  Created by Engkit Satia Riswara on 13/03/19.
//  Copyright © 2019 Engkit Satia Riswara. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

class AppService {
    
    static let shared = AppService()
    
    func getHeroes(url: String, successBlock: @escaping (_ response: [FictionCharacter]) -> Void, failureBlock: @escaping (_ error: Error) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let errorRes = error {
                
                DispatchQueue.main.async {
                    failureBlock(errorRes)
                    return
                }
                
            }
            
            guard let data = data else { return }
            
            do {
                
                let fictionCharacter = try JSONDecoder().decode([FictionCharacter].self, from: data)
                
                DispatchQueue.main.async {
                    successBlock(fictionCharacter)
                }
                
            } catch let error {
                
                print("failed to decode json response with error: ", error.localizedDescription)
                
            }
            
        }.resume()
        
    }
    
}
