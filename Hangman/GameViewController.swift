//
//  GameViewController.swift
//  Hangman
//
//  Created by Oleksandr  on 27/11/2017.
//  Copyright © 2017 Oleksandr . All rights reserved.
//

import UIKit
import SpriteKit

/*
 Extensions to extend Character and String functionality (which should already be part of Swift!) taken from Stackoverflow
 */
extension Character {
    var string: String { return String(self) }
}
extension String.CharacterView {
    var string: String { return String(self) }
}
extension Sequence where Iterator.Element == UnicodeScalar {
    var string: String { return String(String.UnicodeScalarView(self)) }
}
extension String {
    func index(at offset: Int) -> Index? {
        precondition(offset >= 0, "offset can't be negative")
        return index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex))
    }
    func character(at offset: Int) -> Character? {
        precondition(offset >= 0, "offset can't be negative")
        guard let index = index(at: offset) else { return nil }
        return self[index]
    }
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    subscript(offset: Int) -> String {
        precondition(offset >= 0, "offset can't be negative")
        guard let character = character(at: offset) else { return "" }
        return String(character)
    }
    subscript(range: Range<Int>) -> Substring {
        precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
        guard let startIndex = index(at: range.lowerBound) else { return "" }
        return self[startIndex..<(index(startIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)]
    }
    subscript(range: ClosedRange<Int>) -> Substring {
        precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
        guard let startIndex = index(at: range.lowerBound) else { return "" }
        return self[startIndex..<(index(startIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)]
    }
    subscript(partialRange: PartialRangeFrom<Int>) -> Substring {
        return self[partialRange.lowerBound..<endIndex.encodedOffset]
    }
    subscript(partialRange: PartialRangeUpTo<Int>) -> Substring {
        return self[startIndex.encodedOffset..<partialRange.upperBound]
    }
    subscript(partialRange: PartialRangeThrough<Int>) -> Substring {
        return self[startIndex.encodedOffset...partialRange.upperBound]
    }
}

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var hiddenWord: UILabel!
    
    @IBOutlet weak var topLetterStack: UIStackView!
    @IBOutlet weak var middleLetterStack: UIStackView!
    @IBOutlet weak var bottomLetterStack: UIStackView!
    
    var mistakes : Int = 6
    
    var scene : GameScene? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene?.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        reset()
    }
    
    func reset(){
        scene?.reset()
        tipLabel.isHidden = true
        tipLabel.text = scene?.currentWordDefintion
        hiddenWord.text = ""
        mistakes = 6
        
        for _ in (scene?.currentWord)! {
            hiddenWord.text?.append("_ ")
        }
        
        for view in topLetterStack.subviews as [UIView]{
            if let btn = view as? UIButton {
                btn.tintColor = UIColor(red: 0/255, green: 255/255, blue: 25/255, alpha: 1)
                btn.backgroundColor = UIColor(red: 75/255, green: 226/255, blue: 140/255, alpha: 0.25)
            }
        }
        
        for view in middleLetterStack.subviews as [UIView]{
            if let btn = view as? UIButton {
                btn.tintColor = UIColor(red: 0/255, green: 255/255, blue: 25/255, alpha: 1)
                btn.backgroundColor = UIColor(red: 75/255, green: 226/255, blue: 140/255, alpha: 0.25)
            }
        }
        
        for view in bottomLetterStack.subviews as [UIView]{
            if let btn = view as? UIButton {
                btn.tintColor = UIColor(red: 0/255, green: 255/255, blue: 25/255, alpha: 1)
                btn.backgroundColor = UIColor(red: 75/255, green: 226/255, blue: 140/255, alpha: 0.25)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func onTipButton() {
        tipLabel.isHidden = !tipLabel.isHidden
    }
    
    @IBAction func onLetterButton(_ sender: UIButton) {
        
        if sender.tintColor == UIColor(red: 255/255, green: 38/255, blue: 1/255, alpha: 1) {
            return
        }
        
        let letter = Character((sender.titleLabel?.text?.lowercased())!)
        var charIndexs : [Int] = []
        var found : Bool = false
        
        for index in 0...(scene?.currentWord)!.count-1{
            let c = (scene?.currentWord.lowercased())!.character(at: index)!
            if c==letter {
                charIndexs.append(index)
                found = true
            }
        }
        
        for i in charIndexs{
            hiddenWord.text = replace(myString: hiddenWord.text!, (i*2), (scene?.currentWord.uppercased())!.character(at: i)!)
        }
        
        sender.tintColor = UIColor(red: 255/255, green: 38/255, blue: 1/255, alpha: 1)
        sender.backgroundColor = UIColor(red: 82/255, green: 9/255, blue: 7/255, alpha: 0.25)
        
        if !found {
            sender.titleLabel?.textColor = UIColor.red
            mistakes -= 1
            scene?.draw(mistakes: mistakes)
            if mistakes <= 0 {
                performSegue(withIdentifier: "ResultsSegue", sender: nil)
            }
        }
        
        scene?.playButtonSound(positive: found)
        
        if hiddenWord.text!.lowercased().removingWhitespaces() == (scene?.currentWord.lowercased())! {
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            let resultsViewController = segue.destination as! ResultsViewController
            if mistakes > 0 {
                resultsViewController.colourRed = false
                resultsViewController.result = "YOU WON!"
            } else {
                resultsViewController.colourRed = true
                resultsViewController.result = "YOU LOST!"
            }
            resultsViewController.word = (scene?.currentWord.uppercased())!
            resultsViewController.definition = (scene?.currentWordDefintion.capitalized)!
        }
    }
    
    @IBAction func unwindHandman(segue : UIStoryboardSegue){
        reset()
        
    }
    
    // This method is taken from Stackoverflow because Swift doesn't want me to have an easy life
    // replacing some characters in a string
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var modifiedString = String()
        for (i, char) in myString.characters.enumerated() {
            modifiedString += String((i == index) ? newChar : char)
        }
        return modifiedString
    }
    
}
