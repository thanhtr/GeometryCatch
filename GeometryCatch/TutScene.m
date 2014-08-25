//
//  TutScene.m
//  GeometryCatch
//
//  Created by iosdev on 11/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "TutScene.h"
#import "MyScene.h"
#import "StartScene.h"
@implementation TutScene
@synthesize paddle, speedOffset, paddleArray, paddleArrayIndex, paddleHoldShapeOffset, bgColor, levelBar, rainNode, bgColorArray, bgColorIndex, bg ,moveGroup, firstStepOk, secondStepOk, canMovePaddle, clickMoveOk, dragMoveOk, click, drag, firstSuccessOk, canBurnEnergy, secondStepPhaseOneOk, secondStepPhaseTwoOk, partOneOk, partTwoOk, secondSuccessOk, options,bgMusicPlayer;
-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
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
        if(IS_IPAD_SCREEN)
            speedOffset = -4;
        else
            speedOffset = -2;
        paddleArray = [[NSMutableArray alloc] initWithCapacity:3];
        self.physicsWorld.gravity = CGVectorMake(0, speedOffset);
        self.physicsWorld.contactDelegate = self;
        //        self.backgroundColor = bgColor;
        bg = [[SKSpriteNode alloc] initWithImageNamed:@"bg"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        bg.color = bgColor;
        bg.colorBlendFactor = 1;
        if(IS_IPAD_SCREEN)
            [bg setScale:1.2];
        [self addChild:bg];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 1.1)];
        self.physicsBody.categoryBitMask = worldCategory;
        self.physicsBody.collisionBitMask = paddleCategory;
        
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
        
        levelBar = [[SKSpriteNode alloc]initWithImageNamed:@"levelBar"];
        levelBar.anchorPoint = CGPointMake(0, 0.5);
        levelBar.position = CGPointMake(0, self.size.height);
        levelBar.size = CGSizeMake(self.size.width*0.5, levelBar.size.height);
        //        levelBar.yScale = 2.0;
        levelBar.color = bgColor;
        levelBar.colorBlendFactor = 0.7;
        if(IS_IPAD_SCREEN)
            [levelBar setScale:1.5];
        [self addChild:levelBar];
        
        
        paddle = [[SKSpriteNode alloc] initWithImageNamed:@"paddle"];
        [paddle setScale:0.2];
        if(IS_568_SCREEN)
            paddle.position = CGPointMake(self.size.width /2, self.size.height*0.15);
        else
            paddle.position = CGPointMake(self.size.width /2, self.size.height*0.18);
        if(IS_IPAD_SCREEN)
            [paddle setScale:0.5];
        else
            [paddle setScale:0.2];
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
        
        [self initColoredBackground];
        
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
                [moveGroup[i] runAction:[SKAction colorizeWithColor:[SKColor clearColor] colorBlendFactor:1 duration:0.0]];
            }
        }
        firstStepOk = NO;
        SKLabelNode *welcomeTextFirstLine = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        welcomeTextFirstLine.position = CGPointMake(self.size.width/2, self.size.height*0.53);
        if(IS_IPAD_SCREEN)
            welcomeTextFirstLine.fontSize = 60;
        else
            welcomeTextFirstLine.fontSize = 25;
        
        welcomeTextFirstLine.text = @"WELCOME";
        welcomeTextFirstLine.alpha = 0;
        [self addChild:welcomeTextFirstLine];
        [welcomeTextFirstLine runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0], [SKAction runBlock:^{
            firstStepOk = YES;
        }]]]];
        
        SKLabelNode *welcomeTextSecondLine = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        welcomeTextSecondLine.position = CGPointMake(self.size.width/2, self.size.height*0.48);
        if(IS_IPAD_SCREEN)
            welcomeTextSecondLine.fontSize = 60;
        else
            welcomeTextSecondLine.fontSize = 25;
        welcomeTextSecondLine.text = @"TO THE FIRST TUTORIAL";
        welcomeTextSecondLine.alpha = 0;
        [self addChild:welcomeTextSecondLine];
        [welcomeTextSecondLine runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0]]]];
        
        clickMoveOk = NO;
        dragMoveOk = NO;
        firstStepOk = NO;
        secondStepOk = NO;
        firstSuccessOk = NO;
        secondSuccessOk = NO;
        secondStepPhaseTwoOk = NO;
        secondStepPhaseOneOk = NO;
        partOneOk = NO;
        partTwoOk = NO;
        
        NSError *error;
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"ingame1" withExtension:@"mp3"];
        bgMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        bgMusicPlayer.numberOfLoops = -1; //-1 = infinite loop
        [bgMusicPlayer prepareToPlay];
        if(options.musicOn)
            [bgMusicPlayer play];
    }
    return self;
}

