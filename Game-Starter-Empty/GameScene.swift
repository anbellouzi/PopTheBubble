//
//  GameScene.swift
//  Game-Starter-Empty
//
//  Created by Jonathan Kopp on 9/29/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //Initialize score starting at 0
    var score = 0
    
    //Set up properties of the scoreLabel
    var scoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "0"
        label.color = .white
        label.fontSize = 50
        
        return label
    }()
    
    //Set up properties of the missedLabel
    var missedLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "0"
        label.color = .white
        label.fontSize = 50
        
        return label
    }()
    
    struct game {
        static var IsOver : Bool = false
    }
    
    override func didMove(to view: SKView) {
        //Called when the scene has been displayed
        
        //TODO: Create three squares with the names one,two,three
        createSquares(name: "one")
        createSquares(name: "one")
        createSquares(name: "one")
        
        //Setup the scoreLabel
        labelSetUp()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    func labelSetUp() {
        scoreLabel.position.x = view!.bounds.width / 2
        scoreLabel.position.y = view!.bounds.height - 80
        addChild(scoreLabel)
    }
    
    
    func randomNumber()-> CGFloat {
        //Width of the SKScene's view
        let viewsWidth = self.view!.bounds.width
        //Creates a random number from 0 to the viewsWidth
        let randomNumber = CGFloat.random(in: 0 ... viewsWidth)
        
        return randomNumber
    }
    
    func createSquares(name: String) {
        //TODO: Set up square properties
        //1. Create a CGSize for the square with (width: 80, height: 80)
        let size = CGSize(width: 80, height: 80)
        
        //2. Create a Square node with a texture of nil. a color of .green and the size we created above
        let square = SKSpriteNode(texture: nil, color: .green, size: size)
        
        //3. Set the squares name to the name we pass into this function
        square.name = name
        
        //TODO: Set up the Squares x and y positions
        //1. Squares y positions shoud start at 40
        square.position = CGPoint(x: self.randomNumber(), y: 40)
        //2. Squares x positon should use the randomNumber generator provided above
        addChild(square)
        
        //Create an action to move the square up the screen
        let action = SKAction.customAction(withDuration: 2.0, actionBlock: { (square, _) in
            //TODO: Set up the squares animation
            //1. The squares y position should increase by 10
            square.position = CGPoint(x: square.position.x, y: square.position.y+10)
            //2. Create an if statement that checks if the squares y position is >= to the screens height
            if square.position.y >= UIScreen.main.bounds.height {
                //If it is remove the square and create a new square with the same name
                square.removeFromParent()
                self.createSquares(name: name)
            }
        })
        
        //TODO: Have the square run the above animation forever and add the square to the SKScene!
        let animations = SKAction.repeatForever(action)
        
        square.run(animations)
    }
    
//    source code: https://stackoverflow.com/questions/37126494/swift-spritekit-segue-between-gameviewcontroller-and-mainviewcontroller-after
    
    
    func goToGameScene(){
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size) // create your new scene
        let transition = SKTransition.fade(withDuration: 3.0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
        score = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Loop through an array of touch values
        for touch in touches {
            
            //Grab the position of that touch value
            let positionInScene = touch.location(in: self)
            
            //Find the name for the node in that location
            let nodeFound = self.atPoint(positionInScene)
            let name = nodeFound.name
            
            
        
            
            //Check if there is an node there.
            if name == "one" {
                //TODO: Remove the square
                //Remove node from parent view
                missedLabel.removeFromParent()
                missedLabel.position = positionInScene
                if ((missedLabel.parent) == nil) {
                    addChild(missedLabel)
                }
                
                missedLabel.text = "+1"
                
                nodeFound.removeFromParent()
                
                
                //Increase the score by one
                score += 1
                scoreLabel.text = String(score)
                
                //Create the square again with the same name
                createSquares(name: name!)
            }
            else {
                score -= 1
                scoreLabel.text = String(score)
                missedLabel.position = positionInScene
                if ((missedLabel.parent) == nil) {
                    addChild(missedLabel)
                }
            
                missedLabel.text = "Missed"
                
                
                
                if score < 0 {
                    scoreLabel.text = String("Game is Over")
                    missedLabel.removeFromParent()
                    
                    
                    goToGameScene()
                }
            }
        }
    }
    
}
