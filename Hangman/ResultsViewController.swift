//
//  ResultsViewController.swift
//  Hangman
//
//  Created by Oleksandr  on 03/12/2017.
//  Copyright © 2017 Oleksandr . All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var resultsWord: UILabel!
    @IBOutlet weak var resultsDefinition: UILabel!
    
    var colourRed : Bool = false
    var result : String = ""
    var word : String = ""
    var definition : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        resultsLabel.text = result
        resultsLabel.textColor = colourRed ? UIColor.red : UIColor.green
        resultsWord.text = word
        resultsDefinition.text = definition
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
