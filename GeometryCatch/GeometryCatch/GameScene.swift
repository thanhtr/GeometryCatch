//
//  GameScene.swift
//  GeometryCatch
//
//  Created by iosdev on 22/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    var paddle:SKSpriteNode!
    var speedOffset:Double!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        speedOffset = 0.3
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor.orangeColor()
        
        paddle = SKSpriteNode(imageNamed: "paddle1")
        paddle.position = CGPointMake(self.size.width/2, self.size.height * 0.2)
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.size)
        paddle.physicsBody.dynamic = false
        self.addChild(paddle)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let touch:UITouch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        paddle.position.x = location.x
        
        
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch:UITouch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        paddle.position.x = location.x
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