-(void)firstStep{
    SKLabelNode *firstLine = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    firstLine.position = CGPointMake(self.size.width/2, self.size.height*0.53);
    if(IS_IPAD_SCREEN)
        firstLine.fontSize = 60;
    else
        firstLine.fontSize = 25;
    firstLine.text = @"OR";
    firstLine.alpha = 0;
    [self addChild:firstLine];
    [firstLine runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0]]]];
    
    click = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    click.position = CGPointMake(self.size.width*0.33, self.size.height*0.53);
    if(IS_IPAD_SCREEN)
        click.fontSize = 60;
    else
        click.fontSize = 25;
    click.text = @"TOUCH";
    click.alpha = 0;
    [self addChild:click];
    [click runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeAlphaTo:0.3 duration:1.0]]]];
    
    drag = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    drag.position = CGPointMake(self.size.width*0.65, self.size.height*0.53);
    if(IS_IPAD_SCREEN)
        drag.fontSize = 60;
    else
        drag.fontSize = 25;
    drag.text = @"HOLD";
    drag.alpha = 0;
    [self addChild:drag];
    [drag runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeAlphaTo:0.3 duration:1.0]]]];
    
    SKLabelNode *secondLine = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    secondLine.position = CGPointMake(self.size.width/2, self.size.height*0.48);
    if(IS_IPAD_SCREEN)
        secondLine.fontSize = 60;
    else
        secondLine.fontSize = 25;
    secondLine.text = @"TO MOVE THE PADDLE";
    secondLine.alpha = 0;
    [self addChild:secondLine];
    [secondLine runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0], [SKAction runBlock:^{
        canMovePaddle = YES;
    }]]]];
    firstStepOk = NO;
}

-(void)firstSuccess{
    SKLabelNode *congratText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    congratText.position = CGPointMake(self.size.width/2, self.size.height/2);
    if(IS_IPAD_SCREEN)
        congratText.fontSize = 60;
    else
        congratText.fontSize = 25;
    congratText.text = @"SUCCESS";
    congratText.alpha = 0;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5], [SKAction runBlock:^{
        [click removeFromParent];
        [drag removeFromParent];
        [self addChild:congratText];
        
    }]]]];
    SKAction *flash = [SKAction repeatAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.05], [SKAction waitForDuration:0.05], [SKAction fadeInWithDuration:0.05]]] count:4];
    [congratText runAction:[SKAction sequence:@[flash,[SKAction waitForDuration:1.5], [SKAction fadeOutWithDuration:0.5], [SKAction runBlock:^{
        secondStepPhaseOneOk = YES;
    }]]]];
    firstSuccessOk = NO;
}

-(void)secondStepPhaseOne{
    SKLabelNode *firstLineText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    firstLineText.position = CGPointMake(self.size.width/2, self.size.height*0.53);
    if(IS_IPAD_SCREEN)
        firstLineText.fontSize = 60;
    else
        firstLineText.fontSize = 25;
    firstLineText.text = @"THE ENERGY BAR";
    firstLineText.alpha = 0;
    [self addChild:firstLineText];
    [firstLineText runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0]]]];
    
    SKLabelNode *secondLineText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    secondLineText.position = CGPointMake(self.size.width/2, self.size.height*0.48);
    if(IS_IPAD_SCREEN)
        secondLineText.fontSize = 60;
    else
        secondLineText.fontSize = 25;
    secondLineText.text = @"WILL GRADUALLY DECREASE";
    secondLineText.alpha = 0;
    [self addChild:secondLineText];
    [secondLineText runAction:[SKAction sequence:@[[SKAction runBlock:^{
        canBurnEnergy = YES;
    }],[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0],[SKAction runBlock:^{
        secondStepPhaseTwoOk = YES;
    }]]]];
    secondStepPhaseOneOk = NO;
    
}

