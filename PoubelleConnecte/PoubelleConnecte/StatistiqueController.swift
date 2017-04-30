//
//  StatistiqueController.swift
//  PoubelleConnecte
//
//  Created by Tayeb Sedraia on 30/04/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import Charts

class StatistiqueController: UIViewController {
    
    @IBOutlet weak var subContainerView: UIView!
    @IBOutlet weak var refresh: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        
        // 1. create chart view
        let chart = BarChartView(frame: self.subContainerView.frame)
        
        // 2. generate chart data entries
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let yVals: [Int] = [ 3, 8, 30, 10, 50, 30, 23, 40, 90, 10, 40, 100]
        var entries = [ BarChartDataEntry]()
        
        for (i, v) in yVals.enumerated() {
            let entry = BarChartDataEntry()
            entry.x = Double( i)
            entry.y = Double(v)
            
            
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = BarChartDataSet( values: entries, label: "Poubelle")
        let data = BarChartData( dataSet: set)
        chart.data = data
        // no data text
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = false
        
        
        // 3a. style
        /*
         chart.backgroundColor = Palette.Background
         chart.drawValueAboveBarEnabled = false
         chart.xAxis.drawGridLinesEnabled = false
         chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
         chart.leftAxis.drawGridLinesEnabled = false
         chart.rightAxis.drawGridLinesEnabled = false
         
         chart.leftAxis.drawLabelsEnabled = true
         chart.rightAxis.drawLabelsEnabled = false
         chart.leftAxis.labelTextColor = Palette.InfoText
         */
        
        // 3b. animation
        chart.animate(xAxisDuration:  1.0)
        
        //chart.legend.textColor = Palette.InfoText
        chart.chartDescription = nil
        
        
        // 4. add chart to UI
        self.subContainerView.addSubview( chart)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTapped( sender: Any?) {
        // hacky
        self.viewWillAppear( false)
    }
    
}




