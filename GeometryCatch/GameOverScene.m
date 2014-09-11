//
//  GameOverScene.m
//  GeometryCatch
//
//  Created by iosdev on 06/09/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "GameOverScene.h"
#import "StartScene.h"
#import "SKEase.h"
#import "MyScene.h"

@implementation GameOverScene
@synthesize shareBtn,creditBtn,playBtn,soundBtn,gameCenterBtn,bestScorePoint,bestScoreLbl,aboutBg,pauseBtn,yourScoreLbl,yourScorePoint,musicBtn, options, properlyInView, lastButton, bgMusicPlayer,score;
-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        self.backgroundColor = [SKColor whiteColor];
        options = [[Options alloc] init];
        properlyInView = YES;
        score = [MyScene getScore];
        //bg music
        NSError *error;
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Menu_Music" withExtension:@"wav"];
        bgMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        bgMusicPlayer.numberOfLoops = -1; //-1 = infinite loop
        bgMusicPlayer.enableRate = YES;
        [bgMusicPlayer prepareToPlay];
        if(options.musicOn)
            [bgMusicPlayer play];
        
        //shadow of "best score"
        SKLabelNode *bestScoreLblShadow = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            bestScoreLblShadow.position = CGPointMake(self.size.width/2, self.size.height*0.55  -3);
        else
            bestScoreLblShadow.position = CGPointMake(self.size.width/2, self.size.height*0.58  -3);
        
        bestScoreLblShadow.text = @"Best score";
        bestScoreLblShadow.fontColor = [SKColor colorWithRed:(float)74/255 green:(float)137/255 blue:(float)220/255 alpha:1.0];
        bestScoreLblShadow.fontSize = 67.5;
        if(IS_IPAD_SCREEN)
            [bestScoreLblShadow setScale:1.2];
        else
            [bestScoreLblShadow setScale:0.5];
        
        [self addChild:bestScoreLblShadow];
        
        //"best score"
        bestScoreLbl = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            bestScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.55 );
        else
            bestScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.58 );
        
        bestScoreLbl.text = @"Best score";
        bestScoreLbl.fontColor = [SKColor blackColor];
        bestScoreLbl.fontSize = 67.5;
        if (IS_IPAD_SCREEN) {
            [bestScoreLbl setScale:1.2];
        }
        else
            [bestScoreLbl setScale:0.5];
        [self addChild:bestScoreLbl];
        
        //best score (points)
        bestScorePoint = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            
            bestScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.48 );
        else
            bestScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.5 );
        
        bestScorePoint.fontColor = [SKColor colorWithRed:(float)74/255 green:(float)137/255 blue:(float)220/255 alpha:1.0];
        bestScorePoint.fontSize = 67.5;
        if (IS_IPAD_SCREEN) {
            [bestScorePoint setScale:1.2];
        }
        else
            [bestScorePoint setScale:0.5];
        [self addChild:bestScorePoint];
        
        //"your score" shadow
        SKLabelNode *yourScoreLblShadow = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            yourScoreLblShadow.position = CGPointMake(self.size.width/2, self.size.height*0.7  -3);
        else
            yourScoreLblShadow.position = CGPointMake(self.size.width/2, self.size.height*0.75  -3);
        
        yourScoreLblShadow.text = @"Your score";
        yourScoreLblShadow.fontColor = [SKColor colorWithRed:(float)219/255 green:(float)68/255 blue:(float)83/255 alpha:1.0];
        yourScoreLblShadow.fontSize = 90;
        if (IS_IPAD_SCREEN) {
            [yourScoreLblShadow setScale:1.2];
        }
        else
            [yourScoreLblShadow setScale:0.5];
        [self addChild:yourScoreLblShadow];
        
        //"your score"
        yourScoreLbl = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            yourScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.7 );
        else
            yourScoreLbl.position = CGPointMake(self.size.width/2, self.size.height*0.75 );
        
        yourScoreLbl.text = @"Your score";
        yourScoreLbl.fontColor = [SKColor blackColor];
        yourScoreLbl.fontSize = 90;
        if (IS_IPAD_SCREEN) {
            [yourScoreLbl setScale:1.2];
        }
        else
            [yourScoreLbl setScale:0.5];
        [self addChild:yourScoreLbl];
        
        //current score (points)
        yourScorePoint = [[SKLabelNode alloc] initWithFontNamed:@"SquareFont"];
        if(IS_568_SCREEN)
            yourScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.62 );
        else
            yourScorePoint.position = CGPointMake(self.size.width/2, self.size.height*0.65 );
        
        yourScorePoint.fontColor = [SKColor colorWithRed:(float)219/255 green:(float)68/255 blue:(float)83/255 alpha:1.0];
        yourScorePoint.fontSize = 90;
        if (IS_IPAD_SCREEN) {
            [yourScorePoint setScale:1.2];
        }
        else
            [yourScorePoint setScale:0.5];
        [self addChild:yourScorePoint];
        
        //share button
        shareBtn = [[SKSpriteNode alloc] initWithImageNamed:@"share_normal"];
        if(IS_568_SCREEN)
            shareBtn.position = CGPointMake(self.size.width/2, self.size.height*0.38 );
        else
            shareBtn.position = CGPointMake(self.size.width/2, self.size.height*0.415 );
        if (IS_IPAD_SCREEN) {
            [shareBtn setScale:1.2];
        }
        else
            [shareBtn setScale:0.5];
        shareBtn.name = @"shareBtn";
        [self addChild:shareBtn];
        
        //play button
        playBtn  = [[SKSpriteNode alloc] initWithImageNamed:@"play_normal"];
        if(IS_568_SCREEN)
            playBtn.position = CGPointMake(self.size.width/2, self.size.height*0.24 );
        else
            playBtn.position = CGPointMake(self.size.width/2, self.size.height*0.25 );
        if (IS_IPAD_SCREEN) {
            playBtn.xScale = 1.2;
            playBtn.yScale = 1;
        }
        else
            [playBtn setScale:0.5];
        playBtn.name = @"playBtn";
        [self addChild:playBtn];
        
        //game center button
        gameCenterBtn = [[SKSpriteNode alloc] initWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"gamecenter_button" hasPrefix:NO]];
        gameCenterBtn.anchorPoint = CGPointMake(0.5, 1);
        if (IS_IPAD_SCREEN) {
            [gameCenterBtn setScale:1.2];
            gameCenterBtn.position = CGPointMake(self.size.width*0.3, self.size.height );
        }
        else {
            [gameCenterBtn setScale:0.5];
            gameCenterBtn.position = CGPointMake(self.size.width*0.3, self.size.height );
        }
        gameCenterBtn.name = @"gameCenterBtn";
        [self addChild:gameCenterBtn];
        
        //sound button
        soundBtn = [[SKSpriteNode alloc] initWithImageNamed:[self chooseSpriteWithState:options.soundOn isTouched:NO baseFileName:@"sound_button" hasPrefix:YES]];
        soundBtn.anchorPoint = CGPointMake(0.5, 1);
        soundBtn.name = @"soundBtn";
        if(IS_IPAD_SCREEN){
            [soundBtn setScale:1.2];
            soundBtn.position = CGPointMake(self.size.width*0.75, self.size.height );
        }
        else {
            [soundBtn setScale:0.5];
            soundBtn.position = CGPointMake(self.size.width*0.75, self.size.height);
        }
        [self addChild:soundBtn];
        
        //music button
        musicBtn = [[SKSpriteNode alloc] initWithImageNamed:[self chooseSpriteWithState:options.musicOn isTouched:NO baseFileName:@"music_button" hasPrefix:YES]];
        musicBtn.anchorPoint = CGPointMake(0.5, 1);
        musicBtn.name = @"musicBtn";
        if(IS_IPAD_SCREEN){
            [musicBtn setScale:1.2];
            musicBtn.position = CGPointMake(self.size.width*0.9, self.size.height);
        }
        else{
            [musicBtn setScale:0.5];
            musicBtn.position = CGPointMake(self.size.width*0.9, self.size.height);
        }
        [self addChild:musicBtn];
        
        //credit button
        creditBtn = [[SKSpriteNode alloc] initWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"credit_button" hasPrefix:NO]];
        creditBtn.anchorPoint = CGPointMake(0.5, 1);
        if(IS_IPAD_SCREEN){
            creditBtn.position = CGPointMake(self.size.width * 0.1, self.size.height );
            [creditBtn setScale:1.2];
        }
        else {
            creditBtn.position = CGPointMake(self.size.width * 0.1, self.size.height );
            [creditBtn setScale:0.5];
        }
        creditBtn.name = @"creditBtn";
        [self addChild:creditBtn];
        
        //credit board
        if(IS_IPAD_SCREEN)
            aboutBg = [[SKSpriteNode alloc]initWithImageNamed:@"credit_ipad"];
        else
            aboutBg = [[SKSpriteNode alloc]initWithImageNamed:@"credit"];
        aboutBg.name = @"aboutBg";
        aboutBg.position = CGPointMake(3*self.size.width/2, self.size.height/2);
        aboutBg.zPosition = 1;
        if(IS_568_SCREEN){
            [aboutBg setScale:0.5];
        }
        else if(IS_IPAD_SCREEN){
            [aboutBg setScale:0.5];
        }
        else {
            aboutBg.yScale = 0.45;
            aboutBg.xScale = 0.5;
        }
        [self addChild:aboutBg];
        
        //run auto increment score func
        [self incrementScore:score label:yourScorePoint];
        [self getHighscore];
        if([self getHighscore] > score)
            bestScorePoint.text = [NSString stringWithFormat:@"%d", [self getHighscore]];
        else {
            bestScorePoint.text = [NSString stringWithFormat:@"%d", score];
            [self saveHighscore:score];
        }

    }
    return self;
}

