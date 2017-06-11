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
    
    var passapikey = String()
    
    
    let nf = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2
        self.circleProgressView.progress = Double(0.10)
        //self.progressSlider.value = Float(0.10)
        let nb = 0.10 * 100
        self.progressLabel.text = nf.string(from: NSNumber(value: nb))!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
    
    // MARK: - Helpers
    func delay(_ delay:Double, closure: @escaping ()-> Void) {
        let delayTime = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: closure)
    }
    
}
