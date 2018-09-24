//
//  CryptojetioDataSource.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import Foundation

/// Data Source to provide an easy access to the Cryptojet.io API service.
class CryptojetioDataSource : NSObject {
    
    fileprivate static let realmDataSource = RealmDataSource()
    
    fileprivate enum Endpoints : String  {
        case coins = "coins"
        case coinDetail = "coins/:id"
        case coinHistorical = "coins/:id/historical"
        case portfolio = "portfolio"
        
        func getFullPath(baseURL:String, resourceIdentifier:String?=nil)->String{
            var endPoint = self.rawValue
            if let resourceId = resourceIdentifier {
                endPoint = endPoint.replacingOccurrences(of: ":id", with: resourceId)
            }
            return "\(baseURL)\(endPoint)"
        }
    }
    
    fileprivate static let networkDataSource = NetworkDataSource(withHTTPheaders: ["Accept":"application/json"])
    
    fileprivate static let baseURL = "https://test.cryptojet.io/" //Test project with only one enviorement

    fileprivate static let basicAuthHeader = ["Authorization":"Basic cmljaGFyZEByaWNoLmNvbTpzZWNyZXQ="] //Test project without users/session logic
    
    //MARK: - Public methods
    
    /**
     Request to the Cryptojet.io API service the first page of Cryptocurrencies.
     - Parameter completionHandler: Callback with the response or error.
     */
    static func getCoins(completionHandler: (@escaping (NetworkDataSourceError?, CoinResponse?) -> Void)){
        let requestUrl = Endpoints.coins.getFullPath(baseURL: baseURL)
        self.networkDataSource.getRequest(urlRequest: requestUrl, parameters: nil, responseObject: CoinResponse.self) { (error, response) in
            self.processCoinsResponse(error: error, response: response, completionHandler: completionHandler)
        }
    }
    
    /**
     Request to the Cryptojet.io API service a especific page of Cryptocurrencies. The API service doesn't allow a pagination by parameter or session and returns an absolute URL with the next page.
     - Parameter requestUrl: Page URL with the page to download.
     - Parameter completionHandler: Callback with the response or error.
     */
    static func getCoins(atPage requestUrl:String, completionHandler: (@escaping (NetworkDataSourceError?, CoinResponse?) -> Void)){
        self.networkDataSource.getRequest(urlRequest: requestUrl, parameters: nil, responseObject: CoinResponse.self) { (error, response) in
            self.processCoinsResponse(error: error, response: response, completionHandler: completionHandler)
        }
    }
    
    /**
     Request to the Cryptojet.io API service a specific cryptocurrency coin detail.
     - Parameter coinIdentifier: API coin identifier of the cryptocurrency.
     - Parameter completionHandler: Callback with the response or error.
     */
    static func getCoinDetail(withCoinIdentifier coinIdentifier:String, completionHandler: (@escaping (NetworkDataSourceError?, CoinDetailResponse?) -> Void)){
        let requestUrl = Endpoints.coinDetail.getFullPath(baseURL: baseURL,resourceIdentifier: coinIdentifier)
        self.networkDataSource.getRequest(urlRequest: requestUrl, parameters: nil, responseObject: CoinDetailResponse.self) { (error, response) in
            guard error == nil, let responseObject = response as? CoinDetailResponse else {
                completionHandler(error ?? NetworkDataSourceError.RequestError,nil)
                return
            }
            saveCoinDataInRealm(coinData: responseObject.coin)
            completionHandler(nil,responseObject)
        }
    }
    
    /**
     Request to the Cryptojet.io API service a specific cryptocurrency coin historical detail.
     - Parameter coinIdentifier: API coin identifier of the cryptocurrency.
     - Parameter completionHandler: Callback with the response or error.
     */
    static func getCoinHistorical(withCoinIdentifier coinIdentifier:String, completionHandler: (@escaping (NetworkDataSourceError?, HistoricalResponse?) -> Void)){
        let requestUrl = Endpoints.coinHistorical.getFullPath(baseURL: baseURL,resourceIdentifier: coinIdentifier)
        self.networkDataSource.getRequest(urlRequest: requestUrl, parameters: nil, responseObject: HistoricalResponse.self) { (error, response) in
            guard error == nil, let responseObject = response as? HistoricalResponse else {
                completionHandler(error ?? NetworkDataSourceError.RequestError,nil)
                return
            }
            completionHandler(nil,responseObject)
        }
    }
    
    /**
     Request to the Cryptojet.io API the Portfolio of the user.
     - Parameter completionHandler: Callback with the response or error.
     */
    static func getPortfolio(completionHandler: (@escaping (NetworkDataSourceError?, PortfolioResponse?) -> Void)){
        let requestURL = Endpoints.portfolio.getFullPath(baseURL: baseURL)
        self.networkDataSource.getRequest(urlRequest: requestURL, parameters: nil, headers: basicAuthHeader, responseObject: PortfolioResponse.self) { (error, response) in
            guard error == nil, let responseObject = response as? PortfolioResponse else {
                completionHandler(error ?? NetworkDataSourceError.RequestError,nil)
                return
            }
            completionHandler(nil,responseObject)
        }
    }
    
    /**
     Creates a new trade at the Cryptojet.io API service.
     - Parameter entryParams: Required parameters to perform the cryptocurrency exchange.
     - Parameter completionHandler: Callback with the response or error.
     */
    static func postTrade(entryParams:PostTradeInput, completionHandler: (@escaping (NetworkDataSourceError?, PostTradeResponse?) -> Void)){
        let requestURL = Endpoints.portfolio.getFullPath(baseURL: baseURL)
        self.networkDataSource.postRequest(urlRequest: requestURL, parameters: entryParams.toDictionary(),  headers: basicAuthHeader, responseObject: PostTradeResponse.self) { (error, response) in
            guard error == nil, let responseObject = response as? PostTradeResponse else {
                completionHandler(error ?? NetworkDataSourceError.RequestError,nil)
                return
            }
            completionHandler(nil,responseObject)
        }
    }
    
    //MARK: - Private methods
    
    static private func processCoinsResponse(error:NetworkDataSourceError?, response:Codable?, completionHandler: (@escaping (NetworkDataSourceError?, CoinResponse?) -> Void)){
        guard error == nil, let responseObject = response as? CoinResponse else {
            completionHandler(error ?? NetworkDataSourceError.RequestError,nil)
            return
        }
        DispatchQueue.global(qos: .background).async {
            // Cathing the coin data for future usage at the portfolio.
            for coinData in responseObject.coins?.data ?? [] {
                saveCoinDataInRealm(coinData: coinData)
            }
        }
        completionHandler(nil,responseObject)
    }
    
    static private func saveCoinDataInRealm(coinData:CoinData?){
        if let coinData = coinData {
            // Updating/Saving the coin for faster portfolio usage
            CryptojetioDataSource.realmDataSource.newCoinModel(withCoinServiceModel: coinData)
        }
    }
    
}
