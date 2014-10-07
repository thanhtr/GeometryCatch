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
#import "SKEase.h"
#import "GameOverScene.h"

@interface MyScene()
@property NSMutableArray *sparkEmitter;
@end

@implementation MyScene
@synthesize paddle,speedOffset,paddleArray,paddleHoldShapeOffset, paddleArrayIndex, bgColor, levelBar, scoreLabel, isGameOver,gameOverTextCanBeAdded,gameOverText,rainNode, sparkArrayIndex, bgColorArray, bg, bgBlack, isPause,moveGroup, bgColorIndex, pauseBtn, gameOverBg,bestScoreLbl,bestScorePoint,yourScoreLbl,yourScorePoint,shareBtn,playBtn,gameOverGroup, gameCenterBtn,options,bgMusicPlayer,musicBtn,soundBtn,creditBtn,aboutBg, properlyInView,lastButton,trailingSpriteArray,trailingSpriteArrayIndex,dropArray,dropArrayIndex;
//@synthesize score;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //First init
        [self createInitElements];
        
        //Gameover elements
        //        [self createGameOverBoardElements];
        
        //Initial opening animation
        if(canLoadColoredColumn)
            [self initColoredBackground];
        self.sparkEmitter = [[NSMutableArray alloc] init];
        for (int i = 0; i< 3; i++){
            NSString *sparkPath =
            [[NSBundle mainBundle]
             pathForResource:@"Spark" ofType:@"sks"];
            SKEmitterNode *sparkNode =
            [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
            [sparkNode setParticleTexture:[SKTexture textureWithImageNamed:[self chooseParticleShape:i]]];
            if(IS_IPAD_SCREEN)
                [sparkNode setParticleScale:0.3];
            //    [shape removeFromParent];
            sparkNode.name = @"sparkNode";
            [self.sparkEmitter insertObject:sparkNode atIndex:i];
            
        }
        for (int i = 0; i< 30; i++) {
            int dropType = arc4random()%3;
            float dropPositionOffset = (float)((arc4random()%8 + 1)*0.1);
            Drops *drop;
            
            drop = [[Drops alloc] init:[self chooseShape:dropType]];
            if(IS_IPAD_SCREEN)
                [drop setScale:0.8];
            
            drop.type = dropType;
            drop.name = @"drop";
            drop.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height);
            
            [dropArray addObject:drop];
        }
        
        SKAction *move = [SKAction runBlock:^{
            if(canLoadColoredColumn){
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
            }
        }];
        
        SKAction *wait = [SKAction waitForDuration:1.5];
        SKAction *drop = [SKAction runBlock:^{
            //Drop shapes
            [self dropShape];
            canLoadColoredColumn = NO;
        }];
        [self runAction:[SKAction sequence:@[move, wait, drop]]];
        
    }
    return self;
}
-(void)createInitElements{
    options = [[Options alloc] init];
    lastButton = [[NSString alloc] init];
    trailingSpriteArray = [[NSMutableArray alloc] init];
    dropArray = [[NSMutableArray alloc] init];
    trailingSpriteArrayIndex = 0;
    dropArrayIndex = 0;
    
    //bg music
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"ingame1" withExtension:@"mp3"];
    bgMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    bgMusicPlayer.numberOfLoops = -1; //-1 = infinite loop
    bgMusicPlayer.enableRate = YES;
    [bgMusicPlayer prepareToPlay];
    
    //if music on play bg music
    if (options.musicOn) {
        [bgMusicPlayer play];
    }
    
    //color array of bg
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
    
    //offset and index for controlling paddle's caught shapes
    if(IS_IPAD_SCREEN){
        paddleHoldShapeOffset = 0.5;
        speedOffset = -4;
    }
    else{
        paddleHoldShapeOffset = 1;
        speedOffset = -2;
    }
    paddleArrayIndex = 0;
    
    score = 0;
    isGameOver = NO;
    isPause = NO;
    properlyInView = YES;
    
    paddleArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    sparkArrayIndex = 0;
    
    //world physic properties
    self.physicsWorld.gravity = CGVectorMake(0, speedOffset);
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 1.1)];
    self.physicsBody.categoryBitMask = worldCategory;
    self.physicsBody.collisionBitMask = paddleCategory;
    
    //bg
    bg = [[SKSpriteNode alloc] initWithImageNamed:@"bg"];
    bg.position = CGPointMake(self.size.width/2, self.size.height/2);
    bg.color = bgColor;
    if(IS_IPAD_SCREEN)
        [bg setScale:1.2];
    bg.colorBlendFactor = 1;
    [self addChild:bg];
    
    //fake bg used when paused
    bgBlack = [[SKSpriteNode alloc] initWithImageNamed:@"bgBlack"];
    bgBlack.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgBlack.alpha = 0.0;
    if(IS_IPAD_SCREEN)
        [bgBlack setScale:1.2];
    [self addChild:bgBlack];
    
    
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
    
    
    //Level bar init
    SKSpriteNode *levelBarBehind;
    if(IS_IPAD_SCREEN)
    {
        levelBarBehind = [[SKSpriteNode alloc] initWithImageNamed:@"interestBar_Below768"];
    }
    else
        levelBarBehind = [[SKSpriteNode alloc] initWithImageNamed:@"interestBar_Below"];
    levelBarBehind.anchorPoint = CGPointMake(0.5, 1);
    levelBarBehind.position = CGPointMake(self.size.width/2, self.size.height);