//func to choose sprites for buttons
-(NSString*)chooseSpriteWithState:(BOOL)isOn isTouched:(BOOL)isTouched baseFileName:(NSString*)baseFileName hasPrefix:(BOOL)hasPrefix{
    NSString* final = [[NSString alloc] init];
    if(hasPrefix){
        if(isOn)
            if (isTouched) {
                final = [NSString stringWithFormat:@"%@_touched", baseFileName];
            }
            else {
                final = [NSString stringWithFormat:@"%@_normal", baseFileName];
            }
            else {
                if (isTouched) {
                    final = [NSString stringWithFormat:@"muted_%@_touched",baseFileName];
                }
                else {
                    final = [NSString stringWithFormat:@"muted_%@_normal", baseFileName];
                }
            }
    }
    else {
        if (isTouched) {
            final = [NSString stringWithFormat:@"%@_touched", baseFileName];
        }
        else {
            final = [NSString stringWithFormat:@"%@_normal", baseFileName];
        }
    }
    return final;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        lastButton = node.name;
        //press play: play sound + change sprite
        if([node.name isEqualToString:@"playBtn"]){
            playBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:YES baseFileName:@"play" hasPrefix:NO]];
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
            
        }
        //press share: play sound + change sprite
        else if([node.name isEqualToString:@"shareBtn"]){
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
            shareBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:YES baseFileName:@"share" hasPrefix:NO]];
        }
        //press game center: play sound + change sprite
        else if([node.name isEqualToString: @"gameCenterBtn"]){
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
            gameCenterBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:YES baseFileName:@"gamecenter_button" hasPrefix:NO]];
            
        }
        //press sound: play sound + change sprite
        else if ([node.name isEqualToString:@"soundBtn"]){
            soundBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:options.soundOn isTouched:YES baseFileName:@"sound_button" hasPrefix:YES]];
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
            
        }
        //press music: play sound + change sprite
        else if ([node.name isEqualToString:@"musicBtn"]){
            musicBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:options.musicOn isTouched:YES baseFileName:@"music_button" hasPrefix:YES]];
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
        }
        //press credit: play sound + change sprite
        else if([node.name isEqualToString:@"creditBtn"]){
            creditBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:YES baseFileName:@"credit_button" hasPrefix:NO]];
            if(options.soundOn)
                [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
            
        }
        //press creditboard: play sound + move back to original position
        else if([node.name isEqualToString:@"aboutBg"]){
            if(properlyInView){
                if(options.soundOn)
                    [self runAction:[SKAction playSoundFileNamed:@"click_proccess.wav" waitForCompletion:NO]];
                properlyInView = NO;
                SKAction *elasticMove = [SKEase MoveToWithNode:aboutBg EaseFunction:CurveTypeBack Mode:EaseOut Time:0.2 ToVector:CGVectorMake(3*self.size.width/2,aboutBg.position.y)];
                SKAction *move =[SKAction moveByX: self.size.width y:0 duration:0.5];
                move.timingMode = SKActionTimingEaseInEaseOut;
                [aboutBg runAction:[SKAction sequence:@[elasticMove, [SKAction waitForDuration:0.2], [SKAction runBlock:^{
                    properlyInView = YES;
                }]]]];
            }
        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //Position paddle to touch position
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        //check if the last button pressed to activate correct reaction
        if([node.name isEqualToString:lastButton]){
            //release sound: change sprite and turn on/off sound
            if ([node.name isEqualToString:@"soundBtn"]){
                [options loadConfig];
                options.soundOn = !options.soundOn;
                soundBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:options.soundOn isTouched:NO baseFileName:@"sound_button" hasPrefix:YES]];
                [options saveConfig];
            }
            //release game center: load game center
            //not yet implemented
            else if ([node.name isEqualToString:@"gameCenterBtn"]){
                gameCenterBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"gamecenter_button" hasPrefix:NO]];
                
            }
            //release music: change sprite and turn on/off music
            else if ([node.name isEqualToString:@"musicBtn"]){
                [options loadConfig];
                options.musicOn = !options.musicOn;
                if (options.musicOn) {
                    [bgMusicPlayer play];
                } else [bgMusicPlayer pause];
                musicBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:options.musicOn isTouched:NO baseFileName:@"music_button" hasPrefix:YES]];
                [options saveConfig];
            }
            //release share: change sprite and pop up share window with predefined status
            else if([node.name isEqualToString:@"shareBtn"]){
                shareBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"share" hasPrefix:NO]];
                NSString *postText = [NSString stringWithFormat: @"I just got %d points in a ATOX run. How about you?", score];
                UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
                [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
                UIImage *postPicture = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:@[postText, postPicture] forKeys:@[@"postText", @"postPicture"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatePost" object:self userInfo:userInfo];
            }
            //release play: change sprite and reset game
            else if([node.name isEqualToString:@"playBtn"]){
                MyScene *myScene = [[MyScene alloc]initWithSize:self.size];
                SKTransition *reveal = [SKTransition moveInWithDirection:SKTransitionDirectionDown duration:0.5];
                [self.view presentScene:myScene transition:reveal];
            }
            //release credit: change sprite and slide credit board in
            else if([node.name isEqualToString:@"creditBtn"]){
                if(properlyInView){
                    creditBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"credit_button" hasPrefix:NO]];
                    
                    properlyInView = NO;
                    SKAction *elasticMove = [SKEase MoveToWithNode:aboutBg EaseFunction:CurveTypeBack Mode:EaseOut Time:0.2 ToVector:CGVectorMake(self.size.width/2,aboutBg.position.y)];
                    SKAction *move =[SKAction moveByX: -self.size.width y:0 duration:0.5];
                    move.timingMode = SKActionTimingEaseInEaseOut;
                    [aboutBg runAction:[SKAction sequence:@[elasticMove, [SKAction waitForDuration:0.2], [SKAction runBlock:^{
                        properlyInView = YES;
                    }]]]];
                }
            }
        }
        //release outside button sprite border: change sprite
        else {
            soundBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:options.soundOn isTouched:NO baseFileName:@"sound_button" hasPrefix:YES]];
            musicBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:options.musicOn isTouched:NO baseFileName:@"music_button" hasPrefix:YES]];
            shareBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"share" hasPrefix:NO]];
            playBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"play" hasPrefix:NO]];
            creditBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"credit_button" hasPrefix:NO]];
            gameCenterBtn.texture = [SKTexture textureWithImageNamed:[self chooseSpriteWithState:NO isTouched:NO baseFileName:@"gamecenter_button" hasPrefix:NO]];
        }
    }
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
    int highscore;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"highscore"] != nil){
        highscore = [defaults integerForKey:@"highscore"];
    } else highscore = 0;
    return highscore;
}
//save high score to device
-(void)saveHighscore:(int)points{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(points) forKey:@"highscore"];
    [defaults synchronize];
}


@end
