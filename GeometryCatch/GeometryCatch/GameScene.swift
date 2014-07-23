//
//  GameScene.swift
//  GeometryCatch
//
//  Created by iosdev on 22/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

import SpriteKit

let worldCategory:UInt32 = 1 << 1
let paddleCategory:UInt32 = 1 << 2
let dropCategory:UInt32 = 1 << 3

class GameScene: SKScene, SKPhysicsContactDelegate{
    var paddle:SKSpriteNode!
    var speedOffset:Double!
    var paddleArray:NSMutableArray!
    var paddleHoldShapeOffset:Float = 0.6
    var paddleArrayIndex:Int = 0
    var bgColor:UIColor!
    var levelBar:SKSpriteNode!
    var level:Int = 1
    var score:Int = 0
    var scoreLabel:SKLabelNode!
    var isGameOver:Bool!
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        isGameOver = false
        speedOffset = 0.1
        self.size.width = 768
        self.size.height = 1024
        paddleArray = NSMutableArray(capacity: 3)
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self
        bgColor = UIColor(red: 251/255, green: 174/255, blue: 23/255, alpha: 1.0)
        self.backgroundColor = bgColor
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody.categoryBitMask = worldCategory
        self.physicsBody.collisionBitMask = paddleCategory
        
        paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.setScale(0.5)
        paddle.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.2)
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.size)
        paddle.physicsBody.allowsRotation = false
        paddle.physicsBody.dynamic = true
        paddle.physicsBody.categoryBitMask = paddleCategory
        paddle.physicsBody.collisionBitMask = worldCategory
        paddle.physicsBody.contactTestBitMask = dropCategory
        self.addChild(paddle)
        
        //        NSLog("%fx%f", self.size.width, self.size.height)
        
        levelBar = SKSpriteNode(imageNamed: "levelBar")
        levelBar.anchorPoint = CGPointMake(0, 0.5)
        levelBar.position = CGPointMake(0, 0)
        levelBar.size.width = self.size.width/2
        levelBar.yScale = 2.0
        self.addChild(levelBar)
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = String(score)
        scoreLabel.position = CGPointMake(self.size.width * 0.9, self.size.height * 0.9)
        scoreLabel.color = SKColor.blackColor()
        scoreLabel.colorBlendFactor = 1
        self.addChild(scoreLabel)
        
        self.dropShape()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if !isGameOver{
            let touch:UITouch = touches.anyObject() as UITouch
            let location = touch.locationInNode(self)
            paddle.runAction(SKAction.moveToX(location.x, duration: speedOffset))
        }
        
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        if !isGameOver{
            let touch:UITouch = touches.anyObject() as UITouch
            let location = touch.locationInNode(self)
            paddle.position.x = location.x
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        levelBar.size.width -= 0.5
        scoreLabel.text = String(score)
        if levelBar.size.width  == self.size.width{
            levelBar.size.width = self.size.width * 0.2
            level++;
            speedOffset = speedOffset / 1.5
        }
        if(levelBar.size.width <= 0){
            self.gameOver()
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact){
        var takenShape:SKSpriteNode
        let shape = contact.bodyB.node as Drops
        shape.removeFromParent()
        paddleArray.addObject(shape.type)
        if paddleArrayIndex >= 1 && paddleArray[paddleArrayIndex-1].integerValue != shape.type && paddleArray[paddleArrayIndex-1] != nil{
            paddleArray.removeAllObjects()
            paddleArrayIndex = 0
            paddle.removeAllChildren()
            paddleHoldShapeOffset = 0.6
            levelBar.size.width -= 100
        }
        else if paddleArrayIndex != 2{
            switch(shape.type){
            case 0:
                takenShape = SKSpriteNode(imageNamed: "shape_circle")
                paddle.addChild(takenShape)
                
                takenShape.position = CGPointMake(paddle.size.width * (0.2 - paddleHoldShapeOffset), 0)
                takenShape.color = bgColor
                takenShape.colorBlendFactor = 1
                break
            case 1:
                takenShape = SKSpriteNode(imageNamed: "shape_square")
                paddle.addChild(takenShape)
                
                takenShape.position = CGPointMake(paddle.size.width * (0.2 - paddleHoldShapeOffset), 0)
                takenShape.color = bgColor
                takenShape.colorBlendFactor = 1
                break
            case 2:
                takenShape = SKSpriteNode(imageNamed: "shape_triangle")
                paddle.addChild(takenShape)
                
                takenShape.position = CGPointMake(paddle.size.width * (0.2 - paddleHoldShapeOffset), 0)
                takenShape.color = bgColor
                takenShape.colorBlendFactor = 1
                break
            default:
                break
            }
            paddleArrayIndex += 1;
            paddleHoldShapeOffset -= 0.4
            
        }
        else {
            paddleArray.removeAllObjects()
            paddleArrayIndex = 0
            paddle.removeAllChildren()
            paddleHoldShapeOffset = 0.6
            levelBar.size.width += 300
            score += 100
        }
        if paddleHoldShapeOffset < -0.2{
            paddleHoldShapeOffset = 0.6
        }
    }
    
    func randomShapeAndPosition(){
        if !isGameOver{
            var dropType = (Int)(arc4random()%3)
            var dropPositionOffset:Float = ((Float)(arc4random()%8 + 1))/10
            var drop:Drops
            switch(dropType){
            case 0:
                drop = Drops(name: "shape_circle")
                drop.type = dropType
                drop.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height)
                drop.runAction(SKAction.moveToY(-100, duration: 10 * speedOffset))
                self.addChild(drop)
                drop.runAction(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1))
                drop.color = bgColor
                break
            case 1:
                drop = Drops(name: "shape_square")
                drop.type = dropType
                drop.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height)
                drop.runAction(SKAction.moveToY(-100, duration: 10 * speedOffset))
                self.addChild(drop)
                drop.runAction(SKAction.rotateByAngle(CGFloat(M_PI), duration: 10 * speedOffset))
                break
            case 2:
                drop = Drops(name: "shape_triangle")
                drop.type = dropType
                drop.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height)
                drop.runAction(SKAction.moveToY(-100, duration: 10 * speedOffset))
                self.addChild(drop)
                drop.runAction(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1))
                break
            default:
                break
            }
        }
    }
    
    func dropShape(){
        var dropRandom = SKAction.runBlock({() in self.randomShapeAndPosition()})
        var delay = SKAction.waitForDuration(0.5)
        var dropAndDelay = SKAction.sequence([dropRandom, delay])
        var dropAndDelayForever = SKAction.repeatActionForever(dropAndDelay)
        self.runAction(dropAndDelayForever, withKey: "dropShape")
    }
    
    func gameOver(){
        isGameOver = true
        let children = self.children
        var shapesArray:NSMutableArray = NSMutableArray()
        for child : AnyObject in children{
            if child.isKindOfClass(Drops){
                shapesArray.addObject(child)
            }
        }
        for shape : AnyObject in shapesArray{
            shape.removeAllActions()
        }
        var gameOverText:SKLabelNode = SKLabelNode(text: "GAMEOVER")
        gameOverText.position = CGPointMake(self.size.width/2, self.size.height/2)
        gameOverText.color = SKColor.redColor()
        gameOverText.colorBlendFactor = 1
        self.addChild(gameOverText)
        self.removeAllActions()
    }
}