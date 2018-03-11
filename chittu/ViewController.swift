//
//  ViewController.swift
//  chittu
//
//  Created by Vara Prasada Gopi Srinath Samudrala on 3/10/18.
//  Copyright © 2018 Vara Prasada Gopi Srinath Samudrala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var number:Int = 0
    @IBAction func perform(_ sender: Any) {
        self.number += 1
        self.label.text=String(number)
        print (self.number)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

