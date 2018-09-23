//
//  PortfolioViewModel.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class PortfolioViewModel: NSObject {
    
    func loadPortfolio(delegate:NetworkingViewProtocol){
        // Download all user portfolio
        delegate.startDownload()
        CryptojetioDataSource.getPortfolio { (error, response) in
            if let error = error {
                // Abort the download process
                delegate.stopDownload(withError: error)
            }
            
        }
        
        // Find the missing coin details
        
        // Download the missing data
        
    }

}
