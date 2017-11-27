//
//  GameScene.swift
//  Hangman
//
//  Created by Oleksandr  on 27/11/2017.
//  Copyright © 2017 Oleksandr . All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let limit = 8
        let fontSize = CGFloat(Int(Float(limit) * Float(10) * Float(0.3)))
        var currentX = CGFloat(fontSize/2) - CGFloat(fontSize/8)
        
        for i in 0...limit {
            let label = SKLabelNode()
            label.text = "_"
            label.fontSize = fontSize
            label.fontColor = SKColor.white
            label.position = CGPoint(x: currentX, y: size.height * 0.50)
            addChild(label)
            currentX += CGFloat(size.width / CGFloat(limit-1))
            print(i)
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

