//
//  GameScene.swift
//  MarbleMaze
//
//  Created by My Nguyen on 8/17/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case Player = 1
    case Wall = 2
    case Star = 4
    case Vortex = 8
    case Finish = 16
}

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        // load a background picture
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)

        // load data from file
        loadLevel()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func loadLevel() {
        // fetch the full path for file "level1.txt"
        if let levelPath = NSBundle.mainBundle().pathForResource("level1", ofType: "txt") {
            // read the whole contents of the file
            if let levelString = try? String(contentsOfFile: levelPath, usedEncoding: nil) {
                // split the contents into lines
                let lines = levelString.componentsSeparatedByString("\n")

                // iterate over the lines array
                for (row, line) in lines.reverse().enumerate() {
                    // iterate over the characters in each line
                    for (column, letter) in line.characters.enumerate() {
                        // each square in the game is 64x64. since SpriteKit calculates its positions
                        // from the center of objects, need to add 32 to the X and Y coordinates
                        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)

                        // each character is an object
                        if letter == "x" {
                            // load wall
                            let node = SKSpriteNode(imageNamed: "block")
                            node.position = position
                            // a wall is a rectangle physic
                            node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
                            // categoryBitMask is the category of this node
                            node.physicsBody!.categoryBitMask = CollisionTypes.Wall.rawValue
                            // a wall is fixed, and not dynamic
                            node.physicsBody!.dynamic = false
                            addChild(node)
                        } else if letter == "v"  {
                            // load vortex
                            let node = SKSpriteNode(imageNamed: "vortex")
                            node.name = "vortex"
                            node.position = position
                            // rotate vortex node around and around forever
                            node.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)))
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            node.physicsBody!.categoryBitMask = CollisionTypes.Vortex.rawValue
                            // contactTestBitMask is which colliions to be notified about
                            // so, get notified when a player collides with this node (vortex)
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            // collisionBitMask is what categories of object this node should collide with
                            // 0 means collision (bouncing off)
                            node.physicsBody!.collisionBitMask = 0
                            addChild(node)
                        } else if letter == "s"  {
                            // load star
                            let node = SKSpriteNode(imageNamed: "star")
                            node.name = "star"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            node.physicsBody!.categoryBitMask = CollisionTypes.Star.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            node.position = position
                            addChild(node)
                        } else if letter == "f"  {
                            // load finish
                            let node = SKSpriteNode(imageNamed: "finish")
                            node.name = "finish"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            node.physicsBody!.categoryBitMask = CollisionTypes.Finish.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            node.position = position
                            addChild(node)
                        }
                    }
                }
            }
        }
    }
}
