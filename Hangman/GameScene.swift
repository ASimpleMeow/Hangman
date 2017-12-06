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
        "Cat", "Lion", "Castle", "King", "Program", "Test", "Computer", "Terminal", "Sleep", "Silicone",
        "Accident", "Sickness", "Wellhole", "Reforged", "Reliable", "Olympiad", "Amnestic", "Snobbish",
        "Pentagon", "Poet", "Sand", "Mirror", "Dill", "Sneak", "Jade", "Trash", "Home", "Bund", "Shame",
        "Shark", "Apple", "Gift", "Petal", "Jean", "Cob", "Water", "Ice", "Fire", "Earth", "Wind", "Nation",
        "Wasp", "Thorn", "Bee", "Shell", "Frog", "Snake", "Monitor", "Mouse", "Rope", "Wood", "Stone",
        "Squire", "Venom", "Onion", "Rod", "Rib", "Haven", "Musket", "Patron", "Painting", "Morale", "Work",
        "Bug", "Favor", "Glover", "Garlic", "Iron", "Silver", "Gold", "Heaven", "Hell", "God", "Devil",
        "Fairy", "Wolf", "Bear", "Fox", "Sheep"
    ]
    
    public var currentWord : String = ""
    public var currentWordDefintion : String = ""
    
    let hangman : [SKSpriteNode] =
        [SKSpriteNode(imageNamed: "head"), SKSpriteNode(imageNamed: "body"),
         SKSpriteNode(imageNamed: "left_arm"), SKSpriteNode(imageNamed: "right_arm"),
        SKSpriteNode(imageNamed: "left_leg"), SKSpriteNode(imageNamed: "right_leg")]
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 40/255, alpha: 1)
        
        for part in hangman {
            part.color = SKColor(red: 68/255, green: 189/255, blue: 98/255, alpha: 1)
            part.colorBlendFactor = 1.0
            part.size = CGSize(width: size.width*0.5, height: size.height*0.5)
            part.position = CGPoint(x: size.width*0.555, y: size.height*0.66)
        }
        
        let backgroundMusic =  SKAudioNode(fileNamed: "background_music.wav")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func reset(){
        
        for child in children {
            if !(child is SKAudioNode) {
                removeChildren(in: [child])
            }
        }
        
        initialSetup()
        
        let randomIndex = Int(arc4random_uniform(UInt32(words.count)))
        
        currentWord = words[randomIndex]
        currentWordDefintion = getWordDefinition(word: currentWord)
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
    
    func initialSetup() {
        //Planks
        let verticalPlank = SKShapeNode(rect: CGRect(x: size.width*0.2, y: size.height * 0.5, width: size.width*0.03, height: size.height * 0.4))
        let horizontalPlank = SKShapeNode(rect: CGRect(x: size.width*0.2, y: size.height * 0.5+size.height * 0.4, width: size.width*0.5, height: size.height * 0.01))
        let rope = SKShapeNode(rect: CGRect(x: size.width*0.55, y: size.height * 0.5+size.height * 0.4, width: size.width*0.005, height: size.height * -0.05))
        
        verticalPlank.fillColor = SKColor(red: 68/255, green: 189/255, blue: 98/255, alpha: 0.75)
        horizontalPlank.fillColor = SKColor(red: 68/255, green: 189/255, blue: 98/255, alpha: 0.75)
        rope.fillColor = SKColor(red: 68/255, green: 189/255, blue: 98/255, alpha: 0.75)
        
        verticalPlank.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        horizontalPlank.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        rope.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        addChild(verticalPlank)
        addChild(rope)
        addChild(horizontalPlank)
        
    }
    
    func draw(mistakes : Int){
        if mistakes == 5 {
            addChild(hangman[6-(mistakes+1)])
        } else {
            removeChildren(in: [children.last!])
            addChild(hangman[6-(mistakes+1)])
        }
    }
    
    func playButtonSound(positive : Bool){
        if positive {
            run(SKAction.playSoundFileNamed("success.wav", waitForCompletion: false))
        } else {
            run(SKAction.playSoundFileNamed("fail.wav", waitForCompletion: false))
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

