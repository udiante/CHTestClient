//
//  RealmDataSource.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit
import RealmSwift

class RealmDataSource: NSObject {
    
    override init() {
        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        #endif
    }
    
    private func getRealm()->Realm?{
        var realm : Realm?
        do {
            realm = try Realm()
        } catch (let error) {
            print(error)
        }
        return realm
    }
    
    func saveObjectModel(_ objectModel:Object, shouldUpdate:Bool?) {
        guard let realm = self.getRealm() else {
            return
        }
        let update = shouldUpdate ?? false
        try? realm.write {
            realm.add(objectModel, update: update)
        }
    }
    
    func newCoinModel(withCoinServiceModel serviceModel: CoinData){
        let coin = CoinModel()
        coin.set(withCoinServiceModel: serviceModel)
        self.saveObjectModel(coin, shouldUpdate: true)
    }
    
    func newPortfolioModel(withPortfolioServiceModel serviceModel: PortfolioCoins)->PortfolioModel{
        let portfolio = PortfolioModel()
        portfolio.set(withPortfolioServiceModel: serviceModel)
        if let coinId = serviceModel.coin_id, let coinModel = self.getCoinModel(withIdentifier: coinId){
            portfolio.coin = coinModel
        }
        self.saveObjectModel(portfolio, shouldUpdate: true)
        return portfolio
    }
    
    func getCoinModel(withIdentifier identifier:Int)->CoinModel?{
        guard let realm = self.getRealm() else {
            return nil
        }
        return realm.objects(CoinModel.self).filter("identifier == %i", identifier).first
    }
    
    func getPortFolioModel(withIdentifier identifier:Int)->PortfolioModel?{
        guard let realm = self.getRealm() else {
            return nil
        }
        return realm.objects(PortfolioModel.self).filter("coinIdentifier == %i", identifier).first
    }
    
    func updatePortFolioModelCoin(_ coinId:Int){
        guard let realm = self.getRealm(), let coinModel = getCoinModel(withIdentifier: coinId), let portfolioModel = getPortFolioModel(withIdentifier: coinId) else {
            return
        }
        do {
            try realm.write {
                portfolioModel.coin = coinModel
            }
        } catch (let error) {
            print(error)
        }
    }
    
}
