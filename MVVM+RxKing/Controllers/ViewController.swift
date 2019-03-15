//
//  ViewController.swift
//  MVVM+RxKing
//
//  Created by Engkit Satia Riswara on 13/03/19.
//  Copyright © 2019 Engkit Satia Riswara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct BaseURL {
    
    static var path: String {
        
        return "https://www.mocky.io/v2/5c85dd76340000550689bd03"
        
    }
    
    enum environment {
        
        case staging
        case production
        
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var image: UIImage?
    
    var viewModel: ViewControllerViewModel?
    
    let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        
        let table = UITableView()
        table.addSubview(visualEffectView)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    lazy var visualEffectView: UIView = {
       
        let ve = UIView()
        ve.addSubview(activityIndicator)
        ve.backgroundColor = .gray
        ve.alpha = 0.5
        ve.translatesAutoresizingMaskIntoConstraints = false
        return ve
        
    }()
    
    let button: UIBarButtonItem = {
        
        let btn = UIBarButtonItem()
        btn.title = "OK"
        
        return btn
        
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
       
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.style = .whiteLarge
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        return ai
    }()
    
    private func configureLayout() {
        
        self.navigationItem.rightBarButtonItem = button
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: CharTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CharTableViewCell.identifier)
        
        view.addSubview(tableView)
        
        visualEffectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        
        _ = button.rx.tap
            .throttle(1, scheduler: MainScheduler.instance)
            .subscribe({ [unowned self] (_) in
                self.viewModel?.routeToNextView()
        })
        
        viewModel?.routerDelegate = self
        
        _ = viewModel?.asd.drive(onNext: { [weak self] (string) in
            print("string \(string)")
            
            self?.title = string
            
        })
        
        viewModel?.blockView
            .drive(visualEffectView.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel?.isFetching
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel?.fictionChars.drive(onNext: { [weak self] (_) in
            
            self?.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.heroesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharTableViewCell.identifier, for: indexPath) as? CharTableViewCell else { return UITableViewCell() }
        
        if let vm = viewModel?.viewModelForCharacter(at: indexPath.row) {
            cell.configure(viewModel: vm)
        }
        
        return cell
    }
   
}

extension ViewController: Router {
    
    func route(to nextView: UIViewController) {
        
        self.navigationController?.pushViewController(nextView, animated: true)
        
    }
    
}