//    levelBarBehind.size = CGSizeMake(self.size.width, levelBarBehind.size.height);
    //    [levelBarBehind setScale:2.0];
    if(IS_IPAD_SCREEN)
    {
        levelBarBehind.xScale = 1.0;
        levelBarBehind.yScale = 0.75;
    }
    else
    {
        levelBarBehind.xScale = 1.0;
        levelBarBehind.yScale = 0.5;
    }
    [self addChild:levelBarBehind];
    
    levelBar = [[SKSpriteNode alloc]initWithImageNamed:@"interestBar_Above"];
    levelBar.anchorPoint = CGPointMake(1, 1);
    levelBar.position = CGPointMake(self.size.width, self.size.height);
    levelBar.size = CGSizeMake(self.size.width*0.5, levelBar.size.height);
    //        levelBar.yScale = 2.0;
    //levelBar.color = bgColor;
    //levelBar.colorBlendFactor = 0.7;
    if(IS_IPAD_SCREEN)
    {
        levelBar.xScale = 1.5;
        levelBar.yScale = 0.75;
    }
    else
    {
        levelBar.xScale = 1.0;
        levelBar.yScale = 0.5;
    }
    
    [self addChild:levelBar];
    
    
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
    
    //Pause button
    pauseBtn = [[SKSpriteNode alloc] initWithImageNamed:@"pauseBtn"];
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
        scoreLabel.position = CGPointMake(self.size.width*0.5, self.size.height*0.85);
    else
        scoreLabel.position = CGPointMake(self.size.width*0.5, self.size.height*0.83);
    scoreLabel.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    if(IS_IPAD_SCREEN)
        scoreLabel.fontSize = 120;
    else
        scoreLabel.fontSize = 80;
    [self addChild:scoreLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        lastButton = node.name;
        if(!isGameOver){
            //Move paddle
            if(![node.name isEqualToString:@"pauseBtn"])
                [paddle runAction:[SKAction moveToX:location.x duration:0.1]];
        }
        
        //pause
        if([node.name isEqualToString:@"pauseBtn"] && !isPause){
            [self removeActionForKey:@"dropShape"];
            bgBlack.alpha = 0.3;
            isPause = YES;
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"pausegame.mp3" waitForCompletion:NO]];
            [bgMusicPlayer pause];
        }
        //un pause
        else if ([node.name isEqualToString:@"pauseBtn"] && isPause){
            isPause = NO;
            self.view.paused = NO;
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"unpause.mp3" waitForCompletion:NO]];
            if(options.musicOn)
                [bgMusicPlayer play];
            bgBlack.alpha = 0.0;
            [self dropShape];
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

