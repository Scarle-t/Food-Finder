//
//  TodayViewController.swift
//  widget
//
//  Created by Scarlet on 25/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let foodList = ["KFC", "McDonald", "薩莉亞", "Pizza", "扑野家", "PIAGO Food Court", "秀吉", "Mos", "Suckway", "柒唔夠"]
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var chooseBtn: UIButton!
    @IBAction func choose(_ sender: UIButton) {
        let index = Int.random(in: 0..<foodList.count)
        
        result.text = "今日食" + foodList.shuffled()[index]
        chooseBtn.setTitle("再諗過", for: .normal)
        
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
