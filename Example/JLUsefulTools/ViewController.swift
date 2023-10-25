//
//  ViewController.swift
//  JLUsefulTools
//
//  Created by 16658670 on 03/13/2023.
//  Copyright (c) 2023 16658670. All rights reserved.
//

import UIKit
import JLUsefulTools

class ViewController: BasicViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dataArr:[UInt8] = [0x01,0x02,0x03,0x04]
        let data = Data(bytes: dataArr, count: 4)
        navigationView.title = "Test"
        ECPrintInfo("dataL\(data.eHex)", self, "\(#function)", #line)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

