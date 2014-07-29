//
//  MyScene.m
//  GeometryCatch
//
//  Created by iosdev on 23/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
@synthesize paddle,speedOffset,paddleArray,paddleHoldShapeOffset, paddleArrayIndex, bgColor, level, levelBar, score, scoreLabel, isGameOver,gameOverTextCanBeAdded,gameOverText,levelLabel,rainNode,sparkArrayPaddle, sparkArrayWorld, sparkArrayIndex;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //First init
        paddleHoldShapeOffset = 0.8;
        paddleArrayIndex = 0;
        level = 1;
        score = 0;
        isGameOver = NO;
        speedOffset = -6;
        paddleArray = [[NSMutableArray alloc] initWithCapacity:3];
        
        sparkArrayIndex = 0;
        sparkArrayPaddle = [[NSMutableArray alloc] init];
        sparkArrayWorld = [[NSMutableArray alloc] init];
        
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        bgColor = [SKColor colorWithRed:(float)251/255 green:(float)174/255 blue:(float)23/255 alpha:1.0];
        self.backgroundColor = bgColor;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 1.1)];
        self.physicsBody.categoryBitMask = worldCategory;
        self.physicsBody.collisionBitMask = paddleCategory;
        
        //Paddle init
        paddle = [[SKSpriteNode alloc] initWithImageNamed:@"paddle"];
        [paddle setScale:0.2];
        paddle.position = CGPointMake(self.size.width /2, self.size.height*0.2);
        paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.size];
        paddle.physicsBody.allowsRotation = NO;
        paddle.physicsBody.dynamic = true;
        paddle.physicsBody.categoryBitMask = paddleCategory;
        paddle.physicsBody.collisionBitMask = worldCategory;
        paddle.physicsBody.contactTestBitMask = dropCategory;
        [self addChild:paddle];
        
        //Level bar init
        levelBar = [[SKSpriteNode alloc]initWithImageNamed:@"levelBar"];
        levelBar.anchorPoint = CGPointMake(0, 0.5);
        levelBar.position = CGPointMake(0, 0);
        levelBar.size = CGSizeMake(self.size.width/2, levelBar.size.height);
        //        levelBar.yScale = 2.0;
        [self addChild:levelBar];
        
        //Score label
        scoreLabel = [[SKLabelNode alloc] init];
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        scoreLabel.position = CGPointMake(self.size.width*0.9, self.size.height*0.9);
        scoreLabel.color = [SKColor blackColor];
        scoreLabel.colorBlendFactor = 1;
        [self addChild:scoreLabel];
        
//        [self dropShape];
        
        //Level label
        levelLabel = [[SKLabelNode alloc] init];
        levelLabel.text = [NSString stringWithFormat:@"%d", level];
        levelLabel.position = CGPointMake(self.size.width*0.1, self.size.height*0.9);
        levelLabel.color = [SKColor blackColor];
        levelLabel.colorBlendFactor = 1;
        [self addChild:levelLabel];
        
        
        //Drop shapes
        [self dropShape];
        
        
        //Particle rain
        NSString *rainPath =
        [[NSBundle mainBundle]
         pathForResource:@"Rain" ofType:@"sks"];
        rainNode =
        [NSKeyedUnarchiver unarchiveObjectWithFile:rainPath];
        rainNode.position = CGPointMake(self.size.width/2, self.size.height);
        [self addChild:rainNode];
        
