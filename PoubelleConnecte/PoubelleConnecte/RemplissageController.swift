//
//  RemplissageController.swift
//  PoubelleConnecte
//
//  Created by Tayeb Sedraia on 11/06/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import CircleProgressView

class RemplissageController: UIViewController {
    
    @IBOutlet weak var circleProgressView: CircleProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    public var addressUrlString = "http://localhost:8888/PoubelleAPI/API/v1"
    
    public var loginUrlString = "/poubelles/date"
    
    var passapikey = String()
    var nb = Double()
    
    var dates = [Int]()
    
    let nf = NumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callAPIPoubelleSize()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Circular
    func circularSize(sizes : [Int]) {
        for (i, element) in sizes.enumerated() {
            //print("Item \(i): \(element)")
            if (element > 0) {
                self.nb = Double(element)
            }
        }
        
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2

        let ajust = nb / 100
        self.circleProgressView.progress = ajust
        self.progressLabel.text = nf.string(from: NSNumber(value: self.nb))! + " %"
    }
    
    
    // MARK: - Helpers
    func delay(_ delay:Double, closure: @escaping ()-> Void) {
        let delayTime = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: closure)
    }
    
    func callAPIPoubelleSize() {
        
        
        
        let apiKey = passapikey
        let config = URLSessionConfiguration.default
        let userPasswordString = "username@gmail.com:password"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        
        config.httpAdditionalHeaders = ["Authorization" : apiKey]
        let session = URLSession(configuration: config)
        
        var running = false
        let url = NSURL(string: "http://localhost:8888/PoubelleAPI/API/v1/poubelles")
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
                                    if let size = poubelle["size"]{
                                        
                                        self.dates.append(size as! Int)
                                        
                                        self.circularSize(sizes: self.dates)
                                    }
                                }
                            }
                            
                            if let messageError = json["message"]
                            {
                                self.alerteMessage(message: messageError as! String)
                            }
                            
                            
                            
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
