//
//  PortfolioViewController.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 23/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class PortfolioViewController: BaseViewController {

    fileprivate let viewModel = PortfolioViewModel()
    @IBOutlet weak var portfolioTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Portfolio".localized()
        
        portfolioTableView.tableFooterView = UIView()
        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        viewModel.loadPortfolio(delegate: self)
    }

}

extension PortfolioViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
    }
    
    
}
