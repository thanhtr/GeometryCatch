//
//  MyScene.m
//  GeometryCatch
//
//  Created by iosdev on 23/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
@synthesize paddle,speedOffset,paddleArray,paddleHoldShapeOffset, paddleArrayIndex, bgColor, levelBar, score, scoreLabel, isGameOver,gameOverTextCanBeAdded,gameOverText,levelLabel,rainNode,sparkArrayPaddle, sparkArrayWorld, sparkArrayIndex, bgColorArray, bg, bgBlack, isPause,moveGroup, bgColorIndex;
//@synthesize level;
@synthesize gameOverBg,bestScoreLbl,bestScorePoint,yourScoreLbl,yourScorePoint,shareBtn,playBtn,gameOverGroup;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //First init
        
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
        
        paddleHoldShapeOffset = 1;
        paddleArrayIndex = 0;
        //        level = 1;
        score = 0;
        isGameOver = NO;
        isPause = NO;
        speedOffset = -6;
        paddleArray = [[NSMutableArray alloc] initWithCapacity:3];
        
        sparkArrayIndex = 0;
        sparkArrayPaddle = [[NSMutableArray alloc] init];
        sparkArrayWorld = [[NSMutableArray alloc] init];
        
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        //        self.backgroundColor = bgColor;
        bg = [[SKSpriteNode alloc] initWithImageNamed:@"bg"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        bg.color = bgColor;
        bg.colorBlendFactor = 1;
        [self addChild:bg];
        
        bgBlack = [[SKSpriteNode alloc] initWithImageNamed:@"bgBlack"];
        bgBlack.position = CGPointMake(self.size.width/2, self.size.height/2);
        bgBlack.alpha = 0.0;
        [self addChild:bgBlack];
        
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 1.1)];
        self.physicsBody.categoryBitMask = worldCategory;
        self.physicsBody.collisionBitMask = paddleCategory;
        
        //Paddle init
        paddle = [[SKSpriteNode alloc] initWithImageNamed:@"paddle"];
        [paddle setScale:0.2];
        paddle.position = CGPointMake(self.size.width /2, self.size.height*0.2);
        paddle.name = @"paddle";
        paddle.blendMode = SKBlendModeAdd;
        paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.size];
        paddle.physicsBody.allowsRotation = NO;
        paddle.physicsBody.dynamic = true;
        paddle.physicsBody.categoryBitMask = paddleCategory;
        paddle.physicsBody.collisionBitMask = worldCategory;
        paddle.physicsBody.contactTestBitMask = dropCategory;
        paddle.color = [SKColor whiteColor];
        paddle.colorBlendFactor = 1;
        [self addChild:paddle];
        
        //Level bar init
        levelBar = [[SKSpriteNode alloc]initWithImageNamed:@"levelBar"];
        levelBar.anchorPoint = CGPointMake(0, 0.5);
        levelBar.position = CGPointMake(0, 0);
        levelBar.size = CGSizeMake(self.size.width/2, levelBar.size.height);
        //        levelBar.yScale = 2.0;
        levelBar.color = bgColor;
        levelBar.colorBlendFactor = 0.7;
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
        //        levelLabel = [[SKLabelNode alloc] init];
        //        levelLabel.text = [NSString stringWithFormat:@"%d", level];
        //        levelLabel.position = CGPointMake(self.size.width*0.1, self.size.height*0.9);
        //        levelLabel.color = [SKColor blackColor];
        //        levelLabel.colorBlendFactor = 1;
        //        [self addChild:levelLabel];
        //
        

        
        
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
        [self addChild:rainNode];
        
        //Pause
        SKSpriteNode *pauseBtn = [[SKSpriteNode alloc] initWithImageNamed:@"pauseBtn"];
        [pauseBtn setScale:0.1];
        pauseBtn.position = CGPointMake(self.size.width*0.05, self.size.height*0.93);
        pauseBtn.name = @"pauseBtn";
        [self addChild:pauseBtn];

        //Initial opening animation
        [self initColoredBackground];
        SKAction *move = [SKAction runBlock:^{
            for (int i = 0; i< moveGroup.count; i++) {
                if(i < bgColorIndex){
                    [moveGroup[i] runAction:[SKAction moveByX:-self.size.width y:0 duration:1]];
                }
                else if (i > bgColorIndex){
                    [moveGroup[i] runAction:[SKAction moveByX:self.size.width y:0 duration:1]];
                }
                else if (i == bgColorIndex){
                    [moveGroup[i] runAction:[SKAction colorizeWithColor:[SKColor clearColor] colorBlendFactor:1 duration:0.0]];
                }
                
            }
        }];
        SKAction *wait = [SKAction waitForDuration:1.5];
        SKAction *drop = [SKAction runBlock:^{
            //Drop shapes
            [self dropShape];
        }];
        [self runAction:[SKAction sequence:@[move, wait, drop]]];

        //Game over frame
        gameOverGroup = [[NSMutableArray alloc]init];
        
        gameOverBg = [[SKSpriteNode alloc] initWithImageNamed:@"bg"];
        gameOverBg.position = CGPointMake(self.size.width/2, self.size.height/2 + self.size.height);
        gameOverBg.xScale = 0.5;
        gameOverBg.yScale = 0.5;
