//
//  ExchangeViewModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class ExchangeViewModel: NSObject {
    fileprivate let kMinAmountToExchange : Double = 0
    fileprivate let kDefaultDecimalPlaces : Int = 8
    fileprivate let coinModel : CoinData
    fileprivate var amountToExchange : Double?
    
    required init(withCoinModel coinModel:CoinData){
        self.coinModel = coinModel
        super.init()
    }
    
    func getTitle()->String {
        let baseString = "%@".localized()
        return String(format: baseString, self.coinModel.name ?? "")
    }
    
    func getSubtitleExchangeRate()->String {
        let symbol = self.coinModel.symbol ?? ""
        let valueUSD = Utils.formatAmountString(self.coinModel.price_usd ?? "", decimalPlaces: Constants.decimalPlaces.USD_DOLLAR, currencySymbol: Constants.symbols.USD_DOLLAR)
        let baseString = "1 %@ is %@".localized()
        return String(format: baseString, symbol, valueUSD)
    }
    
    func getSubtitleAvailable()->String {
        if let available = self.coinModel.available_supply {
            let avaialbleString = Utils.formatAmount(Double(available), decimalPlaces: 0, currencySymbol: "")
            let baseString = "(%@ units availble)".localized()
            return String(format: baseString, avaialbleString)

        }
        return ""
    }
    
    func getPriceUSD()->Double{
        return Double(self.coinModel.price_usd ?? "0") ?? 0.0
    }
    
    func getCoinSymbol()->String {
        return self.coinModel.symbol ?? ""
    }
    
    /// Sets the current amount of the cryptocurrency that the users want to exchange and returns their equivalent in USD. If the value returned is null the amount is invalid
    func setAmountToExchange(rawValue:String?)->String?{
        guard let string = rawValue, let doubleValue = Double(string), doubleValue >= kMinAmountToExchange else {
            self.amountToExchange = nil
            return nil
        }
        // Case: the users wants Cryptocurrency and is paying USD (the amount is positive)
        self.amountToExchange = doubleValue
        let usdValue = doubleValue * getPriceUSD()
        return Utils.formatAmount(usdValue * -1, decimalPlaces: kDefaultDecimalPlaces, currencySymbol: Constants.symbols.USD_DOLLAR)
    }
    
    /// Sets the current amount of the USD that the users want to exchange and returns their equivalent in the cryptocurrency value. If the value returned is null the amount is invalid
    func setAmountFromUSD(rawValue:String?)->String?{
        guard let string = rawValue, let doubleValue = Double(string) else {
            self.amountToExchange = nil
            return nil
        }
        let amount = doubleValue / getPriceUSD()
        guard amount >= kMinAmountToExchange else {
            self.amountToExchange = nil
            return nil
        }
        // Case: the users wants USD and is selling cryptocurrency (the amount is negative)
        self.amountToExchange = amount * -1
        return Utils.formatAmount(amount * -1, decimalPlaces: kDefaultDecimalPlaces, currencySymbol: "")
    }
    
    func getUSDCost()->Double{
        if let amount = self.amountToExchange {
            let usdValue = amount * getPriceUSD()
            return usdValue
        }
        return 0.0
    }
    
    func getAlertMessage()->String? {
        guard var amount = self.amountToExchange else {
            return nil
        }
        let baseString : String!
        if amount >= 0 {
            // The user want to buy cryptocurrency //ie: You're going to buy 1 BTC paying $90000
            baseString = "You're going to buy %@ %@ paying %@.\nAre you sure?".localized()
        }
        else {
            // The user want to sell cryptocurrency //ie: You're going to sell 1 BTC getting $90000
            amount = amount * -1
            baseString = "You're going to sell %@ %@ getting %@\nAre you sure?".localized()
        }
        return String(format: baseString, Utils.formatAmount(amount, decimalPlaces: kDefaultDecimalPlaces, currencySymbol: ""), self.coinModel.symbol ?? "" ,Utils.formatAmount(self.getUSDCost(), decimalPlaces: Constants.decimalPlaces.USD_DOLLAR, currencySymbol: "$"))
    }
    
    func performExchange(delegate:NetworkingViewProtocol) {
        guard let amount = self.amountToExchange, let coinId = self.coinModel.id else {
            return
        }
        let price_usd = self.getPriceUSD()
        // API service fails if the date is exact. Adding -1 minutes fixes the "traded_at" date fail error.
        let date = Date().adding(minutes: -1) ?? Date()
        let traded_at = Utils.getDateISO8601String(atDate: date)
        let inputData = PostTradeInput()
        inputData.amount = amount
        inputData.tradedAt = traded_at
        inputData.priceUsd = price_usd
        inputData.coinId = coinId
        delegate.startDownload()
        CryptojetioDataSource.postTrade(entryParams: inputData) { (error, tradeResponse) in
            delegate.stopDownload(withError: error);
        }
    }
}
