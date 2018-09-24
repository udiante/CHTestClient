//
//  PortfolioCoinModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit
import RealmSwift

class PortfolioModel: Object {
    @objc dynamic var coin : CoinModel?
    @objc dynamic var coinIdentifier : Int = -1
    @objc dynamic var amount : Double = 0.0
    @objc dynamic var priceUSD : Double = 0.0
    @objc dynamic var tradeDate : Date? // The API service doesn't return this value.
    
    func set(withPortfolioServiceModel serviceModel: PortfolioCoins) {
        guard let coinId = serviceModel.coin_id, let coinAmount = serviceModel.amount, let coinAmountDouble = Double(coinAmount), let priceUSDString = serviceModel.price_usd, let priceUSDDouble = Double(priceUSDString) else {
            return
        }
        self.coin = nil
        self.coinIdentifier = coinId
        self.amount = coinAmountDouble
        self.priceUSD = priceUSDDouble
    }
    
    override static func primaryKey() -> String? {
        return "coinIdentifier"
    }
    
    override static func indexedProperties() -> [String] {
        return ["coinIdentifier"]
    }
    
}

class CoinModel: Object {
    @objc dynamic var identifier : Int = -1
    @objc dynamic var name : String?
    @objc dynamic var symbol : String?
    @objc dynamic var price_usd : String?
    @objc dynamic var percent_change_1h : String?
    @objc dynamic var percent_change_24h : String?
    @objc dynamic var percent_change_7d : String?

    
    func set(withCoinServiceModel serviceModel: CoinData) {
        guard let coinId = serviceModel.id else {
            return
        }
        self.identifier = coinId
        self.name = serviceModel.name
        self.symbol = serviceModel.symbol
        self.price_usd = serviceModel.price_usd
        self.percent_change_1h = serviceModel.percent_change_1h
        self.percent_change_24h = serviceModel.percent_change_24h
        self.percent_change_7d = serviceModel.percent_change_7d
    }
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    override static func indexedProperties() -> [String] {
        return ["identifier"]
    }
    
}