//        [self addChild:gameOverBg];
        [gameOverGroup addObject:gameOverBg];
        
        bestScoreLbl = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-UltraLight"];
        bestScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.6 + self.size.height);
        bestScoreLbl.text = @"Best score";
        bestScoreLbl.fontColor = [SKColor blackColor];
        bestScoreLbl.fontSize = 90;
        [bestScoreLbl setScale:0.5];
//        [self addChild:bestScoreLbl];
        [gameOverGroup addObject:bestScoreLbl];

        bestScorePoint = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-UltraLight"];
        bestScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.5 + self.size.height);
        bestScorePoint.text = @"25";
        bestScorePoint.fontColor = [SKColor blackColor];
        bestScorePoint.fontSize = 90;
        [bestScorePoint setScale:0.5];
//        [self addChild:bestScorePoint];
        [gameOverGroup addObject:bestScorePoint];

        yourScoreLbl = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-UltraLight"];
        yourScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.8 + self.size.height);
        yourScoreLbl.text = @"Your score";
        yourScoreLbl.fontColor = [SKColor blackColor];
        yourScoreLbl.fontSize = 120;
        [yourScoreLbl setScale:0.5];
//        [self addChild:yourScoreLbl];
        [gameOverGroup addObject:yourScoreLbl];

        yourScorePoint = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-UltraLight"];
        yourScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.7 + self.size.height);
        yourScorePoint.text = @"12";
        yourScorePoint.fontColor = [SKColor blackColor];
        yourScorePoint.fontSize = 120;
        [yourScorePoint setScale:0.5];
//        [self addChild:yourScorePoint];
        [gameOverGroup addObject:yourScorePoint];

        shareBtn = [[SKSpriteNode alloc] initWithImageNamed:@"share"];
        shareBtn.position = CGPointMake(self.size.width/2, self.size.height*0.4 + self.size.height);
        [shareBtn setScale:0.5];
        shareBtn.name = @"shareBtn";
//        [self addChild:shareBtn];
        [gameOverGroup addObject:shareBtn];

        playBtn  = [[SKSpriteNode alloc] initWithImageNamed:@"play"];
        playBtn.position = CGPointMake(self.size.width/2, self.size.height*0.25 +self.size.height);
        [playBtn setScale:0.5];
        playBtn.name = @"playBtn";
