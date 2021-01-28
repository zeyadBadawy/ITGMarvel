//
//  PresistenceManager.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import Foundation
import RealmSwift

//MARK:- Realm Manager

/*
 Here we can use coreData but i believe that realm is more easy,fast and a very smart solution
 
 */


class PresistenceManager {
    
    static let shared = PresistenceManager()
    
    func saveCharcters(charcters:[RCharcter] , success: @escaping () -> Void ){
        self.deleteAllObjects()
        let charctersRealmList = List<RCharcter>()
        for charcter in charcters {
            charctersRealmList.append(charcter)
        }
        DispatchQueue.main.async{
            let realm = try! Realm()
            try! realm.write {
                debugPrint("Realm add \(Thread.current)")
                realm.add(charctersRealmList)
                success()
            }
        }
    }
    
    func fetchCharcters(success: @escaping ((_ charcters: [RCharcter]?) -> Void) ){
        let realm = try! Realm()
        let rCharcters = realm.objects(RCharcter.self)
        var charcters = [RCharcter]()
        for charcter in rCharcters {
            charcters.append(charcter)
        }
        success(charcters)
    }
    
    func deleteAllObjects(){
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    //This fuction construct a realm data base object from the api object model for easy maintenance and future changes in model changes
    func buildRealmModel(from charcters : [MCharcter]) -> [RCharcter] {
        var rCharcters = [RCharcter]()
        for charcter in charcters {
            let rproduct = RCharcter(charcter: charcter)
            rCharcters.append(rproduct)
        }
        return rCharcters
    }
    
}