//        int dropType = arc4random()%3;
//        float dropPositionOffset = (float)((arc4random()%8 + 1)*0.1);
//        self.testShape = [[Drops alloc] init:[self chooseShape:dropType]];
//        self.testShape.type = dropType;
//        self.testShape.name = @"drop";
//        self.testShape.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height);
//        [self addChild:self.testShape];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!isGameOver){
        //Move paddle
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            [paddle runAction:[SKAction moveToX:location.x duration:0.1]];
        }
    }
    else{
        //Repositioning and reset action
        NSArray *children = self.children;
        for (int i = 0; i < children.count; i++) {
            if([children[i] isKindOfClass:[Drops class]]){
                [children[i] removeFromParent];
            }
        }
        paddle.position = CGPointMake(self.size.width /2, self.size.height*0.2);
        score = 0;
        levelBar.size = CGSizeMake(self.size.width/2, levelBar.size.height);
        level = 1;
        isGameOver = NO;
        speedOffset = -5;
        [gameOverText removeFromParent];
        [self dropShape];
        
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!isGameOver){
        //Position paddle to touch position
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            paddle.position = CGPointMake(location.x, paddle.position.y);
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //Level bar reduce over time
    levelBar.size = CGSizeMake(levelBar.size.width - 0.1, levelBar.size.height);
    levelLabel.text = [NSString stringWithFormat:@"%d", level];
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    // if level bar > screen next level, if level bar < 0 gameover
    if(levelBar.size.width >= self.size.width){
        levelBar.size = CGSizeMake(self.size.width*0.2, levelBar.size.height);
        level++;
        speedOffset -= 2;
            }
    if(levelBar.size.width <= 0){
        [self gameOver];
    }
    
//    [self.testShape runAction:[SKAction moveBy:CGVectorMake(0, -1) duration:speedOffset]];
    for (int i = 0; i < self.children.count; i++) {
        if([[self.children[i] name] isEqual: @"drop"])
            [self.children[i] runAction:[SKAction moveBy:CGVectorMake(0, speedOffset) duration:0.01]];
    }

    
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKSpriteNode * takenShape;
    Drops *shape = (Drops*)contact.bodyB.node;
    
    //Spark particle init
    NSString *sparkPath =
    [[NSBundle mainBundle]
     pathForResource:@"Spark" ofType:@"sks"];
    SKEmitterNode *sparkNode =
    [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
    sparkNode.position = shape.position;
    [sparkNode setParticleTexture:[SKTexture textureWithImageNamed:[self chooseShape:shape.type]]];
    [shape removeFromParent];
    sparkNode.name = @"sparkNode";
    
    //If paddle is hit
    if(contact.bodyA.categoryBitMask == paddleCategory){
        
        SKAction *moveBack = [SKAction moveBy:CGVectorMake(0, -10.0) duration:0.02];
        SKAction *moveForth = [SKAction moveBy:CGVectorMake(0, 10.0) duration:0.3];
        SKAction *wait = [SKAction waitForDuration:0.02];
        SKAction *paddleImpact = [SKAction sequence:@[moveBack, wait, moveForth]];
        [paddle runAction:paddleImpact];
        
        //Add particle and delayed-remove
        [sparkArrayPaddle addObject:sparkNode];
        SKAction *spark = [SKAction runBlock:^{
            [self addChild:sparkNode];
        }];
        SKAction *delay = [SKAction waitForDuration:0.2];
        SKAction *disappear = [SKAction runBlock:^{
//            for (int i = 0; i < sparkArrayPaddle.count; i++) {
//                [sparkArrayPaddle[i] removeFromParent];
//            }
        }];
        SKAction *sparkAndDisappear = [SKAction sequence:@[spark, delay, disappear]];
        [self runAction:sparkAndDisappear];
        
        //Add taken shapes to paddle
        [paddleArray addObject:[NSNumber numberWithInt:shape.type]];
        
        //If the taken shape is not the same as the previous one
        if(paddleArrayIndex >= 1 && [paddleArray[paddleArrayIndex-1] integerValue] != shape.type && paddleArray[paddleArrayIndex-1] != nil){
            [paddleArray removeAllObjects];
            paddleArrayIndex = 0;
            [paddle removeAllChildren];
            paddleHoldShapeOffset = 0.8;
            levelBar.size = CGSizeMake(levelBar.size.width - self.size.width*0.2, levelBar.size.height);
        }
        
        //Or if the paddle array isn't full yet
        else if(paddleArrayIndex != 2){
            takenShape = [SKSpriteNode spriteNodeWithImageNamed:[self chooseShape:shape.type]];
            [paddle addChild:takenShape];
            takenShape.position = CGPointMake(paddle.size.width*(0.2-paddleHoldShapeOffset), 0);
            takenShape.color = bgColor;
            takenShape.colorBlendFactor = 1;
            paddleArrayIndex += 1;
            paddleHoldShapeOffset -= 0.6;
        }
        
        //Or else- this case mean match 3 has been made
        else{
            [paddleArray removeAllObjects];
            paddleArrayIndex = 0;
            [paddle removeAllChildren];
            paddleHoldShapeOffset = 0.6;
            levelBar.size = CGSizeMake(levelBar.size.width + self.size.width*0.3, levelBar.size.height);
            score += 100;
            
        }
        
        //Offset for taken shape displaying
        if(paddleHoldShapeOffset < -0.4){
            paddleHoldShapeOffset = 0.8;
        }
        
    }
    
    //If world's edge is hit
    else if(contact.bodyA.categoryBitMask == worldCategory){
        [sparkArrayWorld addObject:sparkNode];
        SKAction *spark = [SKAction runBlock:^{
            [self addChild:sparkNode];
        }];
        SKAction *delay = [SKAction waitForDuration:0.2];
        SKAction *disappear = [SKAction runBlock:^{
//            for (int i = 0; i < sparkArrayWorld.count; i++) {
//                [sparkArrayWorld[i] removeFromParent];
//            }
        }];
        SKAction *sparkAndDisappear = [SKAction sequence:@[spark, delay, disappear]];
        [self runAction:sparkAndDisappear];
        
    }
    
}

//Random shape and position of drops
-(void)randomShapeAndPosition{
    if(!isGameOver){
        int dropType = arc4random()%3;
        float dropPositionOffset = (float)((arc4random()%8 + 1)*0.1);
        Drops *drop = [[Drops alloc] init:[self chooseShape:dropType]];
        drop.type = dropType;
        drop.name = @"drop";
        drop.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height);
//        [drop runAction:[SKAction moveToY:-10 duration:(drop.position.y - self.size.width)*speedOffset]];
        [self addChild:drop];
        [drop runAction:[SKAction rotateByAngle:M_PI duration:1]];
    }
}

