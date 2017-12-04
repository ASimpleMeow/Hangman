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
    
    let words : [String] = [
        "Cat", "Lion", "Castle", "King", "Program", "Test", "Computer"
    ]
    
    public var currentWord : String = ""
    public var currentWordDefintion : String = ""
    
    override func didMove(to view: SKView) {
        
    }
    
    func reset(){
        
        removeAllChildren()
        
        initialDrawSetup()
        drawHead()
        drawBody()
        
        let randomIndex = Int(arc4random_uniform(UInt32(words.count)))
        
        currentWord = words[randomIndex]
        currentWordDefintion = "NO DEFINITION"//getWordDefinition(word: currentWord)
        
        let label = SKLabelNode()
        label.text = currentWord
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 300, y: size.height * 0.75)
        addChild(label)
    }
    
    func getWordDefinition(word : String) -> String{
        
        var wordDefintion : String = "";
        let semaphore = DispatchSemaphore(value: 0)
        
        let appId = "97733cb7"
        let appKey = "8f909c76eda5b2c351a8cbb6b8190896"
        let language = "en"
        let word_id = word.lowercased() //word id is case sensitive and lowercase is required
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        
        let session = URLSession.shared
        _ = session.dataTask(with: request, completionHandler: { data, response, error in
            if error == nil {
                
                do {
                    
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    if let results = jsonData["results"] as? NSArray?,
                    let keys = results![0] as? NSDictionary,
                    let lexicalEntires = keys["lexicalEntries"] as? NSArray,
                    let entries = lexicalEntires[0] as? NSDictionary,
                    let entry = entries["entries"] as? NSArray,
                    let senses = entry[0] as? NSDictionary,
                    let definitions = senses["senses"] as? NSArray,
                    let definition = definitions[0] as? NSDictionary,
                    let final = definition["definitions"] as? NSArray{
                        wordDefintion = final[0] as! String
                    } else {
                        wordDefintion = "<DEFINITION NOT FOUND>"
                    }
                    semaphore.signal()
                }
                catch let err as NSError {
                    print (err)
                }
            } else {
                print("Could not connect to dictionary API")
            }
        }).resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return wordDefintion
        
    }
    
    func initialDrawSetup() {
        let verticalPlank = SKShapeNode(rect: CGRect(x: size.width*0.2, y: size.height * 0.5, width: size.width*0.03, height: size.height * 0.4))
        let horizontalPlank = SKShapeNode(rect: CGRect(x: size.width*0.2, y: size.height * 0.5+size.height * 0.4, width: size.width*0.5, height: size.height * 0.01))
        let rope = SKShapeNode(rect: CGRect(x: size.width*0.55, y: size.height * 0.5+size.height * 0.4, width: size.width*0.005, height: size.height * -0.05))
        
        verticalPlank.fillColor = SKColor.blue
        horizontalPlank.fillColor = SKColor.blue
        rope.fillColor = SKColor.brown
        
        addChild(verticalPlank)
        addChild(rope)
        addChild(horizontalPlank)
    }
    
    func drawHead(){
        let head = SKShapeNode(circleOfRadius: size.width * 0.075)
        head.position = CGPoint(x: size.width*0.55, y: (size.height * 0.5 + size.height * 0.4) - (size.height * -0.05) - (size.width * 0.2))
        
        head.fillColor = SKColor.orange

        addChild(head)
    }
    
    func drawBody(){
        let headPos = children.last?.position
        let body = SKShapeNode(rect: CGRect(x: (headPos?.x)! - size.width * 0.06, y: (headPos?.y)! - size.width * 0.075, width: size.width * 0.12, height: size.height * -0.15))
        body.fillColor = SKColor.cyan
        addChild(body)
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

