//
//  CoinDetailViewModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class CoinHistoricalChartModel {
    let usdValue : Double
    let dateValue : Date
    
    init?(withHistoricalData historicalModel: Historical) {
        guard let usdStringValue = historicalModel.price_usd, let usdDoubleValue = Double(usdStringValue), let dateTs = historicalModel.snapshot_at, let date = Utils.getDateISO8601(fromString: dateTs) else {
            return nil
        }
        self.usdValue = usdDoubleValue
        self.dateValue = date
        
    }

    func getFormattedValue()->String {
        return Utils.formatAmount(self.usdValue, decimalPlaces: 5, currencySymbol: "$")
    }
    
    func getFormattedDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        return dateFormatter.string(from: self.dateValue)
    }
}

class CoinDetailViewModel: NSObject {
    
    fileprivate let kDefaultDecimalPlaces = 2
    fileprivate var historicalData = [Historical]()

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
        delegate.startDownload()
        CryptojetioDataSource.getCoinHistorical(withCoinIdentifier: String(coinIdentifier)) { (error, response) in
            if let historicData = response?.historical  {
                self.historicalData = historicData
            }
            delegate.stopDownload(withError: error)
        }
    }

    //MARK: - Chart UI
    
    func getChartData()->[CoinHistoricalChartModel] {
        var chartData = [CoinHistoricalChartModel]()
        for data in self.historicalData {
            if let chartVM = CoinHistoricalChartModel(withHistoricalData: data) {
                chartData.append(chartVM)
            }
        }
        return chartData
    }
    
}
