//
//  UIHelper.swift
//  MarvelApp
//
//  Created by zeyad on 1/28/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import UIKit

enum UIHelper {
    
    static func getSliderFolwLayout() -> UICollectionViewFlowLayout {
        let padding:CGFloat = 2
        let minimumItemSpacing:CGFloat = 0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.itemSize = CGSize(width: 150, height: 200)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }
    
}
