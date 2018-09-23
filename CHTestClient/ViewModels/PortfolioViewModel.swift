//
//  PortfolioViewModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class PortfolioCellViewModel : NSObject {

    fileprivate let defaultNoDataValue = "-"
    
    enum CellTypes {
        case TradeCell
        case InfoCell
        case TitleCell
    }
    
    fileprivate (set) var type : CellTypes
    
    fileprivate (set) var title : String?
    fileprivate (set) var subtitle : String?
    fileprivate (set) var btnText : String?
    fileprivate (set) var icon : UIImage?

    init(withType cellType:CellTypes) {
        self.type = cellType
    }
    
    init(infoCellWithTitle title:String?, btnText:String?, icon:UIImage?){
        self.title = title
        self.btnText = btnText
        self.icon = icon
        self.type = .InfoCell
    }
    
}

class PortfolioTradeCellViewModel : PortfolioCellViewModel {
    
    let portfolioModel:PortfolioModel

    init(withPortFolioModel portfolioModel:PortfolioModel) {
        self.portfolioModel = portfolioModel
        super.init(withType: .TradeCell)
    }
    
    func getCellTitle()->String {
        return "\(self.portfolioModel.coin?.name ?? defaultNoDataValue)"
    }
    
    func getTotalCoinAmount()->String {
        return "\(Utils.formatAmount(self.portfolioModel.amount, decimalPlaces: Constants.decimalPlaces.CPYPTOCURRENCY, currencySymbol: "")) \(self.portfolioModel.coin?.symbol ?? "")"
    }
    
    func getTotalUSDValue()->String{
        return Utils.formatAmount(self.portfolioModel.priceUSD, decimalPlaces: Constants.decimalPlaces.USD_DOLLAR, currencySymbol: Constants.symbols.USD_DOLLAR)
    }
}

class PortfolioViewModel: NSObject {
    
    fileprivate var cellsVM = [PortfolioCellViewModel]()
    
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
    
    func updateCellsVM(){
        cellsVM = [PortfolioCellViewModel]()
        var totalUSDCost = 0.0;
        for portfolio in realmDataSource.getAllPortfolios() {
            let cellVM = PortfolioTradeCellViewModel(withPortFolioModel: portfolio)
            cellsVM.append(cellVM)
            totalUSDCost += portfolio.priceUSD
        }
        if (cellsVM.count == 0){
            let cellVM = PortfolioCellViewModel(infoCellWithTitle: "Press download to download your portfolio".localized(), btnText: "Download".localized(), icon: UIImage(named: "chip")?.withRenderingMode(.alwaysTemplate))
            cellsVM.append(cellVM)
        }
        else {
            let cellVM = PortfolioCellViewModel(withType: .TitleCell)
            var decimalPlaces = Constants.decimalPlaces.USD_DOLLAR
            if totalUSDCost > 1000 {
                decimalPlaces = 0
            }
            cellVM.title = Utils.formatAmount(totalUSDCost, decimalPlaces: decimalPlaces, currencySymbol: Constants.symbols.USD_DOLLAR)
            cellVM.subtitle = "(Total Value)".localized()
            cellsVM.insert(cellVM, at: 0)
        }
    }
    
    func getCellVM(atIndex index:Int)->PortfolioCellViewModel?{
        guard index < self.cellsVM.count, index >= 0 else {
            return nil
        }
        return self.cellsVM[index]
    }
    
    func getNumberOfCells()->Int{
        return self.cellsVM.count
    }

}