-(void)createTrailingSprites{
    for (int i = 0; i<self.children.count; i++) {
        SKNode* child = self.children[i];
        if([child.name isEqualToString:@"drop"] && child.position.x < self.size.width){
            Drops *drop = (Drops*)child;
            SKSpriteNode *trailSprite;
            if (trailingSpriteArray.count >= 30) {
                trailSprite = trailingSpriteArray[trailingSpriteArrayIndex];
                trailSprite.texture = [SKTexture textureWithImageNamed:[self chooseShape:drop.type]];
                trailSprite.zRotation = drop.zRotation;
                trailSprite.position = CGPointMake(drop.position.x, drop.position.y -2);
                trailSprite.alpha = 0.05;
                [trailSprite runAction:[SKAction fadeAlphaTo:0 duration:0.1]];
                
            }
            else {
                trailSprite = [SKSpriteNode spriteNodeWithImageNamed:[self chooseShape:drop.type]];
                trailSprite.texture = [SKTexture textureWithImageNamed:[self chooseShape:drop.type]];
                trailSprite.zRotation = drop.zRotation;
                trailSprite.blendMode = SKBlendModeAdd;
                trailSprite.position = CGPointMake(drop.position.x, drop.position.y -2);
                trailSprite.alpha = 0.05;
                if(!IS_IPAD_SCREEN){
                    [trailSprite setScale:0.35];
                }
                [trailingSpriteArray addObject:trailSprite];
                [self addChild:trailSprite];
                [trailSprite runAction:[SKAction fadeAlphaTo:0 duration:0.1]];
                
            }
            if(trailingSpriteArrayIndex < 29)
                trailingSpriteArrayIndex ++;
            else trailingSpriteArrayIndex = 0;
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //create trailing sprite of drops
    if(!isGameOver){
        if (self.timeSinceUpdated == 0 || currentTime - self.timeSinceUpdated > 0.01) {
            [self createTrailingSprites];
            self.timeSinceUpdated = currentTime;
        }
    }
    //level bar reduced over time
    if(IS_IPAD_SCREEN)
        levelBar.size = CGSizeMake(levelBar.size.width + 0.5, levelBar.size.height);
    else
        levelBar.size = CGSizeMake(levelBar.size.width + 0.2, levelBar.size.height);
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    // if level bar > screen next level, if level bar < 0 gameover
    if(levelBar.size.width <= 0){
        levelBar.size = CGSizeMake(self.size.width*0.6, levelBar.size.height);
        bgMusicPlayer.rate += 0.2;
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
        [bg runAction:[SKAction colorizeWithColor:bgColor colorBlendFactor:1 duration:0.3]];
        
        //levelBar.color = bgColor;
        //levelBar.colorBlendFactor = 0.7;
        [rainNode setParticleColorSequence:nil];
        [rainNode setParticleColor:bgColor];
        [rainNode setParticleColorBlendFactor:0.8];
        
    }
    if(levelBar.size.width >= (self.size.width*1.05)){
        [self gameOver];
    }
    //pause and unpause action
    if(!isPause){
        if(self.physicsWorld.speed < 1)
            self.physicsWorld.speed += 0.05;
    }
    else if(isPause){
        if(self.physicsWorld.speed > 0)
            self.physicsWorld.speed -= 0.05;
        else if (self.physicsWorld.speed <= 0)
            self.view.paused = YES;
    }
    //restrain paddle position within view
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
    SKEmitterNode *sparkNode = self.sparkEmitter[shape.type];
    sparkNode.position = shape.position;
    if (!sparkNode.parent){
        [self addChild:sparkNode];
    }
    [sparkNode resetSimulation];
    [self runAction:[SKAction runBlock:^{
        shape.position = CGPointMake(self.size.width*2, self.size.height);
    }]];
    //If paddle is hit
    if(contact.bodyA.categoryBitMask == paddleCategory){
        SKAction *moveBack = [SKAction moveBy:CGVectorMake(0, -10.0) duration:0.02];
        SKAction *moveForth = [SKAction moveBy:CGVectorMake(0, 10.0) duration:0.3];
        SKAction *wait = [SKAction waitForDuration:0.02];
        SKAction *paddleImpact = [SKAction sequence:@[moveBack, wait, moveForth]];
        [paddle runAction:paddleImpact];
        
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
            levelBar.size = CGSizeMake(levelBar.size.width + self.size.width*0.2, levelBar.size.height);
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"eat_sound.wav" waitForCompletion:NO]];
            SKAction *flash = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.05], [SKAction waitForDuration:0.05], [SKAction fadeInWithDuration:0.05]]];
            [paddle runAction:flash];
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
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"eat_sound.wav" waitForCompletion:NO]];
            
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
            levelBar.size = CGSizeMake(levelBar.size.width - self.size.width*0.3, levelBar.size.height);
            score += 1;
            
            NSString *matchingPath =
            [[NSBundle mainBundle]
             pathForResource:@"Matching" ofType:@"sks"];
            SKEmitterNode *matchingNode =
            [NSKeyedUnarchiver unarchiveObjectWithFile:matchingPath];
            [paddle addChild:matchingNode];
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
    
}

