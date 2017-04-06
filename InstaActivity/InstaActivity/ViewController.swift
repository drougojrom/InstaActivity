//
//  ViewController.swift
//  InstaActivity
//
//  Created by Roman Ustiantcev on 06/04/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var insActivity: InstaActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupInitialState()
        setupInstActivity()

    }
    
    func setupInitialState() {
        
        // setup for @IBOutlet
        
        insActivity.animationDuration = 1
        insActivity.lineWidth = 3
        insActivity.segmentsNumber = 12
        insActivity.rotationDuration = 10
        insActivity.strokeColor = UIColor.blue
        insActivity.startAnimation()
    }
    
    func setupInstActivity() {
        
        // setup activity indicator from code
        
        let ind = InstaActivity(frame: CGRect(x: 30, y: 200, width: 50, height: 50))
        ind.animationDuration = 1
        ind.lineWidth = 3
        ind.segmentsNumber = 12
        ind.isAnimating = true
        ind.rotationDuration = 10
        ind.strokeColor = UIColor.brown
        ind.startAnimation()
        
        self.view.addSubview(ind)
    }
}

extension ViewController {
    // MARK: actions
    
    @IBAction func actionStartAnimating(sender: Any) {
        if insActivity.isAnimating {
            insActivity.stopAnimation()
        } else {
            insActivity.startAnimation()
        }
    }
}
