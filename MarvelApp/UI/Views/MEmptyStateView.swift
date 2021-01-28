//
//  MEmptyStateView.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import UIKit

class MEmptyStateView: UIView {
    
    let emptyStateImage = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(emptyStateImage)
        emptyStateImage.image = Images.emptyState
        emptyStateImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateImage.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1.3),
            emptyStateImage.heightAnchor.constraint(equalTo: emptyStateImage.widthAnchor),
            emptyStateImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateImage.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
    }
    
}
