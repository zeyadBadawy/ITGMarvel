//
//  ComicCell.swift
//  MarvelApp
//
//  Created by zeyad on 1/28/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import UIKit

class ComicCell: UICollectionViewCell {
    
    static let reuseID = "ComicCell"
    
    let avatarImageView = UIImageView()
    let usernameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(comic:ComicsResult){
        let thumbnailPath = comic.thumbnail?.path ?? ""
        let extensiton = comic.thumbnail?.thumbnailExtension?.rawValue ?? ""
        let urlString =  "\(thumbnailPath).\(extensiton)"
        avatarImageView.downloadImage(fromURL: urlString)
        avatarImageView.layoutSubviews()
        usernameLabel.text = comic.title ?? ""
        usernameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func configure(){
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubViews(avatarImageView,usernameLabel)
        
        usernameLabel.textColor = .black
        usernameLabel.numberOfLines = 0
        
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