//Cased-load function for drop texture
-(NSString*)chooseShape:(int)input{
    NSString *temp = [[NSString alloc] init];
    switch (input) {
        case 0:
            temp = [NSString stringWithFormat:@"shape_circle"];
            break;
        case 1:
            temp = [NSString stringWithFormat:@"shape_square"];
            break;
        case 2:
            temp = [NSString stringWithFormat:@"shape_triangle"];
            break;
        default:
            break;
    }
    return temp;
}

//Init the dropping main loop
-(void)dropShape{
    SKAction *dropRandom = [SKAction runBlock:^{
        [self randomShapeAndPosition];
    }];
    SKAction *delay = [SKAction waitForDuration:0.3];
    SKAction *dropAndDelay = [SKAction sequence:@[dropRandom, delay]];
    SKAction *dropAndDelayForever = [SKAction repeatActionForever:dropAndDelay];
    [self runAction:dropAndDelayForever withKey:@"dropShape"];
}

//Gameover handling: disable actions and such
-(void)gameOver{
    isGameOver = YES;
    gameOverTextCanBeAdded = YES;
    NSArray *children = self.children;
    NSMutableArray *shapesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < children.count; i++) {
        if([children[i] isKindOfClass:[Drops class]]){
            [shapesArray addObject:children[i]];
        }
        if([[children[i] name]isEqual:@"sparkNode"]){
            [children[i] removeFromParent];
        }
    }
    for (int i = 0; i<shapesArray.count; i++) {
        [shapesArray[i] removeAllActions];
    }
    for (int i = 0; i < children.count; i++) {
        if(([[children[i] name]  isEqual: @"gameOverText"])){
            gameOverTextCanBeAdded = NO;
            break;
        }
    }
    
    if(gameOverTextCanBeAdded){
        
        gameOverText = [[SKLabelNode alloc] init];
        gameOverText.text = [NSString stringWithFormat:@"GAMEOVER"];
        gameOverText.name = @"gameOverText";
        gameOverText.position = CGPointMake(self.size.width/2, self.size.height/2);
        gameOverText.color = [SKColor redColor];
        gameOverText.colorBlendFactor = 1;
        [self addChild:gameOverText];
        gameOverTextCanBeAdded = NO;
        
    }
    [self removeAllActions];
    [sparkArrayPaddle removeAllObjects];
    
}
@end