//Random shape and position of drops
-(void)randomShapeAndPosition{
    if(!isGameOver){
        int dropType = arc4random()%3;
        float dropPositionOffset = (float)((arc4random()%8 + 1)*0.1);
        Drops *drop;
        drop = dropArray[dropArrayIndex];
        if(drop.parent == self){
            drop.texture = [SKTexture textureWithImageNamed:[self chooseShape:dropType]];
            drop.type = dropType;
            drop.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height);
            drop.physicsBody.velocity = CGVectorMake(0, 0);
        }
        else
            [self addChild:drop];
        [drop runAction:[SKAction rotateByAngle:4*M_PI duration:2]];
        if (dropArrayIndex < 29) {
            dropArrayIndex++;
        }
        else dropArrayIndex = 0;
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
    [pauseBtn removeFromParent];
    if(self.view.paused)
        self.view.paused = NO;
    //shake screen animation
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
    for (int i = 0; i < children.count; i++) {
        if(([[children[i] name]  isEqual: @"gameOverText"])){
            gameOverTextCanBeAdded = NO;
            break;
        }
    }
    [paddle removeAllChildren];
    [paddle removeFromParent];
    
    if(gameOverTextCanBeAdded){
        //slide in game over board (gameovertext is old implementation and remain to keep function from calling multiple times
        [[myView layer] addAnimation:animation forKey:@"position"];
        [bgMusicPlayer pause];
        gameOverText = [[SKLabelNode alloc] init];
        gameOverText.text = [NSString stringWithFormat:@"GAMEOVER"];
        gameOverText.name = @"gameOverText";
        gameOverText.hidden = YES;
        gameOverText.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:gameOverText];
        //game over sound
        if(options.soundOn)
            [self runAction:[SKAction playSoundFileNamed:@"gameover_final.wav" waitForCompletion:NO]];
        //paddle explode
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
        
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1], [SKAction runBlock:^{
            //remove actions of drops
            for (int i = 0; i < children.count; i++) {
                SKNode *drop = children[i];
                if([drop isKindOfClass:[Drops class]]){
                    [drop removeAllActions];
                    drop.position = CGPointMake(self.size.width*2, self.size.height);
                }
            }
            
            GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
            SKTransition *reveal = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.5];
            [self.view presentScene:gameOverScene transition:reveal];
            
        }]]]];
    }
    gameOverTextCanBeAdded = NO;
}
//increment score after gameover
-(void)incrementScore:(int)limit label:(SKLabelNode*)label{
    __block int i = 0;
    [label runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        label.text = [NSString stringWithFormat:@"%d", i];
        i++;
    }],[SKAction waitForDuration:0.0000]]] count:limit+1]];
}
//retrieve high score from device
-(int)getHighscore{
    long highscore;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"highscore"] != nil){
        highscore = [defaults integerForKey:@"highscore"];
    } else highscore = 0;
    return (int)highscore;
}
-(int)getInstanceScore{
    return score;
}
//save high score to device
-(void)saveHighscore:(int)points{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(points) forKey:@"highscore"];
    [defaults synchronize];
}
+(int)getScore{
    return score;
}

//create colored background opening at the beginning
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
