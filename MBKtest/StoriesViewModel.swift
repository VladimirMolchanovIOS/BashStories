//
//  StoriesViewModel.swift
//  MBKtest
//
//  Created by Владимир Молчанов on 02/11/2016.
//  Copyright © 2016 Владимир Молчанов. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class StoriesViewModel: NSObject {
    // MARK: Constants
    let storiesURL = "http://kly.webtm.ru/api/index.php/v1/stories"
    
    let disposeBag = DisposeBag()
    
    // MARK: Reactive Properties
    var loadedStories: Variable<[StoryCellModel]> = Variable([])
    var reloadStories = PublishSubject<()>()
    
    // MARK: Setup
    
    func prepare() {
        
        loadStories()
        
        reloadStories
            .subscribe(onNext: {[unowned self] in self.loadStories() })
            .addDisposableTo(disposeBag)
    }
        
    // MARK: Helpers
    func loadStories() {
        request(storiesURL, method: .get).responseString { (response) in
            if response.result.isFailure {
                print("Failure")
            } else {
                if let jsonString = response.result.value {
                    if let data = jsonString.data(using: .utf8) {
                        var stories = [StoryCellModel]()
                        let json = JSON(data: data)
                        for story in json["stories"].arrayValue {
                            let cellModel = StoryCellModel(
                                title: story["title"].stringValue,
                                text: story["description"].stringValue,
                                link: story["link"].stringValue,
                                date: story["pubDate"].doubleValue)
                            stories.append(cellModel)
                            
                        }
                        self.loadedStories.value = stories
                    }
                    
                }
                
            }
        }

    }
}
