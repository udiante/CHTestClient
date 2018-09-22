//
//  CoinInfoTableViewCell.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class CoinInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblValue: UILabel!
    @IBOutlet private weak var lblPercentatge: UILabel!
    @IBOutlet private weak var lblPercentatgeDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withViewModel cellViewModel:CryptocurrenciesListCellViewModel) {
        self.lblName.text = cellViewModel.name
        self.lblValue.text = cellViewModel.getFormattedUSDAmount()
        self.lblPercentatge.text = cellViewModel.getPercentatgeFormatted()
        self.lblPercentatge.textColor = cellViewModel.getPercentatgeColor()
        self.lblPercentatgeDesc.text = cellViewModel.getPercentatgeDescription()
    }
    
}
