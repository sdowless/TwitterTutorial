//
//  MenuOptionCell.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 3/25/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {
    
    // MARK: - Properties
    
    var option: MenuOptions? {
        didSet {
            iconImageView.image = option?.image
            descriptionLabel.text = option?.description
        }
    }
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .twitterBlue
        selectionStyle = .none
        
        addSubview(iconImageView)
        iconImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8, constant: 0)
        iconImageView.setDimensions(width: 26, height: 26)
        
        addSubview(descriptionLabel)
        descriptionLabel.centerY(inView: self, leftAnchor: iconImageView.rightAnchor, paddingLeft: 16, constant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
