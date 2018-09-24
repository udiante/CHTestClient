//
//  ExchangeViewController.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit
import CDAlertView

class ExchangeViewController: BaseViewController {
    
    fileprivate (set) var viewModel : ExchangeViewModel!
    
    fileprivate var currentAlert : CDAlertView?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblExchange: UILabel!
    
    @IBOutlet weak var lblLeftCryptoAmount: UILabel!
    @IBOutlet weak var txtFieldAmountCryptoCurrency: UITextField!
    
    @IBOutlet weak var lblLeftUSDValue: UILabel!
    @IBOutlet weak var txtFieldUSDValue: UITextField!
    
    @IBOutlet weak var btnExchange: UIButton!
    
    
    static func storyBoardInstance(withCoinModel coinModel:CoinData)->ExchangeViewController {
        let vc = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ExchangeViewController") as! ExchangeViewController
        vc.viewModel = ExchangeViewModel(withCoinModel: coinModel)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    static func storyBoardInstanceWithNavigationController(withCoinModel coinModel:CoinData)->UINavigationController {
        let vc = storyBoardInstance(withCoinModel: coinModel)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.barStyle = .black
        navVC.navigationBar.tintColor = UIColor.white
        navVC.navigationBar.isTranslucent = false
        navVC.navigationBar.shadowImage = UIImage()
        return navVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.useLargeTitleAtNavigationBar = false
        self.title = "New Exchange".localized()
        
        btnExchange.setTitle("Exchange".localized(), for: .normal)
        setButtonEnabled(false)
        
        txtFieldAmountCryptoCurrency.delegate = self
        txtFieldUSDValue.delegate = self
        
        if let navC = self.navigationController, navC.viewControllers.count == 1 {
            // The VC is presented modally with a navC as a root.
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dissmiss))
        }

        txtFieldAmountCryptoCurrency.placeholder = String(format: "Amount to purchase".localized(), self.viewModel.getCoinSymbol())
        txtFieldUSDValue.placeholder = "Amount of dollars to sell".localized()
        
        lblLeftCryptoAmount.text = String(format: "%@ Amount:".localized(), self.viewModel.getCoinSymbol())
        lblLeftUSDValue.text = "USD Amount:".localized()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblTitle.text = self.viewModel.getTitle()
        lblExchange.text = self.viewModel.getSubtitleExchangeRate()
        lblSubtitle.text = self.viewModel.getSubtitleAvailable()
    }
    
    @objc func dissmiss(){
        if let navC = self.navigationController, navC.viewControllers.count > 1 {
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
    
    @IBAction func exchangePressed(_ sender: Any) {
        self.view.endEditing(true)
        guard let alertText = self.viewModel.getAlertMessage() else {
            return
        }
        self.currentAlert = self.showAlert(title: "Confirmation required".localized(), message: alertText, leftTextButton: "Confirm".localized(), rightTextButton: "Cancel".localized(), alertType: .warning)
    }
    
    override func alertLeftActionPressed() {
        guard self.currentAlert != nil else {
            super.alertLeftActionPressed()
            return
        }
        // Action perform exchange
        self.currentAlert = nil
        self.viewModel.performExchange(delegate: self)
    }
    
    override func alertRightActionPressed() {
        guard self.currentAlert != nil else {
            super.alertRightActionPressed()
            return
        }
        // Action cancel exchange
        self.currentAlert = nil
    }
    
    override func stopDownload(withError error: NetworkDataSourceError?) {
        super.stopDownload(withError: error)
        if error == nil {
            // Exchange success
            if let alert = self.showAlert(title: "Success".localized(), message: "Exchange completed".localized(), leftTextButton: nil, rightTextButton: nil, alertType: .success) {
                _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                    alert.hide(isPopupAnimated: false)
                    self.dissmiss()
                }
            }
        }
    }
}

extension ExchangeViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.txtFieldAmountCryptoCurrency.text = nil
        self.txtFieldUSDValue.text = nil
        self.setButtonEnabled(false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newString = NSString(string: text).replacingCharacters(in: range, with: string)
        if (textField == self.txtFieldAmountCryptoCurrency) {
            // Cryptocurrency textfield, the user wants to buy cryptocurrency.
            if let usdEquivalent = self.viewModel.setAmountToExchange(rawValue: newString) {
                self.txtFieldUSDValue.text = usdEquivalent
                self.setButtonEnabled(true)
            }
            else {
                self.txtFieldUSDValue.text = nil
                self.setButtonEnabled(false)
            }
        }
        else {
            // USD textfield, the user wants to obtain USD selling cryptocurrency.
            if let cryptoAmount = self.viewModel.setAmountFromUSD(rawValue: newString) {
                self.txtFieldAmountCryptoCurrency.text = cryptoAmount
                self.setButtonEnabled(true)
            }
            else {
                self.txtFieldAmountCryptoCurrency.text = nil
                self.setButtonEnabled(false)
            }
        }
        return true;
    }
}
