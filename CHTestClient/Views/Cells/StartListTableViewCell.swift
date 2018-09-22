//
//  StartListTableViewCell.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

protocol StartListTableViewCellProtocol : class {
    func btnPressed()
}

class StartListTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    weak var delegate : StartListTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        delegate?.btnPressed()
    }
    
    func configure(withViewModel cellViewModel:CryptocurrenciesListCellViewModel) {
        self.lblTitle.text = cellViewModel.title
        if let textButton = cellViewModel.buttonText {
            btn.isHidden = false
            btn.setTitle(textButton, for: .normal)
        }
        else {
            btn.isHidden = true
        }
        iconImageView.image = cellViewModel.icon
    }
}
