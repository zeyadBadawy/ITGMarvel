//
//  UIViewController+Ext.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title:String , messaeg:String , buttonTitle:String){
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: messaeg, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            ac.addAction(action)
            ac.modalPresentationStyle = .overFullScreen
            ac.modalTransitionStyle = .crossDissolve
            self.present(ac, animated: true)
        }
    }
}
