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

class StatistiqueController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var test: UIView!
    var passapikey = String()
    var dates = [Int]()
    var newdates = [Int]()
    var mois = [Int]()
    
    @IBOutlet weak var anneeText: UITextField!
    let button = UIButton(type: UIButtonType.custom)
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle("OK", for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(StatistiqueController.Done(_:)), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        self.dates = []
        callAPIPoubelleDate()
        //updateChartData(date: self.dates)

        
    }
    
    func callAPIPoubelleDate() {
        
        
        
        let apiKey = passapikey
        let config = URLSessionConfiguration.default
        let userPasswordString = "username@gmail.com:password"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        
        print(apiKey)
        config.httpAdditionalHeaders = ["Authorization" : apiKey]
        let session = URLSession(configuration: config)
        
        var running = false
        let url = NSURL(string: "http://localhost:8888/PoubelleAPI/API/v1/poubelles/date")
        let task = session.dataTask(with: url as! URL) {
            ( data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                //JSONSerialization in Object
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    DispatchQueue.main.async()
                        {
                            if let poubelles = json["poubelle"] as? [[String: Any]] {
                                
                                for poubelle in poubelles {
                                    if let mois = poubelle["mois"]{
                                        self.mois.append(mois as! Int)
                                    }
                                    if let nombre = poubelle["nombre"]{
                                        self.dates.append(nombre as! Int)
                                        
                                        //self.updateChartData(date: self.dates)
                                    }
                                }
                            }
                            
                            if let messageError = json["message"]
                            {
                                self.alerteMessage(message: messageError as! String)
                            }
                            
                            self.updateChartData(date: self.dates)
                            
                    }
                    /*
                     DispatchQueue.main.async() {
                     self.dismiss(animated: true, completion: nil)
                     }
                     */
                    
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            running = false
        }
        
        
        
        running = true
        task.resume()
        
        while running {
            //sleep(UInt32(0.1))
        }
        
    }
    
    func updateChartData(date : [Int])  {
        
 
        
        //print(self.mois)
        // 1. create chart view
        let chart = BarChartView(frame: self.test.frame)
        
        // 2. generate chart data entries
        //var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let yVals: [Int] = [ 3, 8, 30, 10, 50, 30, 23, 40, 90, 10, 40, 100]
        //let yVals: [Int] = []

        print(yVals)
        var entries = [ BarChartDataEntry]()
        
        for (i, v) in date.enumerated() {
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
        chart.noDataText = "Aucune donnéee"
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
        self.test.addSubview( chart)
        
    }
    
    



    
    @IBAction func AnneeTextFieldAction(_ sender: Any) {
        print(anneeText.text)
    }
 

    @IBAction func deconnecteButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(StatistiqueController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(_ note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            self.button.isHidden = false
            let keyBoardWindow = UIApplication.shared.windows.last
            self.button.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
            keyBoardWindow?.addSubview(self.button)
            keyBoardWindow?.bringSubview(toFront: self.button)
            
            UIView.animate(withDuration: (((note.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
            }, completion: { (complete) -> Void in
                print("Complete")
            })
        }
        
    }
    
    func Done(_ sender : UIButton){
        
        DispatchQueue.main.async { () -> Void in
            print(self.anneeText.text)
            self.anneeText.resignFirstResponder()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    
    func onTapped( sender: Any?) {
        // hacky
        self.viewWillAppear( false)
    }
 */
    
}




