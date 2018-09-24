//
//  CoinDetailViewController.swift
//  CHTestClient
//
//  Created by Alejandro Quibus on 22/9/18.
//  Copyright © 2018 Alejandro Quibus. All rights reserved.
//

import UIKit
import Charts

class CoinDetailViewController: BaseViewController {
    
    @IBOutlet private weak var leftPercentatgeView: PercentatgeView!
    @IBOutlet private weak var midPercentatgeView: PercentatgeView!
    @IBOutlet private weak var rightPercentatgeView: PercentatgeView!

    @IBOutlet private weak var chartView: LineChartView!
    
    @IBOutlet private weak var lblValue: UILabel!
    @IBOutlet private weak var lblInfo: UILabel!
    
    
    fileprivate (set) var viewModel : CoinDetailViewModel!
    
    static func storyBoardInstance(withCoinModel coinModel:CoinData)->CoinDetailViewController {
        let vc = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CoinDetailViewController") as! CoinDetailViewController
        vc.viewModel = CoinDetailViewModel(withCoinModel: coinModel)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.useLargeTitleAtNavigationBar = false
        configureChart()
        updateLegendValues(nil)
        self.title = viewModel.getTitle()
        self.downloadChartData()
        self.chartView.noDataText = "Downloading chart data...".localized()
        
        //Option to Exchange the cryptocurrency
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
    }
    
    override func showHud() {
        JustHUD.shared.showInView(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // One hour
        self.leftPercentatgeView.titleColor = self.viewModel.getOneHourChangeColor()
        self.leftPercentatgeView.configureCenter(title: self.viewModel.getOneHourChangeValue(), subtitle: "Last Hour".localized())
        
        // 24 hours
        self.midPercentatgeView.titleColor = self.viewModel.get24HoursChangeColor()
        self.midPercentatgeView.configureCenter(title: self.viewModel.getOneDayChangeValue(), subtitle: "Last 24 Hours".localized())
        
        // 7 days
        self.rightPercentatgeView.titleColor = self.viewModel.get7DaysChangeColor()
        self.rightPercentatgeView.configureCenter(title: self.viewModel.getSevenDaysChangeValue(), subtitle: "Last 7 days".localized())
    }
    
    override func getLeftButtonDownloadErrorText() -> String? {
        return "Try Again".localized()
    }
    
    override func getRightButtonDownloadErrorText() -> String? {
        return "Cancel".localized()
    }

    override func stopDownload(withError error: NetworkDataSourceError?) {
        if error != nil {
            chartView.noDataText = "No data available".localized()
            chartView.notifyDataSetChanged()
        }
        else {
            prepareChartData()
            showChart()
        }
        super.stopDownload(withError: error)
    }
    
    override func alertLeftActionPressed() {
        downloadChartData()
    }
    
    func downloadChartData(){
        self.viewModel.loadHistoric(delegate: self)
    }
    
    func configureChart(){
        chartView.noDataTextColor = Constants.colors.defaultColor
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = true
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawAxisLineEnabled = true
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.labelTextColor = Constants.colors.defaultColor

        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.legend.enabled = false
    }
    
    func prepareChartData(){
        var values = [ChartDataEntry]()
        var x :Double = 0
        for value in self.viewModel.getChartData(){
            let chartDataEntry = ChartDataEntry(x: x, y: value.usdValue)
            x += 1;
            chartDataEntry.data = value
            values.append(chartDataEntry)
        }
        
        let set = LineChartDataSet(values: values, label: "")
        set.mode = .horizontalBezier
        set.drawIconsEnabled = false
        set.drawIconsEnabled = true
        
        set.highlightLineDashLengths = [5, 0]
        set.setColor(Constants.colors.defaultColor)
        set.setCircleColor(Constants.colors.defaultColor)
        set.lineWidth = 2
        set.circleRadius = 0
        set.drawCircleHoleEnabled = false
        set.valueFont = .systemFont(ofSize: 9)
        set.drawValuesEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = Constants.colors.highlightColor
        set.highlightLineWidth = 2
        set.formLineDashLengths = [5, 2.5]
        set.formLineWidth = 8
        set.formSize = 15
        
        set.drawFilledEnabled = false
        set.label = nil
        
        let data = LineChartData(dataSet: set)
        chartView.data = data
    }
    
    func showChart(){
        chartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    @objc func addPressed(){
        let navC = ExchangeViewController.storyBoardInstanceWithNavigationController(withCoinModel: self.viewModel.coinModel)
        self.present(navC, animated: true, completion: nil)
    }
}

extension CoinDetailViewController : ChartViewDelegate {
    
    func updateLegendValues(_ historicalModel:CoinHistoricalChartModel?){
        if let historical = historicalModel {
            self.lblValue.text = historical.getFormattedValue()
            self.lblInfo.text = historical.getFormattedDate()
        }
        else {
            self.lblInfo.text = nil
            self.lblValue.text = nil
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.updateLegendValues(entry.data as? CoinHistoricalChartModel)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.updateLegendValues(nil)
    }
}
