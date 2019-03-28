//
//  ViewController.swift
//  CalculatorSelf3
//
//  Created by Mac User on 7/7/17.
//  Copyright © 2017 Mac User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var userInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()

    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation(with: "✅") { [weak self = self] in
            self?.display.textColor = UIColor.green
            return sqrt($0)
        }
    }

    @IBOutlet weak var display: UILabel!
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func pushDigit(_ sender: UIButton) {
    
        if userInTheMiddleOfTyping {
            if let curTextOnDisplay = display.text {
                display?.text = curTextOnDisplay + sender.currentTitle!
            }
        } else {
            userInTheMiddleOfTyping = true
            display?.text = sender.currentTitle!
        }
        
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userInTheMiddleOfTyping {
            brain.pushDigit(displayValue)
            userInTheMiddleOfTyping = false
        }
        brain.performOperation(oper: sender.currentTitle!)
        
        if let result = brain.result {
            displayValue = result
        }
    }
}

