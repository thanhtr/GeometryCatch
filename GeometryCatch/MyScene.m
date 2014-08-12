//
//  MyScene.m
//  GeometryCatch
//
//  Created by iosdev on 23/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "MyScene.h"
#import "StartScene.h"
#import "ViewController.h"
@implementation MyScene
@synthesize paddle,speedOffset,paddleArray,paddleHoldShapeOffset, paddleArrayIndex, bgColor, levelBar, score, scoreLabel, isGameOver,gameOverTextCanBeAdded,gameOverText,levelLabel,rainNode, sparkArrayIndex, bgColorArray, bg, bgBlack, isPause,moveGroup, bgColorIndex;
//@synthesize level;
@synthesize gameOverBg,bestScoreLbl,bestScorePoint,yourScoreLbl,yourScorePoint,shareBtn,playBtn,gameOverGroup, gameCenterBtn,options;
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //First init
        options = [[Options alloc] init];
        
        bgColorArray = [NSArray arrayWithObjects:
                        [SKColor colorWithRed:(float)219/255 green:(float)68/255 blue:(float)83/255 alpha:1.0],
                        [SKColor colorWithRed:(float)233/255 green:(float)87/255 blue:(float)63/255 alpha:1.0],
                        [SKColor colorWithRed:(float)246/255 green:(float)187/255 blue:(float)66/255 alpha:1.0],
                        [SKColor colorWithRed:(float)140/255 green:(float)193/255 blue:(float)82/255 alpha:1.0],
                        [SKColor colorWithRed:(float)55/255 green:(float)188/255 blue:(float)155/255 alpha:1.0],
                        [SKColor colorWithRed:(float)59/255 green:(float)175/255 blue:(float)218/255 alpha:1.0],
                        [SKColor colorWithRed:(float)74/255 green:(float)137/255 blue:(float)220/255 alpha:1.0],
                        [SKColor colorWithRed:(float)67/255 green:(float)74/255 blue:(float)84/255 alpha:1.0],
                        nil];
        bgColorIndex = arc4random()%(bgColorArray.count);
        bgColor = bgColorArray[bgColorIndex];
        if(IS_IPAD_SCREEN)
            paddleHoldShapeOffset = 0.5;
        else
            paddleHoldShapeOffset = 1;
        paddleArrayIndex = 0;
        //        level = 1;
        score = 0;
        isGameOver = NO;
        isPause = NO;
        if(IS_IPAD_SCREEN)
            speedOffset = -4;
        else
            speedOffset = -2;
        paddleArray = [[NSMutableArray alloc] initWithCapacity:3];
        
        sparkArrayIndex = 0;
        
        
        self.physicsWorld.gravity = CGVectorMake(0, speedOffset);
        self.physicsWorld.contactDelegate = self;
        //        self.backgroundColor = bgColor;
        bg = [[SKSpriteNode alloc] initWithImageNamed:@"bg"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        bg.color = bgColor;
        if(IS_IPAD_SCREEN)
            [bg setScale:1.2];
        bg.colorBlendFactor = 1;
        [self addChild:bg];
        
        bgBlack = [[SKSpriteNode alloc] initWithImageNamed:@"bgBlack"];
        bgBlack.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgBlack.alpha = 0.0;
        if(IS_IPAD_SCREEN)
            [bgBlack setScale:1.2];
        [self addChild:bgBlack];
        
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 1.1)];
        self.physicsBody.categoryBitMask = worldCategory;
        self.physicsBody.collisionBitMask = paddleCategory;
        
        //Level bar init
        levelBar = [[SKSpriteNode alloc]initWithImageNamed:@"levelBar"];
        levelBar.anchorPoint = CGPointMake(0, 0.5);
        levelBar.position = CGPointMake(0, 0);
        levelBar.size = CGSizeMake(self.size.width/2, levelBar.size.height);
        //        levelBar.yScale = 2.0;
        levelBar.color = bgColor;
        levelBar.colorBlendFactor = 0.7;
        if(IS_IPAD_SCREEN)
            [levelBar setScale:1.5];
        [self addChild:levelBar];
        
        //Particle rain
        NSString *rainPath =
        [[NSBundle mainBundle]
         pathForResource:@"Rain" ofType:@"sks"];
        rainNode =
        [NSKeyedUnarchiver unarchiveObjectWithFile:rainPath];
        rainNode.position = CGPointMake(self.size.width/2, self.size.height);
        [rainNode setParticleColorSequence:nil];
        [rainNode setParticleColor:bgColor];
        [rainNode setParticleColorBlendFactor:0.8];
        if(IS_IPAD_SCREEN)
            [rainNode setParticleScale:0.6];
        [self addChild:rainNode];
        
        //Paddle init
        paddle = [[SKSpriteNode alloc] initWithImageNamed:@"paddle"];
        if(IS_IPAD_SCREEN)
            [paddle setScale:0.5];
        else
            [paddle setScale:0.2];
        if(IS_568_SCREEN)
            paddle.position = CGPointMake(self.size.width /2, self.size.height*0.15);
        else
            paddle.position = CGPointMake(self.size.width /2, self.size.height*0.18);
        
        paddle.name = @"paddle";
        paddle.blendMode = SKBlendModeAdd;
        paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.size];
        paddle.physicsBody.allowsRotation = NO;
        paddle.physicsBody.dynamic = false;
        paddle.physicsBody.categoryBitMask = paddleCategory;
        paddle.physicsBody.collisionBitMask = worldCategory;
        paddle.physicsBody.contactTestBitMask = dropCategory;
        paddle.color = [SKColor whiteColor];
        paddle.colorBlendFactor = 1;
        [self addChild:paddle];
        
        
        //Pause
        SKSpriteNode *pauseBtn = [[SKSpriteNode alloc] initWithImageNamed:@"pauseBtn"];
        if(IS_IPAD_SCREEN)
            [pauseBtn setScale:1.0];
        else
            [pauseBtn setScale:0.5];
        pauseBtn.position = CGPointMake(self.size.width*0.05, self.size.height*0.93);
        pauseBtn.name = @"pauseBtn";
        [self addChild:pauseBtn];
        
        
        
        //Score label
        scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        if(IS_568_SCREEN)
            scoreLabel.position = CGPointMake(self.size.width*0.5, self.size.height*0.88);
        else
            scoreLabel.position = CGPointMake(self.size.width*0.5, self.size.height*0.83);
        
        scoreLabel.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        if(IS_IPAD_SCREEN)
            scoreLabel.fontSize = 120;
        else
            scoreLabel.fontSize = 80;
        
        [self addChild:scoreLabel];
        
        //Game over frame
        gameOverGroup = [[NSMutableArray alloc]init];
        
        gameOverBg = [[SKSpriteNode alloc] initWithImageNamed:@"bg"];
        gameOverBg.position = CGPointMake(self.size.width/2, self.size.height/2 + self.size.height);
        
        if(IS_IPAD_SCREEN)
            gameOverBg.xScale = 1.2;
        else
            gameOverBg.xScale = 0.5;
        
        if(IS_568_SCREEN)
            gameOverBg.yScale = 0.5;
        else if(IS_IPAD_SCREEN)
            gameOverBg.yScale = 0.901;
        else
            gameOverBg.yScale = 0.4229;
        
        [gameOverGroup addObject:gameOverBg];
        
        SKLabelNode *bestScoreLblShadow = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            bestScoreLblShadow.position = CGPointMake(self.size.width/2, self.size.height*0.55 + self.size.height -3);
        else
            bestScoreLblShadow.position = CGPointMake(self.size.width/2, self.size.height*0.58 + self.size.height -3);
        
        bestScoreLblShadow.text = @"Best score";
        bestScoreLblShadow.fontColor = [SKColor colorWithRed:(float)74/255 green:(float)137/255 blue:(float)220/255 alpha:1.0];
        bestScoreLblShadow.fontSize = 67.5;
        if(IS_IPAD_SCREEN)
            [bestScoreLblShadow setScale:1.2];
        else
            [bestScoreLblShadow setScale:0.5];
        
        [gameOverGroup addObject:bestScoreLblShadow];
        
        
        bestScoreLbl = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            bestScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.55 + self.size.height);
        else
            bestScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.58 + self.size.height);
        
        bestScoreLbl.text = @"Best score";
        bestScoreLbl.fontColor = [SKColor blackColor];
        bestScoreLbl.fontSize = 67.5;
        if (IS_IPAD_SCREEN) {
            [bestScoreLbl setScale:1.2];
        }
        else
            [bestScoreLbl setScale:0.5];
        [gameOverGroup addObject:bestScoreLbl];
        
        bestScorePoint = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            
            bestScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.48 + self.size.height);
        else
            bestScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.5 + self.size.height);
        
        bestScorePoint.fontColor = [SKColor colorWithRed:(float)74/255 green:(float)137/255 blue:(float)220/255 alpha:1.0];
        bestScorePoint.fontSize = 67.5;
        if (IS_IPAD_SCREEN) {
            [bestScorePoint setScale:1.2];
        }
        else
            [bestScorePoint setScale:0.5];
        [gameOverGroup addObject:bestScorePoint];
        
        SKLabelNode *yourScoreLblShadow = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            yourScoreLblShadow.position = CGPointMake(self.size.width/2, self.size.height*0.7 + self.size.height -3);
        else
            yourScoreLblShadow.position = CGPointMake(self.size.width/2, self.size.height*0.75 + self.size.height -3);
        
        yourScoreLblShadow.text = @"Your score";
        yourScoreLblShadow.fontColor = [SKColor colorWithRed:(float)219/255 green:(float)68/255 blue:(float)83/255 alpha:1.0];
        yourScoreLblShadow.fontSize = 90;
        if (IS_IPAD_SCREEN) {
            [yourScoreLblShadow setScale:1.2];
        }
        else
            [yourScoreLblShadow setScale:0.5];
        [gameOverGroup addObject:yourScoreLblShadow];
        
        yourScoreLbl = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            yourScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.7 + self.size.height);
        else
            yourScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.75 + self.size.height);
        
        yourScoreLbl.text = @"Your score";
        yourScoreLbl.fontColor = [SKColor blackColor];
        yourScoreLbl.fontSize = 90;
        if (IS_IPAD_SCREEN) {
            [yourScoreLbl setScale:1.2];
        }
        else
            [yourScoreLbl setScale:0.5];
        [gameOverGroup addObject:yourScoreLbl];
        
        yourScorePoint = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            yourScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.62 + self.size.height);
        else
            yourScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.65 + self.size.height);
        
        yourScorePoint.fontColor = [SKColor colorWithRed:(float)219/255 green:(float)68/255 blue:(float)83/255 alpha:1.0];
        yourScorePoint.fontSize = 90;
        if (IS_IPAD_SCREEN) {
            [yourScorePoint setScale:1.2];
        }
        else
            [yourScorePoint setScale:0.5];
        [gameOverGroup addObject:yourScorePoint];
        
        shareBtn = [[SKSpriteNode alloc] initWithImageNamed:@"share"];
        if(IS_568_SCREEN)
            shareBtn.position = CGPointMake(self.size.width/2, self.size.height*0.38 + self.size.height);
        else
            shareBtn.position = CGPointMake(self.size.width/2, self.size.height*0.415 + self.size.height);
        
        if (IS_IPAD_SCREEN) {
            [shareBtn setScale:1.2];
        }
        else
            [shareBtn setScale:0.5];
        
        shareBtn.name = @"shareBtn";
        [gameOverGroup addObject:shareBtn];
        
        playBtn  = [[SKSpriteNode alloc] initWithImageNamed:@"play"];
        
        if(IS_568_SCREEN)
            playBtn.position = CGPointMake(self.size.width/2, self.size.height*0.24 +self.size.height);
        else
            playBtn.position = CGPointMake(self.size.width/2, self.size.height*0.25 +self.size.height);
        
        if (IS_IPAD_SCREEN) {
            playBtn.xScale = 1.2;
            playBtn.yScale = 1;
        }
        else
            [playBtn setScale:0.5];
        
        playBtn.name = @"playBtn";
        [gameOverGroup addObject:playBtn];
        
        gameCenterBtn = [[SKSpriteNode alloc] initWithImageNamed:@"gamecenter_button"];
        if(IS_568_SCREEN)
            gameCenterBtn.position = CGPointMake(self.size.width*0.9, self.size.height*0.9 +self.size.height);
        else
            gameCenterBtn.position = CGPointMake(self.size.width*0.9, self.size.height*0.9 +self.size.height);
        if (IS_IPAD_SCREEN) {
            [gameCenterBtn setScale:1.2];
        }
        else
            [gameCenterBtn setScale:0.5];
        gameCenterBtn.name = @"gameCenterBtn";
        [gameOverGroup addObject:gameCenterBtn];
        
        
        //Initial opening animation
        [self initColoredBackground];
        SKAction *move = [SKAction runBlock:^{
            for (int i = 0; i< moveGroup.count; i++) {
                if(i < bgColorIndex){
                    SKAction *slide = [SKAction moveByX:-self.size.width y:0 duration:1];
                    slide.timingMode = SKActionTimingEaseInEaseOut;
                    [moveGroup[i] runAction:slide];
                }
                else if (i > bgColorIndex){
                    SKAction *slide = [SKAction moveByX:self.size.width y:0 duration:1];
                    slide.timingMode = SKActionTimingEaseInEaseOut;
                    [moveGroup[i] runAction:slide];                }
                else if (i == bgColorIndex){
                    [moveGroup[i] runAction:[SKAction sequence:@[[SKAction colorizeWithColor:[SKColor clearColor] colorBlendFactor:1 duration:0.0], [SKAction waitForDuration:1.0], [SKAction runBlock:^{
                        [moveGroup[i] removeFromParent];
                    }]]]];
                }
            }
        }];
        SKAction *wait = [SKAction waitForDuration:1.5];
        SKAction *drop = [SKAction runBlock:^{
            //Drop shapes
            [self dropShape];
        }];
        [self runAction:[SKAction sequence:@[move, wait, drop]]];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if(!isGameOver){
            //Move paddle
            if(![node.name isEqualToString:@"pauseBtn"])
                [paddle runAction:[SKAction moveToX:location.x duration:0.1]];
            
        }
        else if(isGameOver){
            if([node.name isEqualToString:@"playBtn"]){
                //Repositioning and reset action
                [self addChild:paddle];
                NSArray *children = self.children;
                for (int i = 0; i < children.count; i++) {
                    if([children[i] isKindOfClass:[Drops class]]){
                        [children[i] removeFromParent];
                    }
                }
                paddle.position = CGPointMake(self.size.width /2, self.size.height*0.2);
                score = 0;
                levelBar.size = CGSizeMake(self.size.width/2, levelBar.size.height);
                //        level = 1;
                isGameOver = NO;
                if(IS_IPAD_SCREEN)
                    speedOffset = -4;
                else
                    speedOffset = -2;
                self.physicsWorld.gravity = CGVectorMake(0, speedOffset);
                [gameOverText removeFromParent];
                SKAction *moveGameOverBoard = [SKAction runBlock:^{
                    for (int i = 0; i < gameOverGroup.count; i++) {
                        SKAction *slideIn = [SKAction moveByX:0 y:self.size.height duration:0.2];
                        slideIn.timingMode = SKActionTimingEaseInEaseOut;
                        [gameOverGroup[i] runAction:slideIn];
                    }
                }];
                SKAction *removeGameOverBoardAndDropShape = [SKAction runBlock:^{
                    for (int i = 0; i < gameOverGroup.count; i++) {
                        [gameOverGroup[i] removeFromParent];
                    }
                    [self dropShape];
                }];
                [self runAction:[SKAction sequence:@[moveGameOverBoard, [SKAction waitForDuration:1], removeGameOverBoardAndDropShape]]];
            }
            else if([node.name isEqualToString:@"shareBtn"]){
                NSString *postText = [NSString stringWithFormat: @"I just got %d points in a ATOX run. How about you?", score];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:postText forKey:@"postText"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatePost" object:self userInfo:userInfo];
            }
        }
        
        if([node.name isEqualToString:@"pauseBtn"] && !isPause){
            bgBlack.alpha = 0.3;
            isPause = YES;
            //            [self runAction:[SKAction runBlock:^{
            //                [self runAction:[SKAction waitForDuration:0.1]];
            //                //                self.scene.view.paused = YES;
            //                self.scene.physicsWorld.speed = 0.0;
            //
            //            }]];
        }
        else if ([node.name isEqualToString:@"pauseBtn"] && isPause){
            isPause = NO;
            self.view.paused = NO;
            //            self.scene.view.paused = NO;
            bgBlack.alpha = 0.0;
            //            self.scene.physicsWorld.speed = 1.0;
            
        }
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
    if(IS_IPAD_SCREEN)
        levelBar.size = CGSizeMake(levelBar.size.width - 0.25, levelBar.size.height);
    else
        levelBar.size = CGSizeMake(levelBar.size.width - 0.1, levelBar.size.height);
    //    levelLabel.text = [NSString stringWithFormat:@"%d", level];
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    // if level bar > screen next level, if level bar < 0 gameover
    if(levelBar.size.width >= self.size.width){
        levelBar.size = CGSizeMake(self.size.width*0.2, levelBar.size.height);
        //        level++;
        if(IS_IPAD_SCREEN)
            speedOffset -= 4;
        else
            speedOffset -= 2;
        self.physicsWorld.gravity = CGVectorMake(0, speedOffset);
        int randomBgColorIndex = arc4random()%(bgColorArray.count);
        while (bgColorIndex == randomBgColorIndex) {
            randomBgColorIndex = arc4random()%(bgColorArray.count);
        }
        bgColorIndex = randomBgColorIndex;
        bgColor = bgColorArray[randomBgColorIndex];
        //        scoreLabel.color = bgColor;
        //        scoreLabel.colorBlendFactor = 0.9;
        [bg runAction:[SKAction colorizeWithColor:bgColor colorBlendFactor:1 duration:0.3]];
        
        levelBar.color = bgColor;
        levelBar.colorBlendFactor = 0.7;
        [rainNode setParticleColorSequence:nil];
        [rainNode setParticleColor:bgColor];
        [rainNode setParticleColorBlendFactor:0.8];
        
    }
    if(levelBar.size.width <= 0){
        [self gameOver];
    }
    
    if(!isPause){
        //            self.view.paused = NO;
        if(self.physicsWorld.speed < 1)
            self.physicsWorld.speed += 0.05;
    }
    else if(isPause){
        if(self.physicsWorld.speed > 0)
            self.physicsWorld.speed -= 0.05;
        else if (self.physicsWorld.speed <= 0)
            self.view.paused = YES;
    }
    if(paddle.position.x < paddle.size.width/2){
        paddle.position = CGPointMake(paddle.size.width/2, paddle.position.y);
    }
    else if (paddle.position.x > self.size.width -paddle.size.width/2){
        paddle.position = CGPointMake(self.size.width -paddle.size.width/2, paddle.position.y);
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
    [sparkNode setParticleTexture:[SKTexture textureWithImageNamed:[self chooseParticleShape:shape.type]]];
    if(IS_IPAD_SCREEN)
        [sparkNode setParticleScale:0.3];
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
        SKAction *spark = [SKAction runBlock:^{
            [self addChild:sparkNode];
            
        }];
        SKAction *delay = [SKAction waitForDuration:0.2];
        SKAction *disappear = [SKAction runBlock:^{
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
            if(IS_IPAD_SCREEN)
                paddleHoldShapeOffset = 0.5;
            else
                paddleHoldShapeOffset = 1;
            levelBar.size = CGSizeMake(levelBar.size.width - self.size.width*0.2, levelBar.size.height);
        }
        
        //Or if the paddle array isn't full yet
        else if(paddleArrayIndex != 2){
            takenShape = [SKSpriteNode spriteNodeWithImageNamed:[self chooseShape:shape.type]];
            [paddle addChild:takenShape];
            takenShape.position = CGPointMake(paddle.size.width*(0-paddleHoldShapeOffset), 0);
            takenShape.color = bgColor;
            takenShape.colorBlendFactor = 1;
            paddleArrayIndex += 1;
            if(IS_IPAD_SCREEN)
                paddleHoldShapeOffset -= 0.5;
            else
                paddleHoldShapeOffset -= 1;
            
        }
        
        //Or else- this case mean match 3 has been made
        else{
            [paddleArray removeAllObjects];
            paddleArrayIndex = 0;
            [paddle removeAllChildren];
            if(IS_IPAD_SCREEN)
                paddleHoldShapeOffset = 0.5;
            else
                paddleHoldShapeOffset = 1;
            levelBar.size = CGSizeMake(levelBar.size.width + self.size.width*0.3, levelBar.size.height);
            score += 1;
            
            SKAction *flash = [SKAction repeatAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.05], [SKAction waitForDuration:0.05], [SKAction fadeInWithDuration:0.05]]] count:4];
            [paddle runAction:flash];
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"success.wav" waitForCompletion:NO]];
        }
        
        //Offset for taken shape displaying
        if(IS_IPAD_SCREEN){
            if(paddleHoldShapeOffset < -0.5){
                paddleHoldShapeOffset = 0.5;
            }
        }
        else{
            if(paddleHoldShapeOffset < -1){
                paddleHoldShapeOffset = 1;
            }
        }
    }
    
    //If world's edge is hit
    else if(contact.bodyA.categoryBitMask == worldCategory){
        SKAction *spark = [SKAction runBlock:^{
            [self addChild:sparkNode];
        }];
        SKAction *delay = [SKAction waitForDuration:0.2];
        SKAction *disappear = [SKAction runBlock:^{
            [shape removeFromParent];
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
        if(IS_IPAD_SCREEN)
            [drop setScale:0.8];
        [self addChild:drop];
        [drop runAction:[SKAction rotateByAngle:4*M_PI duration:2]];
    }
}

//Cased-load function for drop texture
-(NSString*)chooseShape:(int)input{
    NSString *temp = [[NSString alloc] init];
    switch (input) {
        case 0:
            temp = [NSString stringWithFormat:@"shape_x"];
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

//Cased-load function for particle texture
-(NSString*)chooseParticleShape:(int)input{
    NSString *temp = [[NSString alloc] init];
    switch (input) {
        case 0:
            temp = [NSString stringWithFormat:@"shape_x"];
            break;
        case 1:
            temp = [NSString stringWithFormat:@"square_particle"];
            break;
        case 2:
            temp = [NSString stringWithFormat:@"triangle_particle"];
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
    
    UIView *myView = self.scene.view;
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:6];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([myView center].x - 5.0f, [myView center].y - 5.0f)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([myView center].x + 5.0f, [myView center].y + 5.0f)]];
    
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
    [self removeAllActions];
    [paddle removeAllChildren];
    [paddle removeFromParent];
    
    if(gameOverTextCanBeAdded){
        [[myView layer] addAnimation:animation forKey:@"position"];
        gameOverText = [[SKLabelNode alloc] init];
        gameOverText.text = [NSString stringWithFormat:@"GAMEOVER"];
        gameOverText.name = @"gameOverText";
        gameOverText.hidden = YES;
        gameOverText.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:gameOverText];
        
        if(options.soundOn)
            [self runAction:[SKAction playSoundFileNamed:@"gameover_final.wav" waitForCompletion:NO]];
        
        for (int i = 0; i < 3; i++) {
            NSString *xplosionPath =
            [[NSBundle mainBundle]
             pathForResource:@"Explosion" ofType:@"sks"];
            SKEmitterNode *xplosionNode =
            [NSKeyedUnarchiver unarchiveObjectWithFile:xplosionPath];
            xplosionNode.position = paddle.position;
            [xplosionNode setParticleTexture:[SKTexture textureWithImageNamed:[self chooseParticleShape:i]]];
            if(IS_IPAD_SCREEN)
               [xplosionNode setParticleScale:0.6];
            [self addChild:xplosionNode];
        }
        
        //        yourScorePoint.text = [NSString stringWithFormat:@"%d", score];
        [self incrementScore:score label:yourScorePoint];
        [self getHighscore];
        if([self getHighscore] > score)
            bestScorePoint.text = [NSString stringWithFormat:@"%d", [self getHighscore]];
        else {
            bestScorePoint.text = [NSString stringWithFormat:@"%d", score];
            [self saveHighscore:score];
        }
        for (int i = 0; i < gameOverGroup.count; i++) {
            [self addChild:gameOverGroup[i]];
            SKAction *slideIn = [SKAction moveByX:0 y:-self.size.height duration:0.5];
            slideIn.timingMode = SKActionTimingEaseInEaseOut;
            [gameOverGroup[i] runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], slideIn]]];
        }
        gameOverTextCanBeAdded = NO;
    }
}

