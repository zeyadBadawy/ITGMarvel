//
//  ListPreseter.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

protocol ListDelegate:BaseDelegate{
    func requestSucceed(charcters:[MCharcter])
    func dataRetrieved(charcters:[RCharcter])
}

import Foundation

class ListPresenter {
    
    var delegate: ListDelegate
    
    init(delegate: ListDelegate) {
        self.delegate = delegate
        self.getCharcters(searchText: nil, offset: 0)
    }
    /*
        *In this function we call the api so we have two cases:
            1:There is Internet connections so the call back with array of characters from marvel api.
            2:There is no internet connection so we try to fetch the cached objects if exists and if not we
              back with failure message due to internet connectoin and show empty state
            
        *In such cases we can use connectivity , reachability or any other alternatives to set a listener to
        the internet connection state and triger different actions in each case and it is so easy to implemnt
        i did not use any of them cause i prefer offering a native solution in job tasks phase and not using
        third party lib.
     */
    
    func getCharcters(searchText: String?, offset: Int){
        self.delegate.showProgressView()
        NetworkManager.shared.getCharchtersList(searchText: searchText, offset: offset) { [weak self] (result) in
            guard let self = self else {return}
            self.delegate.hideProgressView()
            switch result {
            case .success(let charList):
                guard let chars = charList.data?.results else {return}
                self.delegate.requestSucceed(charcters: chars)
                let realmProducts = PresistenceManager.shared.buildRealmModel(from: chars)
                PresistenceManager.shared.saveCharcters(charcters: realmProducts) {
                    print("Cache success")
                }
            case .failure(let error):
                DispatchQueue.main.async{
                    PresistenceManager.shared.fetchCharcters(success: { (chars) in
                        guard let cachedChars = chars , !cachedChars.isEmpty else {
                            self.delegate.requestDidFailed(message: error.localizedDescription)
                            return
                        }
                        self.delegate.dataRetrieved(charcters: cachedChars)
                    })
                }
            }
        }
    }
}
