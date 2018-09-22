//
//  BaseDataSource.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit
import Alamofire

public enum NetworkDataSourceError : Error {
    case RequestError
    case NetworkError
    case NoAuthorized
    
    func getLocalizedErrorDescription()->String {
        switch self {
        case .NetworkError:
            return "No internet connection, try again later".localized()
        default:
            return "Error, try again later".localized()
        }
    }
}

public class NetworkDataSource: NSObject {
    
    fileprivate let defaultHTTPheaders : HTTPHeaders?
    
    init(withHTTPheaders httpHeaders:HTTPHeaders){
        self.defaultHTTPheaders = httpHeaders;
    }
    
    private func log(_ items: Any...){
        #if DEBUG
        print(items)
        #endif
    }
    
    private func prepareHeaders(additionalHeaders:HTTPHeaders?)->HTTPHeaders? {
        guard let baseHeaders = self.defaultHTTPheaders else {
            return additionalHeaders;
        }
        return baseHeaders.merging(additionalHeaders ?? [:] , uniquingKeysWith: {$1})
    }
    
    private func performRequest<T:Codable>(method: HTTPMethod, urlRequest : String, parameters:[String:Any]?, parametersEncoding encoding: ParameterEncoding, headers : HTTPHeaders?, responseObject:T.Type, completionHandler: (@escaping (NetworkDataSourceError?, Codable?) -> Void)) {
        
        guard let network = NetworkReachabilityManager(), network.isReachable else {
            completionHandler(NetworkDataSourceError.NetworkError,nil)
            return
        }
        
        Alamofire.request(urlRequest, method:method, parameters: parameters, encoding:encoding, headers:self.prepareHeaders(additionalHeaders: headers))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data, let responseDecoded = try? JSONDecoder().decode(T.self, from: data) {
                        completionHandler(nil, responseDecoded)
                    }
                    else {
                        completionHandler(NetworkDataSourceError.RequestError, nil)
                    }
                case .failure (let error):
                    self.log("Request error: \(error)")
                    var customErrror : NetworkDataSourceError = NetworkDataSourceError.RequestError
                    if let errorCode = response.response?.statusCode {
                        if (errorCode == 401) {
                            customErrror = NetworkDataSourceError.NoAuthorized
                        }
                    }
                    completionHandler(customErrror,nil);
                    break;
                }
            })
    }
    
    public func getRequest<T:Codable>(urlRequest : String, parameters:[String:Any]?, headers : HTTPHeaders?=nil, responseObject:T.Type, completionHandler: (@escaping (NetworkDataSourceError?, Codable?) -> Void)){
        self.performRequest(method: .get, urlRequest: urlRequest, parameters: parameters, parametersEncoding: URLEncoding.default, headers: self.prepareHeaders(additionalHeaders: headers), responseObject: responseObject) { (error, responseObject) in
            self.log("[GET]\(urlRequest):",responseObject.debugDescription)
            completionHandler(error,responseObject)
        }
    }
    
    public func postRequest<T:Codable>(urlRequest : String, parameters:Parameters?, headers : HTTPHeaders?=nil, responseObject:T.Type, completionHandler: (@escaping (NetworkDataSourceError?, Codable?) -> Void)){
        self.performRequest(method: .post, urlRequest: urlRequest, parameters: parameters, parametersEncoding: JSONEncoding.default, headers: self.prepareHeaders(additionalHeaders: headers), responseObject: responseObject) { (error, responseObject) in
            self.log("[POST]\(urlRequest):",responseObject.debugDescription)
            completionHandler(error,responseObject)
        }
    }
}
