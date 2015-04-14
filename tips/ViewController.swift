//
//  ViewController.swift
//  tips
//
//  Created by Gabriel Such on 4/4/15.
//  Copyright (c) 2015 Gabriel Such. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var tip: UISegmentedControl!
   
    @IBOutlet weak var split: UISegmentedControl!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    func defaultTip() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey("default_tip")
    }
    
    func applicationBecameActive(notification: NSNotification) {
        tip.selectedSegmentIndex = defaultTip()
        updateValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .Plain,
            target: self,
            action: "buttonClicked:"
        )
        
        navigationItem.title = "Tips Calculator"
        totalLabel.text = "$0.00"
        tipLabel.text = "$0.00"
        billAmount.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationBecameActive:",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
    }
    
    func buttonClicked(sender:UIButton) {
        let url = (NSURL(string:UIApplicationOpenSettingsURLString)!)
        UIApplication.sharedApplication().openURL(url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onEditingChange(sender: AnyObject) {
        updateValues()
    }
    
    func updateValues() {
        totalLabel.text = NSString(format:"$%.2f", total())
        tipLabel.text = NSString(format:"$%.2f", tipPerPerson())
    }
    
    func amountValue() -> Double  {
        return NSString(string: billAmount.text).doubleValue
    }
    
    func tipValue() -> Double {
        let tipPercentages = [0.18, 0.2, 0.22]
        let selected = tipPercentages[tip.selectedSegmentIndex]
        return amountValue() * selected
    }
    
    func tipPerPerson() -> Double {
        return tipValue() / Double(splitValue())
    }
    
    func splitValue() -> Int {
        return split.selectedSegmentIndex + 1
    }
    
    func total() -> Double {
        return (amountValue() + tipValue()) / Double(splitValue())
    }
    
}

