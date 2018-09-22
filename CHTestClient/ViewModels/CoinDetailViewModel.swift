//
//  CoinDetailViewModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class CoinDetailViewModel: NSObject {
    
    fileprivate let kDefaultDecimalPlaces = 2
    private let coinModel : CoinData

    init(withCoinModel coinModel:CoinData){
        self.coinModel = coinModel
        super.init()
    }
    
    
    //MARK: - UI
    
    func getCoinName()->String {
        return coinModel.name ?? ""
    }
    
    func getTitle()->String {
        return "\(coinModel.name ?? "") (\(coinModel.symbol ?? ""))"
    }
    
    func getOneHourChangeValue()->String{
        return Utils.formattPercent(self.coinModel.percent_change_1h ?? "-", decimalPlaces: kDefaultDecimalPlaces)
    }
    
    func getOneDayChangeValue()->String{
        return Utils.formattPercent(self.coinModel.percent_change_24h ?? "-", decimalPlaces: kDefaultDecimalPlaces)
    }
    
    func getSevenDaysChangeValue()->String{
        return Utils.formattPercent(self.coinModel.percent_change_7d ?? "-", decimalPlaces: kDefaultDecimalPlaces)
    }
    
    func getOneHourChangeColor()->UIColor{
        return Utils.colorForValue(self.coinModel.percent_change_1h)
    }
    
    func get24HoursChangeColor()->UIColor{
        return Utils.colorForValue(self.coinModel.percent_change_24h)
    }
    
    func get7DaysChangeColor()->UIColor{
        return Utils.colorForValue(self.coinModel.percent_change_7d)
    }
    
    //MARK: - Request
    
    func loadHistoric(delegate:NetworkingViewProtocol){
        guard let coinIdentifier = self.coinModel.id else {
            return
        }
        CryptojetioDataSource.getCoinHistorical(withCoinIdentifier: String(coinIdentifier)) { (error, response) in
            
        }
    }

    //MARK: - Chart UI
    
}
