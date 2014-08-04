//
//  OptionScene.m
//  GeometryCatch
//
//  Created by iosdev on 04/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "OptionScene.h"
#import "AboutScene.h"
#import "StartScene.h"
@implementation OptionScene
@synthesize backBtn,options, soundBtn, musicBtn,creditBtn,moveGroup;
-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        SKSpriteNode *bg = [[SKSpriteNode alloc]initWithImageNamed:@"option_bg"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [bg setScale:0.5];
        [self addChild:bg];
        
        options = [[Options alloc] init];
        
        soundBtn = [[SKSpriteNode alloc] initWithImageNamed:[self chooseConfigSprite:options.soundOn baseFileName:@"sfx"]];
        soundBtn.anchorPoint = CGPointMake(0, 0.5);
        soundBtn.name = @"soundBtn";
        [soundBtn setScale:0.5];
        soundBtn.position = CGPointMake(self.size.width*0.33, self.size.height*0.43);
        [self addChild:soundBtn];
        
        musicBtn = [[SKSpriteNode alloc] initWithImageNamed:[self chooseConfigSprite:options.musicOn baseFileName:@"music"]];
        musicBtn.anchorPoint = CGPointMake(0, 0.5);
        musicBtn.position = CGPointMake(self.size.width*0.22, self.size.height*0.63);
        musicBtn.name = @"musicBtn";
        [musicBtn setScale:0.5];
        [self addChild:musicBtn];
        
        creditBtn = [[SKSpriteNode alloc] initWithImageNamed:@"aboutus"];
        creditBtn.anchorPoint = CGPointMake(0, 0.5);
        creditBtn.position = CGPointMake(self.size.width * 0.23, self.size.height*0.22);
        creditBtn.name = @"creditBtn";
        [creditBtn setScale:0.5];
        [self addChild:creditBtn];
        
        backBtn = [[SKSpriteNode alloc] initWithImageNamed:@"optionbutton"];
        backBtn.position = CGPointMake(self.size.width*0.95, self.size.height*0.95);
        backBtn.name = @"backBtn";
        [backBtn setScale:0.5];
        [self addChild:backBtn];
        
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
        
        SKSpriteNode *startLbl = [[SKSpriteNode alloc] initWithImageNamed:@"start"];
        startLbl.position = CGPointMake(self.size.width/2, self.size.height * 0.45);
        [startLbl setScale:0.5];
        startLbl.name = @"startLbl";
        [self addChild:startLbl];
        [moveGroup addObject:startLbl];
        
        SKSpriteNode *titleLbl = [[SKSpriteNode alloc] initWithImageNamed:@"title"];
        titleLbl.position = CGPointMake(self.size.width/2, self.size.height*0.6);
        [titleLbl setScale:0.5];
        [self addChild:titleLbl];
        [moveGroup addObject:titleLbl];
        
        for (int i = 0; i < moveGroup.count; i++) {
            [moveGroup[i] runAction:[SKAction moveByX:-self.size.width y:0 duration:1]];
        }
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if ([node.name isEqualToString:@"creditBtn"]) {
            AboutScene *aboutScene = [[AboutScene alloc] initWithSize:self.size];
            SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
            [self.view presentScene:aboutScene transition:transition];
        }
        else if ([node.name isEqualToString:@"musicBtn"]){
            [options loadConfig];
            options.musicOn = !options.musicOn;
            musicBtn.texture = [SKTexture textureWithImageNamed:[self chooseConfigSprite:options.musicOn baseFileName:@"music"]];
            [options saveConfig];
            
        }
        else if ([node.name isEqualToString:@"soundBtn"]){
            [options loadConfig];
            options.soundOn = !options.soundOn;
            soundBtn.texture = [SKTexture textureWithImageNamed:[self chooseConfigSprite:options.soundOn baseFileName:@"sfx"]];
            [options saveConfig];
            
        }
        else if ([node.name isEqualToString:@"backBtn"]){
            SKAction *moveBack = [SKAction runBlock:^{
                for (int i = 0; i < moveGroup.count; i++) {
                    [moveGroup[i] runAction:[SKAction moveByX:self.size.width y:0 duration:1]];
                }
            }];
            SKAction *wait = [SKAction waitForDuration:1.0];
            SKAction *loadScene = [SKAction runBlock:^{
                StartScene *startScene = [[StartScene alloc] initWithSize:self.size];
                [self.view  presentScene:startScene];
            }];
            
            SKAction *moveBackAndLoadScene = [SKAction sequence:@[moveBack, wait, loadScene]];
            [self runAction:moveBackAndLoadScene];
        }
        
    }
}

-(NSString*)chooseConfigSprite:(BOOL)value baseFileName:(NSString*)baseFileName{
    NSString* state = [[NSString alloc] init];
    switch (value) {
        case YES:
            state = [NSString stringWithFormat:@"%@", baseFileName];
            break;
        case NO:
            state = [NSString stringWithFormat:@"%@_off", baseFileName];
            break;
        default:
            break;
    }
    return state;
}
@end
