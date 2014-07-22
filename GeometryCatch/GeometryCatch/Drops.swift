//
//  Drops.swift
//  GeometryCatch
//
//  Created by iosdev on 22/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

import UIKit
import SpriteKit



class Drops: SKSpriteNode {
    var type:Int
    var checkMatchArray:NSMutableArray
    init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        self.type = 0
        self.checkMatchArray = NSMutableArray(capacity: 3)
        super.init(texture: texture, color: color, size: size)
    }
    
    init(texture: SKTexture!){
        self.type = 0
        self.checkMatchArray = NSMutableArray(capacity: 3)
        super.init(texture:texture)
    }
    
    init(name:String) {
        //        self.type = type
        self.type = 0
        self.checkMatchArray = NSMutableArray(capacity: 3)
        super.init(imageNamed:name)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/2)
        self.physicsBody.dynamic = true
        self.physicsBody.categoryBitMask = dropCategory
        self.physicsBody.contactTestBitMask = paddleCategory
    }
}
