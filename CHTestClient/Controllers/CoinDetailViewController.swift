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

    @IBOutlet weak var chartView: LineChartView!
    
    fileprivate (set) var viewModel : CoinDetailViewModel!
    
    static func storyBoardInstance(withCoinModel coinModel:CoinData)->CoinDetailViewController {
        let vc = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CoinDetailViewController") as! CoinDetailViewController
        vc.viewModel = CoinDetailViewModel(withCoinModel: coinModel)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.useLargeTitleAtNavigationBar = false
        configureChart()
        self.title = viewModel.getTitle()
        self.downloadChartData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // One hour
        self.leftPercentatgeView.titleColor = self.viewModel.getOneHourChangeColor()
        self.leftPercentatgeView.configureCenter(title: self.viewModel.getOneDayChangeValue(), subtitle: "Last Hour".localized())
        
        // 24 hours
        self.midPercentatgeView.titleColor = self.viewModel.get24HoursChangeColor()
        self.midPercentatgeView.configureCenter(title: self.viewModel.getOneDayChangeValue(), subtitle: "Last 24 Hours".localized())
        
        // 7 days
        self.rightPercentatgeView.titleColor = self.viewModel.get7DaysChangeColor()
        self.rightPercentatgeView.configureCenter(title: self.viewModel.getSevenDaysChangeValue(), subtitle: "Last 7 days".localized())
    }
    

    override func stopDownload(withError error: NetworkDataSourceError?) {
        if let error = error, error != .NetworkError {
            // Show custom message
            self.showAlert(title: "Error".localized(), message: "Error fetching the chart data".localized(), leftTextButton: "Try Again".localized(), rightTextButton: "Cancel".localized(), alertType: .error)
            super.stopDownload(withError: nil)
            return
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
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = true
        
        chartView.xAxis.labelPosition = .bottom
        
        chartView.xAxis.labelTextColor = Constants.colors.defaultColor
        chartView.xAxis.drawAxisLineEnabled = true
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLabelsEnabled = false

        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        
        //leftAxis
        chartView.leftAxis.enabled = false
        
        //Marker
        
        //Legend
        chartView.legend.form = .none
        chartView.legend.enabled = false
        
        chartView.noDataText = "No data available".localized()
        chartView.noDataTextColor = Constants.colors.defaultColor
    
    }
    
    func prepareChartData(){
        var values = [ChartDataEntry]()
        var x :Double = 0
        for value in self.viewModel.getChartData() where value.snapshot_at != nil && value.price_usd != nil && Double(value.price_usd!) != nil{
            let chartDataEntry = ChartDataEntry(x: x, y: Double(value.price_usd!)!)
            x += 1;
            values.append(chartDataEntry)
        }
        
        let set = LineChartDataSet(values: values, label: "")
        //        set1.mode = .horizontalBezier
        set.drawIconsEnabled = false
        set.drawIconsEnabled = true
        
        set.highlightLineDashLengths = [5, 0]
        set.setColor(.white)
        set.setCircleColor(.white)
        set.lineWidth = 2
        set.circleRadius = 0
        set.drawCircleHoleEnabled = false
        set.valueFont = .systemFont(ofSize: 9)
        set.drawValuesEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = UIColor.yellow
        set.highlightLineWidth = 2
        set.formLineDashLengths = [5, 2.5]
        set.formLineWidth = 10
        set.formSize = 15
        
        set.drawFilledEnabled = false
        set.label = nil
        
        let data = LineChartData(dataSet: set)
        chartView.data = data
    }
    
    func showChart(){
        chartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
}

extension CoinDetailViewController : ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
}
