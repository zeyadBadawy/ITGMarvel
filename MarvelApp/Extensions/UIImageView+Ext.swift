//
//  UIImageView+Ext.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImage(fromURL url:String){
        if url.count == 0 {
            return
        }
        NetworkManager.shared.downloadImage(from: url) {[weak self] (image) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
