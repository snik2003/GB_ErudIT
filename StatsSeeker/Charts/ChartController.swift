//
//  ChartController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 07.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit
import Charts

class ChartController: UIViewController {

    var barChartView = BarChartView()
    
    var data: [String: Int] = [:]
    var names: [String] = []
    var descriptionLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barButton = UIBarButtonItem(image: UIImage(named: "diagram_button"), style: .plain, target: self, action: #selector(self.tapBarButtonItem(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
        
        createChartView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createChartView() {
        barChartView.noDataText = "Недостаточно данных для построения графика"
        barChartView.chartDescription?.text = descriptionLabel
        barChartView.chartDescription?.position = CGPoint(x: self.view.bounds.width/2, y: 10)
        barChartView.chartDescription?.textAlign = .center
        barChartView.chartDescription?.font = UIFont(name: "Verdana", size: 12)!
        
        barChartView.backgroundColor = UIColor.white
        barChartView.layer.borderWidth = 0.7
        barChartView.layer.borderColor = UIColor.lightGray.cgColor
        barChartView.layer.cornerRadius = 20
        barChartView.clipsToBounds = true
        
        barChartView.xAxis.drawLabelsEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        var values: [Int] = []
        for index in 0...names.count-1 {
            let name = names[index]
            if let num = data[name] {
                values.append(num)
            }
        }
        setChart(dataPoints: names, values: values)
        
        barChartView.frame = CGRect(x: 10, y: 70, width: self.view.bounds.width-20, height: self.view.bounds.height-70-48-10)
        self.view.addSubview(barChartView)
    }
    
    func setChart(dataPoints: [String], values: [Int]) {
        
        var chartDataSets: [BarChartDataSet] = []
        
        for index in 0...dataPoints.count-1 {
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(values[index]))
            let chartDataSet = BarChartDataSet(values: [dataEntry], label: dataPoints[index])
            
            if index % 5 == 0 {
                chartDataSet.colors = ChartColorTemplates.colorful()
            }
            if index % 5 == 1 {
                chartDataSet.colors = ChartColorTemplates.liberty()
            }
            if index % 5 == 2 {
                chartDataSet.colors = ChartColorTemplates.joyful()
            }
            if index % 5 == 3 {
                chartDataSet.colors = ChartColorTemplates.vordiplom()
            }
            if index % 5 == 4 {
                chartDataSet.colors = ChartColorTemplates.pastel()
            }
            
            chartDataSet.valueFont = UIFont(name: "Verdana-Bold", size: 10)!
            chartDataSets.append(chartDataSet)
        }
        
        let chartData = BarChartData(dataSets: chartDataSets)
        barChartView.data = chartData
    }
    
    @objc func tapBarButtonItem(sender: UIBarButtonItem) {
        
    }
}
