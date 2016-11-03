//
//  StoryCell.swift
//  MBKtest
//
//  Created by Владимир Молчанов on 02/11/2016.
//  Copyright © 2016 Владимир Молчанов. All rights reserved.
//

import UIKit
import Foundation
import Then
import EasyPeasy

class StoryCell: UITableViewCell {
    // MARK: Constants
    private let kTitleLabelFont = UIFont.boldSystemFont(ofSize: 14)
    
    
    private let kDateLabelFont = UIFont.systemFont(ofSize: 12)
    private let kDateLabelTextColor: UIColor = .darkGray
    
   
    // MARK: Views
    private var titleLabel: UILabel!
    private var storyTextView: UITextView!
    private var linkTextView: UITextView!
    private var dateLabel: UILabel!
    
    // MARK: Public properties
    var cellModel: StoryCellModel! {
        didSet {
            titleLabel.text = cellModel.title
            
            if let storyAttrStr = try? NSAttributedString(
                data: cellModel.text.data(using: String.Encoding.unicode)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil) {
                storyTextView.attributedText = storyAttrStr
            } else {
                storyTextView.text = cellModel.text
            }
            
            
            linkTextView.text = cellModel.link
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            let date = Date(timeIntervalSince1970: cellModel.date)
            let formattedDate = dateFormatter.string(from: date)
            dateLabel.text = formattedDate
        }
    }
    
    // MARK: Setup
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareViews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        layoutViews()
    }
    
    func prepareViews() {
        titleLabel = UILabel().then {
            $0.font = kTitleLabelFont
        }
        contentView.addSubview(titleLabel)
        
        storyTextView = UITextView().then {
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.textContainer.lineFragmentPadding = 0
            $0.textContainerInset = EdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

        }
        contentView.addSubview(storyTextView)
        
        linkTextView = UITextView().then {
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.dataDetectorTypes = [.link]
            $0.textContainer.lineFragmentPadding = 0
            $0.textContainerInset = EdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

        }
        contentView.addSubview(linkTextView)
        
        dateLabel = UILabel().then {
            $0.font = kDateLabelFont
            $0.textColor = kDateLabelTextColor
            $0.textAlignment = .right
        }
        contentView.addSubview(dateLabel)
        
    }
    
    func layoutViews() {
        // константы будут перенесены в Constants, сейчас просто не трачу на это время
        titleLabel <- [
            Top(10), Left(10), Right(5).to(dateLabel, .left), Height(>=16)
        ]
        
        storyTextView <- [
            Top(5).to(titleLabel), Left(10), Right(10), Height(>=30)
        ]
        
        linkTextView <- [
            Top(10).to(storyTextView), Left(10), Right(10), Height(>=15), Bottom(10)
        ]
        
        dateLabel <- [
            FirstBaseline().to(titleLabel, .firstBaseline), Right(10), Height(>=14), Width(120)
        ]
        
        contentView.layoutIfNeeded()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
