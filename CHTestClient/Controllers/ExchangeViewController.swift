//
//  ExchangeViewController.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class ExchangeViewController: BaseViewController {
    
    fileprivate (set) var viewModel : ExchangeViewModel!
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblExchange: UILabel!
    
    @IBOutlet weak var lblLeftAmount: UILabel!
    @IBOutlet weak var txtFieldsAmount: UITextField!
    
    @IBOutlet weak var lblLeftValue: UILabel!
    @IBOutlet weak var txtFieldValue: UITextField!
    
    @IBOutlet weak var btnExchange: UIButton!
    
    
    static func storyBoardInstance(withCoinModel coinModel:CoinData)->ExchangeViewController {
        let vc = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ExchangeViewController") as! ExchangeViewController
        vc.viewModel = ExchangeViewModel(withCoinModel: coinModel)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.useLargeTitleAtNavigationBar = false
        self.title = "New purchase".localized()
        
        btnExchange.setTitle("Exchange".localized(), for: .normal)
        setButtonEnabled(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblTitle.text = self.viewModel.getTitle()
        lblExchange.text = self.viewModel.getSubtitleExchangeRate()
        lblSubtitle.text = self.viewModel.getSubtitleAvailable()
    }
    
    func dissmiss(){
        if let navC = self.navigationController {
            navC.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setButtonEnabled(_ enabled:Bool){
        if enabled {
            btnExchange.setTitleColor(Constants.colors.enabledWhiteStyleColor, for: .normal)
        }
        else {
            btnExchange.setTitleColor(Constants.colors.disabledColor, for: .normal)
        }
        btnExchange.isEnabled = enabled
    }
}
