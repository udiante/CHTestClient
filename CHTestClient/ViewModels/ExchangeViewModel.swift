//
//  ExchangeViewModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class ExchangeViewModel: NSObject {

    fileprivate let coinModel : CoinData
    
    required init(withCoinModel coinModel:CoinData){
        self.coinModel = coinModel
        super.init()
    }
    
    func getTitle()->String {
        return self.coinModel.name ?? ""
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
            let baseString = "(%@ availble)".localized()
            return String(format: baseString, avaialbleString)

        }
        return ""
    }
    
}
