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

    var navHeight: CGFloat = 64
    var tabHeight: CGFloat = 49
    
    var barChartView = BarChartView()
    var pieChartView = PieChartView()
    
    var data: [String: Int] = [:]
    var names: [String] = []
    var descriptionLabel = ""
    
    var colors: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIScreen.main.nativeBounds.height == 2436 {
            navHeight = 88
            tabHeight = 83
        }
        
        createBarChartView()
        createPieChartView()
        
        let barButton = UIBarButtonItem(image: UIImage(named: "diagram_button"), style: .plain, target: self, action: #selector(self.tapDiagramButton(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
        self.view.addSubview(barChartView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createBarChartView() {
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
        
        barChartView.legend.form = .square
        
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        var values: [Int] = []
        for index in 0...names.count-1 {
            let name = names[index]
            if let num = data[name] {
                values.append(num)
            }
        }
        setBarChart(dataPoints: names, values: values)
        barChartView.barData?.setDrawValues(false)
        barChartView.frame = CGRect(x: 10, y: navHeight+10, width: self.view.bounds.width-20, height: self.view.bounds.height-navHeight-tabHeight-20)
        self.view.addSubview(barChartView)
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(saveBarChartView))
        tap.minimumPressDuration = 0.6
        barChartView.isUserInteractionEnabled = true
        barChartView.addGestureRecognizer(tap)
    }
    
    func createPieChartView() {
        pieChartView.noDataText = "Недостаточно данных для построения графика"
        pieChartView.chartDescription?.text = descriptionLabel
        pieChartView.chartDescription?.position = CGPoint(x: self.view.bounds.width/2, y: 10)
        pieChartView.chartDescription?.textAlign = .center
        pieChartView.chartDescription?.font = UIFont(name: "Verdana", size: 12)!
        
        pieChartView.backgroundColor = UIColor.white
        pieChartView.layer.borderWidth = 0.7
        pieChartView.layer.borderColor = UIColor.lightGray.cgColor
        pieChartView.layer.cornerRadius = 20
        pieChartView.clipsToBounds = true
        
        pieChartView.legend.form = .circle
        pieChartView.legend.xOffset = 15
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        var values: [Int] = []
        for index in 0...names.count-1 {
            let name = names[index]
            if let num = data[name] {
                values.append(num)
            }
        }
        setPieChart(dataPoints: names, values: values)
        pieChartView.data?.setDrawValues(false)
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.frame = CGRect(x: 10, y: navHeight+10, width: self.view.bounds.width-20, height: self.view.bounds.height-navHeight-tabHeight-20)
        self.view.addSubview(pieChartView)
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(savePieChartView))
        tap.minimumPressDuration = 0.6
        pieChartView.isUserInteractionEnabled = true
        pieChartView.addGestureRecognizer(tap)
    }
    
    func setBarChart(dataPoints: [String], values: [Int]) {
        
        var chartDataSets: [BarChartDataSet] = []
        
        for index in 0...dataPoints.count-1 {
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(values[index]))
            let chartDataSet = BarChartDataSet(values: [dataEntry], label: dataPoints[index])
            
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
            chartDataSet.colors = [color]
            
            chartDataSet.valueFont = UIFont(name: "Verdana-Bold", size: 10)!
            chartDataSets.append(chartDataSet)
        }
        
        let chartData = BarChartData(dataSets: chartDataSets)
        barChartView.data = chartData
    }
    
    func setPieChart(dataPoints: [String], values: [Int]) {
        
        var dataEntries: [PieChartDataEntry] = []
        
        for index in 0...dataPoints.count-1 {
            let dataEntry = PieChartDataEntry(value: Double(values[index]), label: dataPoints[index]/*, data: dataPoints[index] as AnyObject*/)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.colors = self.colors
        pieChartDataSet.valueFont = UIFont(name: "Verdana-Bold", size: 10)!
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
    }
    
    @objc func tapDiagramButton(sender: UIBarButtonItem) {
        let barButton = UIBarButtonItem(image: UIImage(named: "chart_button"), style: .plain, target: self, action: #selector(self.tapChartButton(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
        
        barChartView.removeFromSuperview()
        self.view.addSubview(pieChartView)
        pieChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    @objc func tapChartButton(sender: UIBarButtonItem) {
        let barButton = UIBarButtonItem(image: UIImage(named: "diagram_button"), style: .plain, target: self, action: #selector(self.tapDiagramButton(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
        
        pieChartView.removeFromSuperview()
        self.view.addSubview(barChartView)
        barChartView.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    @objc func saveBarChartView() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancelAction)
        
        let action = UIAlertAction(title: "Сохранить на устройстве", style: .default) { action in
            self.barChartView.layer.borderWidth = 0
            if let image = self.barChartView.getChartImage(transparent: false) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            self.barChartView.layer.borderWidth = 0.7
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @objc func savePieChartView() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancelAction)
        
        let action = UIAlertAction(title: "Сохранить на устройстве", style: .default) { action in
            self.pieChartView.layer.borderWidth = 0
            if let image = self.pieChartView.getChartImage(transparent: false) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            self.pieChartView.layer.borderWidth = 0.7
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
