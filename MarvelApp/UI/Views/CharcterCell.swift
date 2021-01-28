//
//  CharcterCell.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import UIKit

class CharcterCell: UITableViewCell {
    
    static let reuseID = "CharcterCell"
    
    let charcterImageView = UIImageView(frame: .zero)
    let charcterNameLabel = UILabel(frame: .zero)
    let labelView = UIView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.charcterImageView.image = Images.placeholder
        self.charcterNameLabel.text = ""
    }
    
    func set(with character:MCharcter){
        
        let thumbnailPath = character.thumbnail?.path ?? ""
        let extensiton = character.thumbnail?.thumbnailExtension?.rawValue ?? ""
        let urlString =  "\(thumbnailPath).\(extensiton)"
        
        charcterImageView.downloadImage(fromURL: urlString )
        charcterImageView.layoutSubviews()
        charcterNameLabel.text = character.name ?? "This prduct has no name"
    }
    
    func set(with character:RCharcter){
        charcterImageView.downloadImage(fromURL: character.imageURl ?? "" )
        charcterNameLabel.text = character.name ?? "This prduct has no name"
    }
    
    private func configure(){
        charcterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        charcterImageView.translatesAutoresizingMaskIntoConstraints = false
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubViews(charcterImageView , labelView)
        labelView.addSubview(charcterNameLabel)
        
        charcterNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        labelView.backgroundColor = .white
        labelView.layer.cornerRadius = 20
        charcterNameLabel.font = UIFont.systemFont(ofSize: 20)
        charcterNameLabel.adjustsFontSizeToFitWidth = true
        charcterNameLabel.textAlignment = .center
        
        charcterImageView.pinToTheEdges(of: self)
        charcterNameLabel.pinToTheEdges(of: labelView)
        
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 50),
            labelView.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            labelView.widthAnchor.constraint(equalToConstant: 150),
            labelView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
