//
//  StatViewController.swift
//  SmokingFree
//
//  Created by Jeongho Han on 2021-06-04.
//

import UIKit
import Charts

class StatViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var descLabel: UILabel!
    
    // MARK: - Properties
    
    var monthData: [Data] = []
    var weekData: [Data] = []
    
    var xAxisLabels: [String] = []
    
    var xAxis: [Int]?
    var yAxis: [Int]?
    
    var yMaximum = 7.0
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStat()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMonthData()
        getWeekData()
        
        showWeekData()
        
        descLabel.text = K.SegmentText.week
        
        setChart(x: xAxis!, y: yAxis!)
    }
    
    // MARK: - Helpers
    
    // Setup the chart with the data
    // The index of segment control determines which one to use between week and month
    func setChart(x: [Int], y: [Int]){
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<x.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(y[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Days")
        chartDataSet.highlightEnabled = false
        chartDataSet.colors = [.systemTeal]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.legend.font = UIFont(name: "HelveticaNeue", size: 15.0)!
        
        // Configure xAxis
        
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.xAxis.setLabelCount(x.count, force: false)
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        
        barChartView.xAxis.drawGridLinesEnabled = false
        
        // Configure leftAxis
        
        barChartView.leftAxis.axisMaximum = yMaximum
        
        barChartView.leftAxis.axisMinimum = 0.0
        
        barChartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue", size: 20.0)!
        
        // Configure rightAxis
        
        barChartView.rightAxis.enabled = false
        
        // Configure other settings
        
        barChartView.drawValueAboveBarEnabled = false
        
        barChartView.drawBarShadowEnabled = false
        
        barChartView.doubleTapToZoomEnabled = false
        
        barChartView.barData?.setDrawValues(false)
    }
    
    // Get recent 7 weeks data
    func getWeekData(){
        
        weekData = []
        
        var yearKey = K.CurrentDate.currentYear
        var weekKey = K.CurrentDate.currentWeek
        
        for i in 0...6{
            if weekKey - i < 1 {
                yearKey -= 1
                weekKey = 52 + i
            }

            weekData.append(Data(key: (weekKey-i), value: K.DB.integer(forKey: "\(yearKey)/\(weekKey-i)")))
        }
        
        weekData.reverse()
    }
    
    // Get recent 7 months data
    func getMonthData(){
        
        monthData = []
        
        var yearKey = K.CurrentDate.currentYear
        var monthKey = K.CurrentDate.currentMonth

        for i in 0...6{
            if monthKey - i < 1 {
                yearKey -= 1
                monthKey = 12 + i
            }

            monthData.append(Data(key: (monthKey-i), value: K.DB.integer(forKey: "\(yearKey)/\(monthKey-i)")))
        }
        
        monthData.reverse()
        
    }
    
    // Show week data to the Segment Control
    func showWeekData(){
        let xCollection = weekData.map { data in
            data.key
        }
        let yCollection = weekData.map { data in
            data.value
        }
        xAxis = Array(xCollection)
        yAxis = Array(yCollection)
        yMaximum = Double(yAxis?.max() ?? 0) + 1.0
        
        xAxisLabels = weekData.map({ data in
            String(data.key)
        })
        
        print(xAxisLabels)
        
        descLabel.text = K.SegmentText.week
    }
    
    // Show month data to the Segment Control
    func showMonthData(){
        let xCollection = monthData.map { data in
            data.key
        }
        let yCollection = monthData.map { data in
            data.value
        }
        xAxis = Array(xCollection)
        yAxis = Array(yCollection)
        yMaximum = Double(yAxis?.max() ?? 0) + 1.0
        
        xAxisLabels = monthData.map({ data in
            String(data.key)
        })
        
        descLabel.text = K.SegmentText.month
    }
    
    // Update stat between week and month by the index of the segment control
    func updateStat() {
        getWeekData()
        getMonthData()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            showWeekData()
            setChart(x: xAxis!, y: yAxis!)
        }else{
            showMonthData()
            setChart(x: xAxis!, y: yAxis!)
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            showWeekData()
            setChart(x: xAxis!, y: yAxis!)
        case 1:
            showMonthData()
            setChart(x: xAxis!, y: yAxis!)
        default:
            break;
        }
    }
}
