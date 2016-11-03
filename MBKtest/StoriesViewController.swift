//
//  StoriesViewController.swift
//  MBKtest
//
//  Created by Владимир Молчанов on 02/11/2016.
//  Copyright © 2016 Владимир Молчанов. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import EasyPeasy

class StoriesViewController: UIViewController {

    // MARK: Constants
    private let kStoryCellReuseId = "StoryCellReuseId"
    
    let disposeBag = DisposeBag()
    
    // MARK: Views
    private var storiesTableView: UITableView!
    private var topRefreshControl: UIRefreshControl!
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Public properties
    var viewModel: StoriesViewModel!

    // MARK: Init
    init(viewModel: StoriesViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Stories"
        prepareViews()
        prepareViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutViews()
    }

    func prepareViewModel() {
        viewModel.loadedStories.asObservable()
            .bindTo(storiesTableView.rx.items(cellIdentifier: kStoryCellReuseId)) { (row, elem: StoryCellModel, cell: StoryCell) in
                cell.cellModel = elem
            }
            .addDisposableTo(disposeBag)
        
        viewModel.prepare()
        
        topRefreshControl.rx.controlEvent(.valueChanged)
            .subscribe(viewModel.reloadStories)
            .addDisposableTo(disposeBag)
        
        viewModel.loadedStories.asObservable()
            .map { _ in false }
            .bindTo(topRefreshControl.rx.refreshing)
            .addDisposableTo(disposeBag)
        
        viewModel.loadedStories.asObservable()
            .skip(1)
            .map { _ in () }
            .subscribe(onNext: { [unowned self] in
                self.activityIndicator.stopAnimating()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func prepareViews() {
        topRefreshControl = UIRefreshControl()
        
        storiesTableView = UITableView().then {
            $0.backgroundColor = .white
            $0.register(StoryCell.self, forCellReuseIdentifier: kStoryCellReuseId)
            $0.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            $0.estimatedRowHeight = 250
            $0.rowHeight = UITableViewAutomaticDimension
            if #available(iOS 10.0, *) {
                $0.refreshControl = self.topRefreshControl
            } else {
                $0.addSubview(self.topRefreshControl)
            }
            $0.tableFooterView = UIView()
            $0.allowsSelection = false
        }
        
        view.addSubview(storiesTableView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray).then {
            $0.startAnimating()
            $0.hidesWhenStopped = true
        }
        view.addSubview(activityIndicator)
    }

    private func layoutViews() {
        storiesTableView <- [
            Edges()
        ]
        
        activityIndicator <- [
            CenterX(), CenterY()
        ]
        
        view.layoutIfNeeded()
    }



}
