//
//  StartScene.m
//  GeometryCatch
//
//  Created by iosdev on 03/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "StartScene.h"
#import "MyScene.h"
#import "SKEase.h"
#import "TutScene.h"
@implementation StartScene
@synthesize startLbl, titleLbl,menuBtn,options, soundBtn, musicBtn,creditBtn, moveGroup, isInOption, aboutBg, properlyInView, backgroundMusicPlayer,clickSoundPlayer;

-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        
        [self initColoredStartScreen];
        
        SKSpriteNode *bottomColoredLine = [[SKSpriteNode alloc] initWithImageNamed:@"bottom_screen_background"];
        if(IS_IPAD_SCREEN)
            bottomColoredLine.position = CGPointMake(self.size.width/2-0.5, self.size.height*0.01);
        else
            bottomColoredLine.position = CGPointMake(self.size.width/2 -0.25, self.size.height*0.01);

        if(IS_IPAD_SCREEN)
            [bottomColoredLine setScale:1.2];
        else
            [bottomColoredLine setScale:0.5];
        [self addChild:bottomColoredLine];
        
        startLbl = [[SKSpriteNode alloc] initWithImageNamed:@"start"];
        if(IS_568_SCREEN){
            startLbl.position = CGPointMake(self.size.width/2 -2, self.size.height * 0.45);
        }
        else if(IS_IPAD_SCREEN)
            startLbl.position = CGPointMake(self.size.width/2 -5, self.size.height * 0.45);
        else
            startLbl.position = CGPointMake(self.size.width/2 -2, self.size.height * 0.42);
        
        if(IS_IPAD_SCREEN)
            [startLbl setScale:1.2];
        else
            [startLbl setScale:0.5];
        
        startLbl.name = @"startLbl";
        [self addChild:startLbl];
        
        titleLbl = [[SKSpriteNode alloc] initWithImageNamed:@"title"];
        if(IS_IPAD_SCREEN)
            titleLbl.position = CGPointMake(self.size.width/2, self.size.height*0.65);
        else
            titleLbl.position = CGPointMake(self.size.width/2, self.size.height*0.6);
        
        if(IS_IPAD_SCREEN)
            [titleLbl setScale:1.2];
        else
            [titleLbl setScale:0.5];
        
        [self addChild:titleLbl];
        
        
        
        SKSpriteNode *bg = [[SKSpriteNode alloc]initWithImageNamed:@"option_bg"];
        
        if(IS_568_SCREEN){
            bg.position = CGPointMake(3*self.size.width/2, self.size.height/2);
        }
        else {
            bg.position = CGPointMake(3*self.size.width/2, self.size.height*0.48);
        }
        
        if(IS_IPAD_SCREEN){
            bg.xScale = 1.2;
            bg.yScale = 1.1;
        }
        else
            [bg setScale:0.5];
        
        [self addChild:bg];
        
        
        menuBtn = [[SKSpriteNode alloc] initWithImageNamed:@"optionbutton"];
        if(IS_568_SCREEN){
            menuBtn.position = CGPointMake(self.size.width*0.95, self.size.height*0.95);
        }
        else {
            menuBtn.position = CGPointMake(self.size.width*0.95, self.size.height*0.92);
        }
        
        menuBtn.name = @"menuBtn";
        
        if(IS_IPAD_SCREEN)
            [menuBtn setScale:1.2];
        else
            [menuBtn setScale:0.5];
        
        [self addChild:menuBtn];
        
        options = [[Options alloc] init];
        
        soundBtn = [[SKSpriteNode alloc] initWithImageNamed:[self chooseConfigSprite:options.soundOn baseFileName:@"sfx"]];
        soundBtn.anchorPoint = CGPointMake(0, 0.5);
        soundBtn.name = @"soundBtn";
        
        if(IS_IPAD_SCREEN)
            [soundBtn setScale:1.2];
        else
            [soundBtn setScale:0.5];
        
        if(IS_568_SCREEN){
            soundBtn.position = CGPointMake(self.size.width*1.11, self.size.height*0.43);
        }
        else {
            soundBtn.position = CGPointMake(self.size.width*1.11, self.size.height*0.4);
        }
        [self addChild:soundBtn];
        
        musicBtn = [[SKSpriteNode alloc] initWithImageNamed:[self chooseConfigSprite:options.musicOn baseFileName:@"music"]];
        musicBtn.anchorPoint = CGPointMake(0, 0.5);
        musicBtn.position = CGPointMake(self.size.width*1.22, self.size.height*0.63);
        musicBtn.name = @"musicBtn";
        if(IS_IPAD_SCREEN)
            [musicBtn setScale:1.2];
        else
            [musicBtn setScale:0.5];
        [self addChild:musicBtn];
        
        creditBtn = [[SKSpriteNode alloc] initWithImageNamed:@"aboutus"];
        creditBtn.anchorPoint = CGPointMake(0, 0.5);
        
        if(IS_568_SCREEN){
            creditBtn.position = CGPointMake(self.size.width * 1.05, self.size.height*0.22);
        }
        else if(IS_IPAD_SCREEN)
            creditBtn.position = CGPointMake(self.size.width * 1.05, self.size.height*0.14);
        else {
            creditBtn.position = CGPointMake(self.size.width * 1.05, self.size.height*0.15);
        }
        
        creditBtn.name = @"creditBtn";
        
        if(IS_IPAD_SCREEN)
            [creditBtn setScale:1.2];
        else
            [creditBtn setScale:0.5];
        [self addChild:creditBtn];
        
        aboutBg = [[SKSpriteNode alloc]initWithImageNamed:@"credit_screen"];
        aboutBg.name = @"aboutBg";
        aboutBg.hidden = YES;
        aboutBg.position = CGPointMake(5*self.size.width/2, self.size.height/2);
        if(IS_568_SCREEN){
            [aboutBg setScale:0.5];
        }
        else if(IS_IPAD_SCREEN){
            aboutBg.yScale = 1.0;
            aboutBg.xScale = 1.2;
        }
        else {
            aboutBg.yScale = 0.45;
            aboutBg.xScale = 0.5;
        }
        
        [self addChild:aboutBg];
        
        isInOption = NO;
        properlyInView = YES;
        
        //bg music
        NSError *error;
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Menu_Music" withExtension:@"wav"];
        backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        backgroundMusicPlayer.numberOfLoops = -1; //-1 = infinite loop
        [backgroundMusicPlayer prepareToPlay];
        if (options.musicOn) {
            [backgroundMusicPlayer play];
        }
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(properlyInView) {
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            SKNode *node = [self nodeAtPoint:location];
            if([node isKindOfClass:[SKSpriteNode class]]){
                if (options.soundOn) {
                    [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
                }
                
            }
            if([node.name isEqualToString:@"menuBtn"]){
                properlyInView = NO;
                int direction;
                if(!isInOption)
                    direction = -1;
                else direction = 1;
                menuBtn.position = CGPointMake(menuBtn.position.x - direction * self.size.width, menuBtn.position.y);
                for (int i =0; i< self.children.count; i++) {
                    SKNode *child = self.children[i];
                    
                    SKAction *move =[SKAction moveByX: direction * self.size.width y:0 duration:0.5];
                    move.timingMode = SKActionTimingEaseInEaseOut;
                    SKAction *elasticMove = [SKEase MoveToWithNode:self.children[i] EaseFunction:CurveTypeBack Mode:EaseOut Time:0.2 ToVector:CGVectorMake(child.position.x + direction * (self.size.width),child.position.y)];
                    [self.children[i] runAction:[SKAction sequence:@[elasticMove, [SKAction waitForDuration:0.2], [SKAction runBlock:^{
                        properlyInView = YES;
                    }]]]];
                }
                isInOption = !isInOption;
                
            }
            else if([node.name isEqualToString:@"startLbl"]){
//                MyScene *myScene = [[MyScene alloc]initWithSize:self.size];
//                [self.view presentScene:myScene];
                TutScene *tutScene = [[TutScene alloc]initWithSize:self.size];
                [self.view presentScene:tutScene];
            }
            
            else if ([node.name isEqualToString:@"creditBtn"]) {
                properlyInView = NO;
                aboutBg.hidden = NO;
                SKAction *moveLeft =[SKAction moveByX: (-self.size.width) y:0 duration:0.5];
                moveLeft.timingMode = SKActionTimingEaseInEaseOut;
                
                for (int i =0; i< self.children.count; i++) {
                    SKNode *child = self.children[i];
                    SKAction *elasticMove = [SKEase MoveToWithNode:self.children[i] EaseFunction:CurveTypeElastic Mode:EaseOut Time:0.2 ToVector:CGVectorMake(child.position.x -(self.size.width),child.position.y)];
                    //                [self.children[i] runAction:moveLeft];
                    [self.children[i] runAction:[SKAction sequence:@[elasticMove, [SKAction waitForDuration:0.2], [SKAction runBlock:^{
                        properlyInView = YES;
                    }]]]];
                }
            }
            else if ([node.name isEqualToString:@"musicBtn"]){
                [options loadConfig];
                options.musicOn = !options.musicOn;
                if (options.musicOn) {
                    [backgroundMusicPlayer play];
                } else [backgroundMusicPlayer pause];
                musicBtn.texture = [SKTexture textureWithImageNamed:[self chooseConfigSprite:options.musicOn baseFileName:@"music"]];
                [options saveConfig];
                
            }
            else if ([node.name isEqualToString:@"soundBtn"]){
                [options loadConfig];
                options.soundOn = !options.soundOn;
                soundBtn.texture = [SKTexture textureWithImageNamed:[self chooseConfigSprite:options.soundOn baseFileName:@"sfx"]];
                [options saveConfig];
            }
            else if ([node.name isEqualToString:@"aboutBg"]) {
                properlyInView = NO;
                aboutBg.hidden = YES;
                SKAction *moveRight =[SKAction moveByX: (self.size.width) y:0 duration:0.5];
                moveRight.timingMode = SKActionTimingEaseInEaseOut;
                for (int i =0; i< self.children.count; i++) {
                    SKNode *child = self.children[i];
                    SKAction *elasticMove = [SKEase MoveToWithNode:self.children[i] EaseFunction:CurveTypeElastic Mode:EaseOut Time:0.2 ToVector:CGVectorMake(child.position.x - (-self.size.width),child.position.y)];
                    [self.children[i] runAction:[SKAction sequence:@[elasticMove, [SKAction waitForDuration:0.2], [SKAction runBlock:^{
                        properlyInView = YES;
                    }]]]];
                    //                    [self.children[i] runAction:moveRight];
                }
            }
        }
    }
}

