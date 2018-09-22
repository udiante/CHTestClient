//
//  CryptojetioDataSource.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import Foundation

class CryptojetioDataSource : NSObject {
    
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
    
    fileprivate static let networkDataSource = NetworkDataSource.init(withHTTPheaders: ["Accept":"application/json"])
    
    fileprivate static let baseURL = "http://localhost:8080/" //Fast Mocked enviorement
//    fileprivate static let baseURL = "https://test.cryptojet.io/" //Test project with only one enviorement

    fileprivate static let basicAuthHeader = ["Authorization":"Basic cmljaGFyZEByaWNoLmNvbTpzZWNyZXQ="] //Test project without users/session logic
    
    
    
    static func getCoins(completionHandler: (@escaping (NetworkDataSourceError?, CoinResponse?) -> Void)){
        let requestUrl = Endpoints.coins.getFullPath(baseURL: baseURL)
        self.networkDataSource.getRequest(urlRequest: requestUrl, parameters: nil, responseObject: CoinResponse.self) { (error, response) in
            guard error == nil, let responseObject = response as? CoinResponse else {
                completionHandler(error ?? NetworkDataSourceError.RequestError,nil)
                return
            }
            completionHandler(nil,responseObject)
        }
    }
    
    //The API service returns the pagination of the pages with an absolute URL
    static func getCoins(atPage requestUrl:String, completionHandler: (@escaping (NetworkDataSourceError?, CoinResponse?) -> Void)){
        self.networkDataSource.getRequest(urlRequest: requestUrl, parameters: nil, responseObject: CoinResponse.self) { (error, response) in
            guard error == nil, let responseObject = response as? CoinResponse else {
                completionHandler(error ?? NetworkDataSourceError.RequestError,nil)
                return
            }
            completionHandler(nil,responseObject)
        }
    }
    
    static func getCoinDetail(withCoinIdentifier coinIdentifier:String, completionHandler: (@escaping (NetworkDataSourceError?, CoinDetailResponse?) -> Void)){
        let requestUrl = Endpoints.coinDetail.getFullPath(baseURL: baseURL,resourceIdentifier: coinIdentifier)
        self.networkDataSource.getRequest(urlRequest: requestUrl, parameters: nil, responseObject: CoinDetailResponse.self) { (error, response) in
            guard error == nil, let responseObject = response as? CoinDetailResponse else {
                completionHandler(error ?? NetworkDataSourceError.RequestError,nil)
                return
            }
            completionHandler(nil,responseObject)
        }
    }
    
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
    
}
