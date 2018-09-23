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
    func startDownload()
    func stopDownload(withError error:NetworkDataSourceError?)
}

class BaseViewController: UIViewController, NetworkingViewProtocol {

    var useLargeTitleAtNavigationBar : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        JustHUD.setBackgroundColor(color: UIColor.black, automaticTextColor: true)
        JustHUD.setLoaderColor(color: Constants.colors.defaultColor)

        navigationItem.largeTitleDisplayMode = .automatic;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = useLargeTitleAtNavigationBar;
    }
    
    //MARK: - UI Methods

    func showHud(){
        JustHUD.shared.showInView(view: self.view)
    }
    
    func hideHud(){
        JustHUD.shared.hide()
    }
    
    func showAlert(title:String?, message:String?, leftTextButton:String?, rightTextButton:String?, alertType:CDAlertViewType){
        guard view.window != nil else {
            return
        }
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
    
    open func alertLeftActionPressed(){
        // Override for custom action
    }
    
    open func alertRightActionPressed(){
        // Override for custom action
    }
    
    ///Override for custom right alert text button
    open func getLeftButtonDownloadErrorText()->String?{
        return "OK".localized()
    }
    
    ///Override for custom right alert text button
    open func getRightButtonDownloadErrorText()->String?{
        return nil
    }
    
    
    //MARK: - Networking protocol
    func startDownload() {
        showHud()
    }
    
    func stopDownload(withError error: NetworkDataSourceError?) {
        if let error = error {
            var alertType : CDAlertViewType = .error
            if (error == .NetworkError) {
                alertType = .warning
            }
            self.showAlert(title: "Error".localized(), message: error.getLocalizedErrorDescription(), leftTextButton: self.getLeftButtonDownloadErrorText(), rightTextButton: self.getRightButtonDownloadErrorText(), alertType: alertType)
        }
        hideHud()
    }
    
    func isForceTouchAvailable()->Bool{
        return self.traitCollection.forceTouchCapability == .available
    }

}
