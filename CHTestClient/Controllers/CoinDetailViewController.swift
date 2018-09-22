//
//  CoinDetailViewController.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class CoinDetailViewController: BaseViewController {
    
    @IBOutlet weak var leftPercentatgeView: PercentatgeView!
    @IBOutlet weak var midPercentatgeView: PercentatgeView!
    @IBOutlet weak var rightPercentatgeView: PercentatgeView!

    
    fileprivate (set) var viewModel : CoinDetailViewModel!
    
    static func storyBoardInstance(withCoinModel coinModel:CoinData)->CoinDetailViewController {
        let vc = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CoinDetailViewController") as! CoinDetailViewController
        vc.viewModel = CoinDetailViewModel(withCoinModel: coinModel)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.useLargeTitleAtNavigationBar = false

        self.title = viewModel.getTitle()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // One hour
        self.leftPercentatgeView.titleColor = self.viewModel.getOneHourChangeColor()
        self.leftPercentatgeView.configureCenter(title: self.viewModel.getOneDayChangeValue(), subtitle: "Last Hour".localized())
        
        // 24 hours
        self.midPercentatgeView.titleColor = self.viewModel.get24HoursChangeColor()
        self.midPercentatgeView.configureCenter(title: self.viewModel.getOneDayChangeValue(), subtitle: "Last 24 Hours".localized())
        
        // 7 days
        self.rightPercentatgeView.titleColor = self.viewModel.get7DaysChangeColor()
        self.rightPercentatgeView.configureCenter(title: self.viewModel.getSevenDaysChangeValue(), subtitle: "Last 7 days".localized())
    }
    

}
