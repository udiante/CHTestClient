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
    var statusBarStyle : UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.useLargeTitleAtNavigationBar = true

        coinsTableView.register(UINib(nibName: "CoinInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinInfoTableViewCell")
        coinsTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        coinsTableView.register(UINib(nibName: "StartListTableViewCell", bundle: nil), forCellReuseIdentifier: "StartListTableViewCell")
        
        self.title = "Cryptocurrencies".localized()

        coinsTableView.contentInset.top = 20
        coinsTableView.separatorStyle = .none
        coinsTableView.tableFooterView = UIView()
        coinsTableView.delegate = self
        coinsTableView.dataSource = self
        
        coinsTableView.refreshControl = refreshControl
        
        self.refreshData()
        
        if self.isForceTouchAvailable() {
            self.registerForPreviewing(with: self, sourceView: self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func stopDownload(withError error: NetworkDataSourceError?) {
        if let currentRequest = self.viewModel.currentRequest {
            self.reloadData()
            if currentRequest == .currencyListPage {
                // Silent request without warning
                super.stopDownload(withError: nil)
                return
            }
        }
        super.stopDownload(withError: error)
    }
    
    
    override func startDownload() {
        if let currentRequest = self.viewModel.currentRequest, currentRequest == .currencyListPage || refreshControl.isRefreshing {
            // Do not display HUD if a HUD is already present (refreshControl or with the cell LoadingTableViewCell)
            return
        }
        super.startDownload()
    }
    
    func reloadData(){
        self.refreshControl.endRefreshing()
        self.viewModel.updateCellsVM()
        self.coinsTableView.reloadData()
    }
    
    @objc override func refreshData(){
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellVM.type.rawValue, for: indexPath) as? CoinInfoTableViewCell, let cellCoinVM = cellVM as? CryptocurrenciesCoinCellViewModel {
                cell.configure(withViewModel: cellCoinVM)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coin = (self.viewModel.getCellVM(atIndex: indexPath.row) as? CryptocurrenciesCoinCellViewModel)?.coinModel else {
            return
        }
        let vc = CoinDetailViewController.storyBoardInstance(withCoinModel: coin)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CryptocurrenciesListViewController : StartListTableViewCellProtocol {
    func btnPressed() {
        self.refreshData()
    }
}

//MARK: - 3D Touch
extension CryptocurrenciesListViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let cellPosition = self.coinsTableView.convert(location, from: self.view)
        if let indexPath = self.coinsTableView.indexPathForRow(at: cellPosition), let coin = (self.viewModel.getCellVM(atIndex: indexPath.row) as? CryptocurrenciesCoinCellViewModel)?.coinModel {
            let vc = CoinDetailViewController.storyBoardInstance(withCoinModel: coin)
            return vc
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    

}
