//
//  PercentatgeView.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class PercentatgeView: UIView {

    @IBOutlet weak private var lblPercentatge: UILabel!
    @IBOutlet weak private var lblDescription: UILabel!
    @IBOutlet weak private var contentView: UIView!
    
    var titleColor : UIColor? {
        didSet {
            self.lblPercentatge.textColor = titleColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibInit()
    }
    
    private func xibInit(){
        Bundle.main.loadNibNamed("PercentatgeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }

    func configureCenter(title:String, subtitle:String){
        setText(title: title, subtitle: subtitle)
        self.lblPercentatge.textAlignment = .center
        self.lblDescription.textAlignment = .center
    }
    
    func configureRight(title:String, subtitle:String){
        setText(title: title, subtitle: subtitle)
        self.lblPercentatge.textAlignment = .right
        self.lblDescription.textAlignment = .right

    }
    
    func setText(title:String, subtitle:String) {
        self.lblPercentatge.text = title
        self.lblDescription.text = subtitle
    }
}