-(NSString*)chooseConfigSprite:(BOOL)value baseFileName:(NSString*)baseFileName{
    NSString* state = [[NSString alloc] init];
    if(value)
        state = [NSString stringWithFormat:@"%@", baseFileName];
    else
        state = [NSString stringWithFormat:@"%@_off", baseFileName];
    return state;
}

-(void)initColoredStartScreen{
    SKSpriteNode *column1 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)219/255 green:(float)68/255 blue:(float)83/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column1.position = CGPointMake(self.size.width/8 - column1.size.width/2, self.size.height/2);
    [self addChild:column1];
    
    SKSpriteNode *column2 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)233/255 green:(float)87/255 blue:(float)63/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column2.position = CGPointMake(2*self.size.width/8 - column2.size.width/2, self.size.height/2);
    [self addChild:column2];
    
    SKSpriteNode *column3 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)246/255 green:(float)187/255 blue:(float)66/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column3.position = CGPointMake(3*self.size.width/8 - column3.size.width/2, self.size.height/2);
    [self addChild:column3];
    
    
    SKSpriteNode *column4 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)140/255 green:(float)193/255 blue:(float)82/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column4.position = CGPointMake(4*self.size.width/8 - column4.size.width/2, self.size.height/2);
    [self addChild:column4];
    
    
    SKSpriteNode *column5 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)55/255 green:(float)188/255 blue:(float)155/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column5.position = CGPointMake(5*self.size.width/8 - column5.size.width/2, self.size.height/2);
    [self addChild:column5];
    
    SKSpriteNode *column6 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)59/255 green:(float)175/255 blue:(float)218/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column6.position = CGPointMake(6*self.size.width/8 - column6.size.width/2, self.size.height/2);
    [self addChild:column6];
    
    SKSpriteNode *column7 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)74/255 green:(float)137/255 blue:(float)220/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column7.position = CGPointMake(7*self.size.width/8 - column7.size.width/2, self.size.height/2);
    [self addChild:column7];
    
    SKSpriteNode *column8 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)67/255 green:(float)74/255 blue:(float)84/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
    column8.position = CGPointMake(8*self.size.width/8 - column8.size.width/2, self.size.height/2);
    [self addChild:column8];
    
}
@end
