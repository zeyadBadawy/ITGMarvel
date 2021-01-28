//
//  DetailsPresenter.swift
//  MarvelApp
//
//  Created by zeyad on 1/28/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

protocol BaseDelegate {
    func showProgressView()
    func hideProgressView()
    func requestDidFailed(message: String)
}

protocol DetailsDelegate:BaseDelegate{
    func requestSucceed(comics:[ComicsResult])
}

import Foundation

class DetailsPresenter {
    
    var delegate: DetailsDelegate
    
    init(delegate: DetailsDelegate) {
        self.delegate = delegate
    }
    
    func getCharcterDetails(id: Int){
        self.delegate.showProgressView()
        NetworkManager.shared.getCharchterComics(id: id) { [weak self] (result) in
            guard let self = self else {return}
            self.delegate.hideProgressView()
            switch result {
            case .success(let characterComics):
                guard let comics = characterComics.data?.results else {return}
                self.delegate.requestSucceed(comics: comics)
                print(comics)
            case .failure(let error):
                self.delegate.requestDidFailed(message: error.localizedDescription)
            }
        }
    }
}