//        [self addChild:playBtn];
        [gameOverGroup addObject:playBtn];

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
            //        level = 1;
            isGameOver = NO;
            speedOffset = -5;
            [gameOverText removeFromParent];
            if([node.name isEqualToString:@"playBtn"]){
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
        }
        
        if([node.name isEqualToString:@"pauseBtn"] && !isPause){
            bgBlack.alpha = 0.3;
            isPause = YES;
            [self runAction:[SKAction runBlock:^{
                [self runAction:[SKAction waitForDuration:0.1]];
                //                self.scene.view.paused = YES;
                self.scene.physicsWorld.speed = 0.0;
                
            }]];
        }
        else if ([node.name isEqualToString:@"pauseBtn"] && isPause){
            isPause = NO;
            //            self.scene.view.paused = NO;
            bgBlack.alpha = 0.0;
            self.scene.physicsWorld.speed = 1.0;
            
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
    levelBar.size = CGSizeMake(levelBar.size.width - 0.1, levelBar.size.height);
    //    levelLabel.text = [NSString stringWithFormat:@"%d", level];
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    // if level bar > screen next level, if level bar < 0 gameover
    if(levelBar.size.width >= self.size.width){
        levelBar.size = CGSizeMake(self.size.width*0.2, levelBar.size.height);
        //        level++;
        speedOffset -= 2;
        
        int randomBgColorIndex = arc4random()%(bgColorArray.count);
        while (bgColorIndex == randomBgColorIndex) {
            randomBgColorIndex = arc4random()%(bgColorArray.count);
        }
        bgColorIndex = randomBgColorIndex;
        bgColor = bgColorArray[randomBgColorIndex];
        //        self.backgroundColor = bgColor;
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
    
    for (int i = 0; i < self.children.count; i++) {
        if([[self.children[i] name] isEqual: @"drop"]){
            [self.children[i] runAction:[SKAction moveBy:CGVectorMake(0, speedOffset) duration:0.01]];
            if([self.children[i] position].y < 0)
               [self.children[i] removeFromParent];
        }
    }
    //    NSLog(isPause ? @"YES" : @"NO");
    //    if(!isPause){
    ////        if(self.physicsWorld.speed <= 1)
    //            self.physicsWorld.speed += 0.05;
    //    }
    //    else if(isPause){
    ////        if(self.physicsWorld.speed >= 0)
    //            self.physicsWorld.speed -= 0.05;
    //    }
    
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
            paddleHoldShapeOffset -= 1;
            
                   }
        
        //Or else- this case mean match 3 has been made
        else{
            [paddleArray removeAllObjects];
            paddleArrayIndex = 0;
            [paddle removeAllChildren];
            paddleHoldShapeOffset = 1;
            levelBar.size = CGSizeMake(levelBar.size.width + self.size.width*0.3, levelBar.size.height);
            score += 1;

            SKAction *flash = [SKAction repeatAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.05], [SKAction waitForDuration:0.05], [SKAction fadeInWithDuration:0.05]]] count:4];
            [paddle runAction:flash];

        }
        
        //Offset for taken shape displaying
        if(paddleHoldShapeOffset < -1){
            paddleHoldShapeOffset = 1;
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
    
    if(gameOverTextCanBeAdded){
        [[myView layer] addAnimation:animation forKey:@"position"];
        gameOverText = [[SKLabelNode alloc] init];
        gameOverText.text = [NSString stringWithFormat:@"GAMEOVER"];
        gameOverText.name = @"gameOverText";
        gameOverText.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:gameOverText];
        yourScorePoint.text = [NSString stringWithFormat:@"%d", score];
        for (int i = 0; i < gameOverGroup.count; i++) {
            [self addChild:gameOverGroup[i]];
            SKAction *slideIn = [SKAction moveByX:0 y:-self.size.height duration:0.5];
            slideIn.timingMode = SKActionTimingEaseInEaseOut;
            [gameOverGroup[i] runAction:slideIn];
        }
        gameOverTextCanBeAdded = NO;
        
    }
    [self removeAllActions];
    [sparkArrayPaddle removeAllObjects];
    [paddle removeAllChildren];
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
    
    SKSpriteNode *column8 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.size.width/8, self.size.height)];
    column8.position = CGPointMake(8*self.size.width/8 - column8.size.width/2, self.size.height/2);
    [self addChild:column8];
    [moveGroup addObject:column8];
    
}
@end
