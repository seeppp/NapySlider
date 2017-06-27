//
//  ViewController.swift
//  NapySlider
//
//  Created by Jonas Schoch on 12.12.15.
//  Copyright © 2015 naptics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var napySlider: NapySlider!
    var napySlider2: NapySlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        napySlider.title = "Awesomeness"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        napySlider.min = 0
        napySlider.max = 10
        napySlider.step = 2
        
        napySlider.handlePosition = napySlider.min
        
        napySlider2 = NapySlider(frame: CGRect(x: napySlider.frame.origin.x + napySlider.frame.width + 10, y: napySlider.frame.origin.y, width: napySlider.frame.width, height: napySlider.frame.height))
        view.addSubview(napySlider2)
        
        napySlider2.min = 0
        napySlider2.max = 100
        napySlider2.step = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valueChanged(_ sender: NapySlider) {
        print("value has changed to \(napySlider.handlePosition)")
    }
}

