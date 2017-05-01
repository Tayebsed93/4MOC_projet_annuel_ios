//
//  ChartsViewController.swift
//  PoubelleConnecte
//
//  Created by Tayeb Sedraia on 01/05/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit
import Charts
import Alamofire

class ChartsViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    public var addressUrlString = "http://localhost:8888/PoubelleAPI/API/v1"
    
    public var loginUrlString = "/poubelles/date"
    
    var dates = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //callAPIPoubelleDate()
        //updateChartData()
        
        
    }

    
    func updateChartData(money : [Int])  {
        
        //let chart = PieChartView(frame: self.view.frame)
        // 2. generate chart data entries
        let track = ["Janv", "Fev", "Mars", "Avr", "Mai", "Jun","Jui", "Aout","Sept", "Oct", "Nov", "Dec"]
        //var money = [Int]()
        //let money = [10, 20, 10, 10,10, 10,20,10,10,10,10,10]
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = Double(value)
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Pie Chart")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
        //pieChartView.noDataText = "No data available"
        // user interaction
        pieChartView.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "Statistique 2017"
        pieChartView.chartDescription = d
        pieChartView.centerText = "Poubelle"
        pieChartView.holeRadiusPercent = 0.2
        pieChartView.transparentCircleColor = UIColor.clear
        self.view.addSubview(pieChartView)
        
    }
    
    
    
    func alerteMessage(message : String) {
        
        var newMessage = ""
        if (message == "Could not connect to the server." ) {
            newMessage = "Impossible de se connecter au serveur."
            
            let alert = UIAlertController(title: "Erreur", message: newMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

    
}