-(void)secondStepPhaseTwo{
    SKLabelNode *firstLineText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    firstLineText.position = CGPointMake(self.size.width/2, self.size.height*0.53);
    if(IS_IPAD_SCREEN)
        firstLineText.fontSize = 60;
    else
        firstLineText.fontSize = 25;
    firstLineText.text = @"COLLECT 3 SAME SHAPE";
    firstLineText.alpha = 0;
    [self addChild:firstLineText];
    [firstLineText runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0]]]];
    
    SKLabelNode *secondLineText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    secondLineText.position = CGPointMake(self.size.width/2, self.size.height*0.48);
    if(IS_IPAD_SCREEN)
        secondLineText.fontSize = 60;
    else
        secondLineText.fontSize = 25;
    secondLineText.text = @"TO SCORE AND FILL ENERGY";
    secondLineText.alpha = 0;
    [self addChild:secondLineText];
    [secondLineText runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0], [SKAction runBlock:^{
        [self dropShape];
    }]]]];
    secondStepPhaseTwoOk = NO;
    
}
-(void)secondSuccess{
    SKLabelNode *congratText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    congratText.position = CGPointMake(self.size.width/2, self.size.height/2);
    if(IS_IPAD_SCREEN)
        congratText.fontSize = 60;
    else
        congratText.fontSize = 25;
    congratText.text = @"SUCCESS";
    congratText.alpha = 0;
    
    [self addChild:congratText];
    SKAction *flash = [SKAction repeatAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.05], [SKAction waitForDuration:0.05], [SKAction fadeInWithDuration:0.05]]] count:4];
    [self removeAllActions];
    if(options.soundOn)
        [self runAction:[SKAction playSoundFileNamed:@"success.wav" waitForCompletion:NO]];
    for (int i = 0; i < self.children.count; i++) {
        if([self.children[i] isKindOfClass:[Drops class]]){
            [self.children[i] removeFromParent];
        }
    }
    [congratText runAction:[SKAction sequence:@[[SKAction runBlock:^{
        
    }],flash,[SKAction waitForDuration:1.5], [SKAction fadeOutWithDuration:0.5], [SKAction runBlock:^{
        partTwoOk = YES;
        
    }]]]];
    secondSuccessOk = NO;
}

-(void)finalWordsPhaseOne{
    SKLabelNode *firstLineText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    firstLineText.position = CGPointMake(self.size.width/2, self.size.height*0.53);
    if(IS_IPAD_SCREEN)
        firstLineText.fontSize = 60;
    else
        firstLineText.fontSize = 25;
    firstLineText.text = @"BEWARE! FAIL TO MATCH";
    firstLineText.alpha = 0;
    [self addChild:firstLineText];
    [firstLineText runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0]]]];
    
    SKLabelNode *secondLineText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    secondLineText.position = CGPointMake(self.size.width/2, self.size.height*0.48);
    if(IS_IPAD_SCREEN)
        secondLineText.fontSize = 60;
    else
        secondLineText.fontSize = 25;
    secondLineText.text = @"COSTS YOU MORE ENERGY";
    secondLineText.alpha = 0;
    [self addChild:secondLineText];
    [secondLineText runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0],[SKAction runBlock:^{
        [self finalWordsPhaseTwo];
    }]]]];
    partTwoOk = NO;
}

