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
        
        portfolioTableView.register(UINib(nibName: "CoinInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinInfoTableViewCell")
        portfolioTableView.register(UINib(nibName: "StartListTableViewCell", bundle: nil), forCellReuseIdentifier: "StartListTableViewCell")
        portfolioTableView.register(UINib(nibName: "PortfolioInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PortfolioInfoTableViewCell")

        portfolioTableView.separatorStyle = .none
        portfolioTableView.tableFooterView = UIView()
        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        portfolioTableView.refreshControl = refreshControl
        self.downloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    override func stopDownload(withError error: NetworkDataSourceError?) {
        super.stopDownload(withError: error)
        reloadData()
    }

    func downloadData(){
        viewModel.loadPortfolio(delegate: self)
    }
    
    func reloadData(){
        self.viewModel.updateCellsVM()
        self.portfolioTableView.reloadData()
    }
    
    @objc override func refreshData(){
        self.downloadData()
    }
}

extension PortfolioViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellVM = self.viewModel.getCellVM(atIndex: indexPath.row) else {
            return UITableViewCell()
        }
        switch cellVM.type {
        case .TradeCell:
            if let cellVM = cellVM as? PortfolioTradeCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: "CoinInfoTableViewCell", for: indexPath) as? CoinInfoTableViewCell {
                cell.configure(withViewModel: cellVM)
                return cell
            }
            return UITableViewCell()
        case .InfoCell:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "StartListTableViewCell", for: indexPath) as? StartListTableViewCell {
                cell.configure(withViewModel: cellVM)
                cell.delegate = self
                return cell
            }
        case .TitleCell:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioInfoTableViewCell", for: indexPath) as? PortfolioInfoTableViewCell {
                cell.configure(withViewModel: cellVM)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension PortfolioViewController : StartListTableViewCellProtocol {
    func btnPressed() {
        self.downloadData()
    }
}