-(void)incrementScore:(int)limit label:(SKLabelNode*)label{
    __block int i = 0;
    [label runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        label.text = [NSString stringWithFormat:@"%d", i];
        i++;
    }],[SKAction waitForDuration:0.0000]]] count:limit+1]];
}

-(int)getHighscore{
    int highscore;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"highscore"] != nil){
        highscore = [defaults integerForKey:@"highscore"];
    } else highscore = 0;
    return highscore;
}

-(void)saveHighscore:(int)points{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(points) forKey:@"highscore"];
    [defaults synchronize];
}
-(void)initColoredBackground{
    
    moveGroup = [[NSMutableArray alloc]init];
    
    SKSpriteNode *column1 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)219/255 green:(float)68/255 blue:(float)83/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column1.position = CGPointMake(self.size.width/8 - column1.size.width/2, self.size.height/2);
    [self addChild:column1];
    [moveGroup addObject:column1];
    
    SKSpriteNode *column2 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)233/255 green:(float)87/255 blue:(float)63/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column2.position = CGPointMake(2*self.size.width/8 - column2.size.width/2, self.size.height/2);
    [self addChild:column2];
    [moveGroup addObject:column2];
    
    SKSpriteNode *column3 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)246/255 green:(float)187/255 blue:(float)66/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column3.position = CGPointMake(3*self.size.width/8 - column3.size.width/2, self.size.height/2);
    [self addChild:column3];
    [moveGroup addObject:column3];
    
    SKSpriteNode *column4 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)140/255 green:(float)193/255 blue:(float)82/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column4.position = CGPointMake(4*self.size.width/8 - column4.size.width/2, self.size.height/2);
    [self addChild:column4];
    [moveGroup addObject:column4];
    
    SKSpriteNode *column5 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)55/255 green:(float)188/255 blue:(float)155/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column5.position = CGPointMake(5*self.size.width/8 - column5.size.width/2, self.size.height/2);
    [self addChild:column5];
    [moveGroup addObject:column5];
    
    SKSpriteNode *column6 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)59/255 green:(float)175/255 blue:(float)218/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column6.position = CGPointMake(6*self.size.width/8 - column6.size.width/2, self.size.height/2);
    [self addChild:column6];
    [moveGroup addObject:column6];
    
    SKSpriteNode *column7 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)74/255 green:(float)137/255 blue:(float)220/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column7.position = CGPointMake(7*self.size.width/8 - column7.size.width/2, self.size.height/2);
    [self addChild:column7];
    [moveGroup addObject:column7];
    
    SKSpriteNode *column8 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)67/255 green:(float)74/255 blue:(float)84/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column8.position = CGPointMake(8*self.size.width/8 - column8.size.width/2, self.size.height/2);
    [self addChild:column8];
    [moveGroup addObject:column8];
    
}
@end