-(void)finalWordsPhaseTwo{
    SKLabelNode *firstLineText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    firstLineText.position = CGPointMake(self.size.width/2, self.size.height*0.53);
    if(IS_IPAD_SCREEN)
        firstLineText.fontSize = 60;
    else
        firstLineText.fontSize = 25;
    firstLineText.text = @"YOU ARE READY";
    firstLineText.alpha = 0;
    [self addChild:firstLineText];
    [firstLineText runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0]]]];
    
    SKLabelNode *secondLineText = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
    secondLineText.position = CGPointMake(self.size.width/2, self.size.height*0.48);
    if(IS_IPAD_SCREEN)
        secondLineText.fontSize = 60;
    else
        secondLineText.fontSize = 25;
    secondLineText.text = @"GOOD LUCK!!";
    secondLineText.alpha = 0;
    [self addChild:secondLineText];
    [secondLineText runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction fadeInWithDuration:1.0], [SKAction waitForDuration:2.0], [SKAction fadeOutWithDuration:1.0],[SKAction runBlock:^{
        for (int i = 0; i< moveGroup.count; i++) {
            if(i < bgColorIndex){
                SKAction *slide = [SKAction moveByX:self.size.width y:0 duration:1];
                slide.timingMode = SKActionTimingEaseInEaseOut;
                [moveGroup[i] runAction:slide];
            }
            else if (i > bgColorIndex){
                SKAction *slide = [SKAction moveByX:-self.size.width y:0 duration:1];
                slide.timingMode = SKActionTimingEaseInEaseOut;
                [moveGroup[i] runAction:slide];
            }
        }
        
    }], [SKAction waitForDuration:1.0], [SKAction runBlock:^{
        for (int i = 0; i< moveGroup.count; i++) {
            if (i == bgColorIndex){
                [moveGroup[i] runAction:[SKAction colorizeWithColor:bgColor colorBlendFactor:1 duration:0.0]];
            }
        }
    }], [SKAction waitForDuration:0.5], [SKAction runBlock:^{
        MyScene *myScene = [[MyScene alloc] initWithSize:self.size];
        [self.view presentScene:myScene];
    }]]]];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if(canMovePaddle){
            //Move paddle
            [paddle runAction:[SKAction moveToX:location.x duration:0.1]];
            clickMoveOk = YES;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if(canMovePaddle){
            paddle.position = CGPointMake(location.x, paddle.position.y);
            dragMoveOk = YES;
        }
    }
}

-(void)update:(NSTimeInterval)currentTime{
    if(paddle.position.x < paddle.size.width/2){
        paddle.position = CGPointMake(paddle.size.width/2, paddle.position.y);
    }
    else if (paddle.position.x > self.size.width -paddle.size.width/2){
        paddle.position = CGPointMake(self.size.width -paddle.size.width/2, paddle.position.y);
    }
    
    if(firstStepOk)
        [self firstStep];
    if (clickMoveOk) {
        [click runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
    }
    if (dragMoveOk) {
        [drag runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
    }
    if(dragMoveOk && clickMoveOk && !partOneOk) {
        firstSuccessOk = YES;
        clickMoveOk = NO;
        dragMoveOk = NO;
        partOneOk = YES;
        
    }
    if (firstSuccessOk) {
        [self firstSuccess];
    }
    
    if (canBurnEnergy) {
        levelBar.size = CGSizeMake(levelBar.size.width - 0.05, levelBar.size.height);
    }
    
    if(secondStepPhaseOneOk){
        [self secondStepPhaseOne];
    }
    if (secondStepPhaseTwoOk) {
        [self secondStepPhaseTwo];
    }
    if(secondSuccessOk){
        [self secondSuccess];
    }
    if (partTwoOk) {
        [self finalWordsPhaseOne];
    }
    if(levelBar.size.width <=0)
        levelBar.size = CGSizeMake(self.size.width*0.5, levelBar.size.height);
    
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
        [self addChild:sparkNode];
        
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
            levelBar.size = CGSizeMake(levelBar.size.width + self.size.width*0.3, levelBar.size.height);
            NSString *matchingPath =
            [[NSBundle mainBundle]
             pathForResource:@"Matching" ofType:@"sks"];
            SKEmitterNode *matchingNode =
            [NSKeyedUnarchiver unarchiveObjectWithFile:matchingPath];
            [paddle addChild:matchingNode];
            secondSuccessOk = YES;
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
        [self addChild:sparkNode];
        [shape removeFromParent];
    }
    
}

//Random shape and position of drops
-(void)randomShapeAndPosition{
    int dropType = arc4random()%3;
    float dropPositionOffset = (float)((arc4random()%8 + 1)*0.1);
    Drops *drop = [[Drops alloc] init:[self chooseShape:dropType]];
    drop.type = dropType;
    drop.name = @"drop";
    if(IS_IPAD_SCREEN)
        [drop setScale:0.8];
    drop.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height);
    //        [drop runAction:[SKAction moveToY:-10 duration:(drop.position.y - self.size.width)*speedOffset]];
    [self addChild:drop];
    [drop runAction:[SKAction rotateByAngle:4*M_PI duration:2]];
    
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
