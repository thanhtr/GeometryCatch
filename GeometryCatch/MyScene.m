//
//  MyScene.m
//  GeometryCatch
//
//  Created by iosdev on 23/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
@synthesize paddle,speedOffset,paddleArray,paddleHoldShapeOffset, paddleArrayIndex, bgColor, level, levelBar, score, scoreLabel, isGameOver;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //First init
        paddleHoldShapeOffset = 0.8;
        paddleArrayIndex = 0;
        level = 1;
        score = 0;
        isGameOver = NO;
        speedOffset = 0.1;
        paddleArray = [[NSMutableArray alloc] initWithCapacity:3];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        bgColor = [SKColor colorWithRed:(float)251/255 green:(float)174/255 blue:(float)23/255 alpha:1.0];
        self.backgroundColor = bgColor;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
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
        
        [self dropShape];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!isGameOver){
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            [paddle runAction:[SKAction moveToX:location.x duration:speedOffset]];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!isGameOver){
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            paddle.position = CGPointMake(location.x, paddle.position.y);
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //Level bar reduce over time
    levelBar.size = CGSizeMake(levelBar.size.width - 0.5, levelBar.size.height);
    
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    // if level bar > screen next level, if level bar < 0 gameover
    if(levelBar.size.width == self.size.width){
        levelBar.size = CGSizeMake(self.size.width*0.2, levelBar.size.height);
        level++;
        speedOffset = speedOffset/1.5;
    }
    if(levelBar.size.width <= 0){
        [self gameOver];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKSpriteNode * takenShape;
    Drops *shape = (Drops*)contact.bodyB.node;
    [shape removeFromParent];
    [paddleArray addObject:[NSNumber numberWithInt:shape.type]];
    if(paddleArrayIndex >= 1 && [paddleArray[paddleArrayIndex-1] integerValue] != shape.type && paddleArray[paddleArrayIndex-1] != nil){
        [paddleArray removeAllObjects];
        paddleArrayIndex = 0;
        [paddle removeAllChildren];
        paddleHoldShapeOffset = 0.8;
        levelBar.size = CGSizeMake(levelBar.size.width - self.size.width*0.2, levelBar.size.height);
    }
    else if(paddleArrayIndex != 2){
        takenShape = [SKSpriteNode spriteNodeWithImageNamed:[self chooseShape:shape.type]];
        [paddle addChild:takenShape];
        takenShape.position = CGPointMake(paddle.size.width*(0.2-paddleHoldShapeOffset), 0);
        takenShape.color = bgColor;
        takenShape.colorBlendFactor = 1;
        paddleArrayIndex += 1;
        paddleHoldShapeOffset -= 0.6;
    }
    else{
        [paddleArray removeAllObjects];
        paddleArrayIndex = 0;
        [paddle removeAllChildren];
        paddleHoldShapeOffset = 0.6;
        levelBar.size = CGSizeMake(levelBar.size.width + self.size.width*0.3, levelBar.size.height);
        score += 100;
    }
    
    if(paddleHoldShapeOffset < -0.4){
        paddleHoldShapeOffset = 0.8;
    }
}

-(void)randomShapeAndPosition{
    if(!isGameOver){
        int dropType = arc4random()%3;
        float dropPositionOffset = (float)((arc4random()%8 + 1)*0.1);
        Drops *drop = [[Drops alloc] init:[self chooseShape:dropType]];
        drop.type = dropType;
        drop.position = CGPointMake(self.size.width * dropPositionOffset, self.size.height);
        [drop runAction:[SKAction moveToY:-100 duration:10*speedOffset]];
        [self addChild:drop];
        [drop runAction:[SKAction rotateByAngle:M_PI duration:1]];
        NSLog(@"%f", dropPositionOffset);
    }
}


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

-(void)dropShape{
    SKAction *dropRandom = [SKAction runBlock:^{
        [self randomShapeAndPosition];
    }];
    SKAction *delay = [SKAction waitForDuration:0.5];
    SKAction *dropAndDelay = [SKAction sequence:@[dropRandom, delay]];
    SKAction *dropAndDelayForever = [SKAction repeatActionForever:dropAndDelay];
    [self runAction:dropAndDelayForever withKey:@"dropShape"];
}

-(void)gameOver{
    isGameOver = YES;
    NSArray *children = self.children;
    NSMutableArray *shapesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < children.count; i++) {
        if([children[i] isKindOfClass:[Drops class]]){
            [shapesArray addObject:children[i]];
        }
    }
    for (int i = 0; i<shapesArray.count; i++) {
        [shapesArray[i] removeAllActions];
    }
    
    SKLabelNode *gameOverText = [[SKLabelNode alloc] init];
    gameOverText.text = [NSString stringWithFormat:@"GAMEOVER"];
    gameOverText.position = CGPointMake(self.size.width/2, self.size.height/2);
    gameOverText.color = [SKColor redColor];
    gameOverText.colorBlendFactor = 1;
    [self addChild:gameOverText];
    [self removeActionForKey:@"dropShape"];
}
@end
