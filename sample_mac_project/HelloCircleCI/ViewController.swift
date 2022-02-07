//
//  ViewController.swift
//  HelloCircleCI
//
//  Created by Adam on 10/09/2020.
//  Copyright © 2020 CircleCI. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var myTestLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTestLabel.setAccessibilityIdentifier("myTestLabel")
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func ButtonClick(_ sender: Any) {
        myTestLabel.stringValue = "Hello CircleCI!"
    }
    
}

