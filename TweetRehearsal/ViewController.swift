//
//  ViewController.swift
//  TweetRehearsal
//
//  Created by Harlan.Howe on 4/26/15.
//  Copyright (c) 2015 Harlan.Howe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tag0Label: UILabel!
    @IBOutlet weak var tag1Label: UILabel!
    @IBOutlet weak var tag2Label: UILabel!
    @IBOutlet weak var tag3Label: UILabel!
    @IBOutlet weak var tag0Switch: UISwitch!
    @IBOutlet weak var tag1Switch: UISwitch!
    @IBOutlet weak var tag2Switch: UISwitch!
    @IBOutlet weak var tag3Switch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleTagSwitchChanged(sender: UISwitch) {
        /*var labelToUpdate: UILabel?
        if sender == tag0Switch
        {
            labelToUpdate = tag0Label
        }
        if sender == tag1Switch
        {
            labelToUpdate = tag1Label
        }
        if sender == tag2Switch
        {
            labelToUpdate = tag2Label
        }
        if sender == tag3Switch
        {
            labelToUpdate = tag3Label
        }
        */
        // Here's a slicker way of doing the same thing...
        // ... in one line!
        let labelToUpdate = view.viewWithTag(sender.tag + 10)
        
        if let label = labelToUpdate as? UILabel
        {
            if sender.on
            {
              label.textColor = UIColor.blackColor()
            }
            else
            {
              label.textColor = UIColor.grayColor()
            }
        }
    
    }

    
    @IBAction func handleTweetIt(sender: UIButton) {
        var tagString = ""
        
        for tagNum in 10...13
        {
            let switchToCheck = view.viewWithTag(tagNum) as? UISwitch
            
            if let theSwitch:UISwitch = switchToCheck
            {
                if theSwitch.on
                {
                    if let label:UILabel = view.viewWithTag(tagNum+10) as? UILabel
                    {
                        tagString = tagString + label.text! + " "
                    }
                }
            }
        }
        println (tagString)
    }
    
}

