//
//  CryptocurrenciesListViewModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class CryptocurrenciesListCellViewModel {
    
    enum CellTypeCryptocurrenciesListViewModel : String {
        case coinInfo = "CoinInfoTableViewCell"
        case loadingInfo = "LoadingTableViewCell"
        case messageInfo = "StartListTableViewCell"
    }
    
    fileprivate (set) var title:String?
    fileprivate (set) var buttonText:String?
    fileprivate (set) var icon:UIImage?
    
    fileprivate (set) var name:String?
    fileprivate (set) var currentPrice:String?
    fileprivate (set) var percentatgeChange24Hours:String?
    fileprivate (set) var type:CellTypeCryptocurrenciesListViewModel

    
    init(){
        self.type = .loadingInfo
    }
    
    init(infoType infoTitle:String, btnText:String?, icon:UIImage?){
        self.type = .messageInfo
        self.buttonText = btnText
        self.title = infoTitle
        self.icon = icon
    }
}

class CryptocurrenciesCoinCellViewModel : CryptocurrenciesListCellViewModel {
    
    let coinModel : CoinData?
    
    required init(withCoinModel coinModel:CoinData){
        self.coinModel = coinModel
        super.init()
        self.type = .coinInfo
        self.name = coinModel.name
        self.currentPrice = coinModel.price_usd
        self.percentatgeChange24Hours = coinModel.percent_change_24h
    }
    
    func getFormattedUSDAmount()->String{
        return Utils.formatAmountString(self.currentPrice ?? "0", decimalPlaces: 4, currencySymbol: "$")
    }
    
    func getPercentatgeFormatted()->String {
        return Utils.formattPercent(self.percentatgeChange24Hours ?? "", decimalPlaces: 2);
    }
    
    func getPercentatgeDescription()->String {
        return "Last 24 hours".localized()
    }
    
    func getPercentatgeColor()->UIColor {
        return Utils.colorForValue(self.percentatgeChange24Hours)
    }
}

class CryptocurrenciesListViewModel: NSObject {
    
    var currentRequest : Request?
    
    fileprivate var fetchedCoins : [CoinData] = [CoinData]()
    fileprivate var cellsVM = [CryptocurrenciesListCellViewModel]()
    fileprivate var nextPageUrl : String?
    
    enum Request : String {
        case currencyList
        case currencyListPage
    }
    
    func resetCoins(){
        nextPageUrl = nil
        fetchedCoins.removeAll()
    }
    
    private func requestEnded(withError error:NetworkDataSourceError?, delegate:NetworkingViewProtocol) {
        DispatchQueue.main.async {
            delegate.stopDownload(withError: error)
            self.currentRequest = nil
        }
    }
    
    func loadCoins(delegate:NetworkingViewProtocol){
        guard self.currentRequest == nil else {
            return
        }
        let currencyCompletionHandler : (NetworkDataSourceError?, CoinResponse?) -> Void = { (error, coins) -> Void in
            guard error == nil, let coinsArray = coins?.coins?.data else {
                self.requestEnded(withError: error, delegate: delegate)
                // If happens an error the pagination ends
                self.nextPageUrl = nil
                return
            }
            self.fetchedCoins.append(contentsOf: coinsArray)
            self.nextPageUrl = coins?.coins?.next_page_url
            self.requestEnded(withError: nil, delegate: delegate)
        }
        if let nextPageUrl = self.nextPageUrl{
            // Load next page
            self.currentRequest = .currencyListPage
            delegate.startDownload()
            CryptojetioDataSource.getCoins(atPage: nextPageUrl, completionHandler: currencyCompletionHandler)
        }
        else {
            self.currentRequest = .currencyList
            delegate.startDownload()
            CryptojetioDataSource.getCoins(completionHandler: currencyCompletionHandler)
        }
    }
    
    func updateCellsVM(){
        cellsVM = [CryptocurrenciesListCellViewModel]()
        for coin in self.fetchedCoins {
            let cellVM = CryptocurrenciesCoinCellViewModel(withCoinModel: coin)
            cellsVM.append(cellVM)
        }
        if self.nextPageUrl != nil {
            cellsVM.append(CryptocurrenciesListCellViewModel())
        }
        if self.cellsVM.count == 0 {
            // Retry download
            cellsVM.append(CryptocurrenciesListCellViewModel(infoType: "Press download to retrieve all Cryptocurrencies".localized(), btnText: "Download".localized(), icon: UIImage(named: "chip")?.withRenderingMode(.alwaysTemplate)))
        }
    }
    
    func getCellVM(atIndex index:Int)->CryptocurrenciesListCellViewModel?{
        guard index < self.cellsVM.count, index >= 0 else {
            return nil
        }
        return self.cellsVM[index]
    }
    
    func getNumberOfCells()->Int{
        return self.cellsVM.count
    }
}
