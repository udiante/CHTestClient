//
//  PortfolioViewModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class PortfolioViewModel: NSObject {
    
    let realmDataSource = RealmDataSource()
    
    func loadPortfolio(delegate:NetworkingViewProtocol){
        // Download all user portfolio
        delegate.startDownload()
        CryptojetioDataSource.getPortfolio { (error, response) in
            guard error == nil, let coins = response?.coins else {
                // Abort the download process
                delegate.stopDownload(withError: error)
                return
            }
            var coinsIdsToDownload = [Int]()
            for coin in coins where coin.coin_id != nil {
                // Check if exists in the database
                let portfolio = self.realmDataSource.newPortfolioModel(withPortfolioServiceModel: coin)
                if portfolio.coin == nil {
                    coinsIdsToDownload.append(coin.coin_id!)
                }
            }
            // Download the missing coin data
            self.downloadCoinsById(ids: coinsIdsToDownload, completionHandler: {
                for coinId in coinsIdsToDownload {
                    self.realmDataSource.updatePortFolioModelCoin(coinId)
                }
                delegate.stopDownload(withError: nil);
            })
        }
    }
    
    func downloadCoinsById(ids:[Int], completionHandler: (@escaping () -> Void)){
        var mutableIds = ids;
        guard let id = mutableIds.popLast() else {
            completionHandler()
            return
        }
        CryptojetioDataSource.getCoinDetail(withCoinIdentifier: String(id)) { (error, coinModel) in
            self.downloadCoinsById(ids: mutableIds, completionHandler: completionHandler)
        }
    }

}
