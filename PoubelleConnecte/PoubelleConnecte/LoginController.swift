//
//  LoginController.swift
//  PoubelleConnecte
//
//  Created by Tayeb Sedraia on 28/04/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginController: UIViewController {
    
    
    @IBOutlet weak var txtEMail: UITextField!
    @IBOutlet weak var txtMdp: UITextField!
    
    public var mutableURLRequest: NSMutableURLRequest!
    public var url: NSURL?
    public var addressUrlString = "http://localhost:8888/PoubelleAPI/API/v1"
    
    var test = ""
    public var loginUrlString = "/login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
                // This shows how you can specify the settings/parameters instead of using the default/shared parameters
/*
        let urlToRequest = addressUrlString+loginUrlString
        func dataRequest() {
            let url4 = URL(string: urlToRequest)!
            let session4 = URLSession.shared
            let request = NSMutableURLRequest(url: url4)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            //let paramString = String(format:"email=wesg&password=wesg")
            let paramString = String(format:"email=%@&password=%@",txtEMail.text!,txtMdp.text!)
            //let dict = ["email": "Hello", "password": "Hello"]
            request.httpBody = paramString.data(using: String.Encoding.utf8)
            
         
            
            let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
                guard let _: Data = data, let _: URLResponse = response, error == nil else {
                    print("*****error")
                    return
                }
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Response : \n \(dataString)") //JSONSerialization
                
            }

            task.resume()
        }
        dataRequest()
 
        */

        let urlToRequest = addressUrlString+loginUrlString
            let url4 = URL(string: urlToRequest)!
            let session4 = URLSession.shared
            let request = NSMutableURLRequest(url: url4)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            //let paramString = String(format:"email=wesg&password=wesg")
            let paramString = String(format:"email=%@&password=%@",txtEMail.text!,txtMdp.text!)
            //let dict = ["email": "Hello", "password": "Hello"]
            request.httpBody = paramString.data(using: String.Encoding.utf8)
            
            
            
            let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
                guard let _: Data = data, let _: URLResponse = response, error == nil else {
                    print("*****error")
                    return
                }
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Response : \n \(dataString)") //JSONSerialization
                
                //let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String : AnyObject]
                //let experts = json["expertPainPanels"] as? [String: AnyObject]
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    if let apiKey = json["apiKey"]
                    {
                        print(apiKey)
                    }
                    if let names = json["name"]
                    {
                        self.test = names as! String
                        print("Nom : ",self.test)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            };task.resume()

        
        //self.txtEMail.text = self.test
        print("Nom en bas : ",self.test)
        ////////***
        /*
        let data = [
            "password" : "azerty",
            "email" : "taysed93270@hot.fr",
        ]
 
        print(data)
        let a = "email=toto"
        
        let urlString = "http://localhost:8888/PoubelleAPI/API/v1/login"
        
        Alamofire.request(urlString, method: .post, parameters: data,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
 
        */

        /*
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["email": "lol", "password": "lol"] as Dictionary<String, String>
        
        //create the url with URL
        let url = URL(string: "http://localhost:8888/PoubelleAPI/API/v1/login")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
 */
        

    }

    
        
        
}

 
    

