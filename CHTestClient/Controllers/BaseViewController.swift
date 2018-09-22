//
//  BaseViewController.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit
import CDAlertView

protocol NetworkingViewProtocol {
    func startDownload(requestIdentifier:String?)
    func stopDownload(requestIdentifier:String?, withError error:NetworkDataSourceError?)
}

class BaseViewController: UIViewController, NetworkingViewProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        JustHUD.setBackgroundColor(color: UIColor.black, automaticTextColor: true)
        JustHUD.setLoaderColor(color: Constants.colors.defaultColor)

        navigationController?.navigationBar.prefersLargeTitles = true;
        navigationItem.largeTitleDisplayMode = .automatic;
    }
    
    //MARK: - UI Methods

    func showHud(){
        JustHUD.shared.showInView(view: self.view)
    }
    
    func hideHud(){
        JustHUD.shared.hide()
    }
    
    func showAlert(title:String?, message:String?, leftTextButton:String?, rightTextButton:String?, alertType:CDAlertViewType){
        let alert = CDAlertView(title: title, message: message, type: alertType)
        if let leftActionText = leftTextButton {
            let actionLeft = CDAlertViewAction(title: leftActionText, font: nil, textColor: nil, backgroundColor: nil) { (action) -> Bool in
                self.alertLeftActionPressed()
                return true
            }
            alert.add(action: actionLeft)
        }
        if let rightActionText = rightTextButton {
            let actionRight = CDAlertViewAction(title: rightActionText, font: nil, textColor: nil, backgroundColor: nil) { (action) -> Bool in
                self.alertRightActionPressed()
                return true
            }
            alert.add(action: actionRight)
        }
        alert.show()
    }
    
    func alertLeftActionPressed(){
        // Override for custom action
    }
    
    func alertRightActionPressed(){
        // Override for custom action
    }
    
    
    //MARK: - Networking protocol
    func startDownload(requestIdentifier:String?) {
        showHud()
    }
    
    func stopDownload(requestIdentifier:String?, withError error: NetworkDataSourceError?) {
        if let error = error {
            var alertType : CDAlertViewType = .error
            if (error == .NetworkError) {
                alertType = .warning
            }
            self.showAlert(title: "Error", message: error.getLocalizedErrorDescription(), leftTextButton: "Aceptar", rightTextButton: nil, alertType: alertType)
        }
        hideHud()
    }

}
