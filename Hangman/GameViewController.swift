//
//  GameViewController.swift
//  Hangman
//
//  Created by Oleksandr  on 27/11/2017.
//  Copyright © 2017 Oleksandr . All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var tipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        tipLabel.isHidden = true
        tipLabel.text = scene.currentWordDefintion
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func onTipButton() {
        tipLabel.isHidden = !tipLabel.isHidden
    }
    
}
