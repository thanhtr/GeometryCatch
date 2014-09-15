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
@implementation StartScene{
    BOOL firstTime;
}
@synthesize startLbl, titleLbl,options, moveGroup, backgroundMusicPlayer;

-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"firstTime"] != nil){
            firstTime = [defaults boolForKey:@"firstTime"];
        } else firstTime = YES;
        options = [[Options alloc] init];
        //create colored columns
        [self initColoredStartScreen];
        //bottom line
        SKSpriteNode *bottomColoredLine = [[SKSpriteNode alloc] initWithImageNamed:@"bottom_screen_background"];
        if(IS_IPAD_SCREEN)
        {
            bottomColoredLine.position = CGPointMake(self.size.width/2-0.5, self.size.height*0.01);
            [bottomColoredLine setScale:1.2];
        }
        else
        {
            bottomColoredLine.position = CGPointMake(self.size.width/2 -0.25, self.size.height*0.01);
            [bottomColoredLine setScale:0.5];

        }
        [self addChild:bottomColoredLine];
        
        //start button
        startLbl = [[SKSpriteNode alloc] initWithImageNamed:@"start"];
        if(IS_568_SCREEN){
            startLbl.position = CGPointMake(self.size.width/2 -2, self.size.height * 0.45);
            [startLbl setScale:0.5];

        }
        else if(IS_IPAD_SCREEN){
            startLbl.position = CGPointMake(self.size.width/2 -5, self.size.height * 0.45);
        [startLbl setScale:1.2];
        }
        else
        {
            startLbl.position = CGPointMake(self.size.width/2 -2, self.size.height * 0.42);
            [startLbl setScale:0.5];
        }
        startLbl.name = @"startLbl";
        [self addChild:startLbl];
        
        //game title label
        titleLbl = [[SKSpriteNode alloc] initWithImageNamed:@"title"];
        if(IS_IPAD_SCREEN)
        {
            titleLbl.position = CGPointMake(self.size.width/2, self.size.height*0.65);
            [titleLbl setScale:1.2];
        }
        else
        {
            titleLbl.position = CGPointMake(self.size.width/2, self.size.height*0.6);
            [titleLbl setScale:0.5];
        }
        [self addChild:titleLbl];

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
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            SKNode *node = [self nodeAtPoint:location];
            //if press start start scene
            if([node.name isEqualToString: @"startLbl"]){
                if (options.soundOn) {
                    [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
                    
                }
                if (firstTime) {
                    TutScene *tutScene = [[TutScene alloc]initWithSize:self.size];
                    [self.view presentScene:tutScene];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@(NO) forKey:@"firstTime"];

                }
                else {
                    MyScene *myScene = [[MyScene alloc]initWithSize:self.size];
                    [self.view presentScene:myScene];
                }
          
            }
        }
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
