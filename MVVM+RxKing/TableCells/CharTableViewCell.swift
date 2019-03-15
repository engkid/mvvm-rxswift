//
//  CharTableViewCell.swift
//  MVVM+RxKing
//
//  Created by Engkit Satia Riswara on 14/03/19.
//  Copyright © 2019 Engkit Satia Riswara. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CharTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let _imageCell = BehaviorRelay<UIImage?>(value: Optional<UIImage>.none)
    
    static let identifier = "CharTableViewCell"

    let disposeBag = DisposeBag()
    
    var imageCell: Driver<UIImage?> {
        return _imageCell.asDriver()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.numberOfLines = 0
        self.selectionStyle = .none
    }

    func configure(viewModel: TableViewModel) {
        
        self.nameLabel.text = viewModel.name
        
        _ = self.imageCell.drive(onNext: { [weak self] (image) in
            self?.cellImage.image = image
        })
        
        self.fetchImage(withUrl: viewModel.avatarUrl)
        
    }
    
    private func fetchImage(withUrl url: String) {
        
        guard let URL = URL(string: url) else { return  }
        
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            
            if let _ = error {
                return
            }
            
            guard let datas = data else { return }
            
            let image = UIImage(data: datas)
            
            self._imageCell.accept(image)
            
            }.resume()
        
    }
    
}
