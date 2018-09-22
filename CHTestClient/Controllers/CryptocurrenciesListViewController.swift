//
//  CryptocurrenciesListViewController.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit

class CryptocurrenciesListViewController: BaseViewController {

    fileprivate let viewModel = CryptocurrenciesListViewModel()
    fileprivate var cells = [CryptocurrenciesListCellViewModel]()
    @IBOutlet private weak var coinsTableView: UITableView!
    fileprivate let refreshControl = UIRefreshControl()
    var statusBarStyle : UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        coinsTableView.register(UINib(nibName: "CoinInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinInfoTableViewCell")
        coinsTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        coinsTableView.register(UINib(nibName: "StartListTableViewCell", bundle: nil), forCellReuseIdentifier: "StartListTableViewCell")
        
        self.title = "Cryptoexchange".localized()

        coinsTableView.contentInset.top = 20
        coinsTableView.separatorStyle = .none
        coinsTableView.tableFooterView = UIView()
        coinsTableView.delegate = self
        coinsTableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        coinsTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func stopDownload(requestIdentifier: String?, withError error: NetworkDataSourceError?) {
        if let currentRequest = self.viewModel.currentRequest {
            if currentRequest == .currencyList || currentRequest == .currencyListPage {
                self.reloadData()
            }
            if currentRequest == .currencyListPage {
                // Silent request without warning
                super.stopDownload(requestIdentifier: nil, withError: nil)
                return
            }
        }
        refreshControl.endRefreshing()
        super.stopDownload(requestIdentifier: requestIdentifier, withError: error)
    }
    
    
    override func startDownload(requestIdentifier: String?) {
        if let currentRequest = self.viewModel.currentRequest, currentRequest == .currencyListPage || refreshControl.isRefreshing {
            return
        }
        super.startDownload(requestIdentifier: nil)
    }
    
    func reloadData(){
        self.refreshControl.endRefreshing()
        self.viewModel.updateCellsVM()
        self.coinsTableView.reloadData()
    }
    
    @objc func refreshData(){
        viewModel.resetCoins()
        viewModel.loadCoins(delegate: self)
    }
    
}

extension CryptocurrenciesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellVM = self.viewModel.getCellVM(atIndex: indexPath.row) else {
            return UITableViewCell()
        }
        switch cellVM.type {
        case .coinInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellVM.type.rawValue, for: indexPath) as? CoinInfoTableViewCell {
                cell.configure(withViewModel: cellVM)
                return cell
            }
        case .loadingInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellVM.type.rawValue, for: indexPath) as? LoadingTableViewCell {
                return cell
            }
        case .messageInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellVM.type.rawValue, for: indexPath) as? StartListTableViewCell {
                cell.configure(withViewModel: cellVM)
                cell.delegate = self
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is LoadingTableViewCell {
            // Load next page
            self.viewModel.loadCoins(delegate: self)
        }
    }
}

extension CryptocurrenciesListViewController : StartListTableViewCellProtocol {
    func btnPressed() {
        self.refreshData()
    }
}
