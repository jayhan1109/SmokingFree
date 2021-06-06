//
//  StatViewController.swift
//  SmokingFree
//
//  Created by Jeongho Han on 2021-06-04.
//

import UIKit
import Charts

class StatViewController: UIViewController {
    
    var monthData: [Int:Int] = [:]
    var weekData: [Int:Int] = [:]
    
    var xAxis: [Int]?
    var yAxis: [Int]?
    
    var yMaximum = 7.0
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMonthData()
        getWeekData()
        
        showWeekData()
        
        descLabel.text = "Days of saving money by weekly"
        
        setChart(x: xAxis!, y: yAxis!)
    }
    
    func setChart(x: [Int], y: [Int]){
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<x.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(y[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Days")
        
        chartDataSet.colors = [.systemTeal]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.legend.font = UIFont(name: "HelveticaNeue", size: 15.0)!
        
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.xAxis.setLabelCount(x.count, force: false)
        
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.xAxis.drawLabelsEnabled=false
        
        barChartView.leftAxis.axisMaximum = yMaximum
        
        barChartView.leftAxis.axisMinimum = 0.0
        
        barChartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue", size: 20.0)!
        
        barChartView.rightAxis.enabled = false
        
        barChartView.drawValueAboveBarEnabled = false
        
        barChartView.drawBarShadowEnabled = false
        
        chartDataSet.highlightEnabled = false
        
        barChartView.doubleTapToZoomEnabled = false
        
        barChartView.barData?.setDrawValues(false)
    }
    
    func getWeekData(){
        var yearKey = K.CurrentDate.currentYear
        var weekKey = K.CurrentDate.currentWeek
        
        for i in 0...6{
            if weekKey - i < 1 {
                yearKey -= 1
                weekKey = 58
            }
            
            weekData[(weekKey-i)] = K.DB.integer(forKey: "\(yearKey)/\(weekKey-i)")
        }
    }
    
    func getMonthData(){
        var yearKey = K.CurrentDate.currentYear
        var monthKey = K.CurrentDate.currentMonth
        
        for i in 0...6{
            if monthKey - i < 1 {
                yearKey -= 1
                monthKey = 18
            }
            
            monthData[(monthKey-i)] = K.DB.integer(forKey: "\(yearKey)/\(monthKey-i)")
        }
    }
    
    func showWeekData(){
        let xCollection = weekData.keys
        let yCollection = weekData.values
        xAxis = Array(xCollection)
        yAxis = Array(yCollection)
        yMaximum = Double(yAxis?.max() ?? 0) + 1.0
        
        descLabel.text = "Days of saving money by weekly"
    }
    
    func showMonthData(){
        let xCollection = monthData.keys
        let yCollection = monthData.values
        xAxis = Array(xCollection)
        yAxis = Array(yCollection)
        yMaximum = Double(yAxis?.max() ?? 0) + 1.0
        
        descLabel.text = "Days of saving money by monthly"
    }
    
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
