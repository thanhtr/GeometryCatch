//
//  StartScene.h
//  GeometryCatch
//
//  Created by iosdev on 03/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Options.h"

#define IS_568_SCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)

@interface StartScene : SKScene
@property SKSpriteNode *startLbl;
@property SKSpriteNode *titleLbl;
@property SKSpriteNode *menuBtn;
@property SKSpriteNode* musicBtn;
@property SKSpriteNode* soundBtn;
@property SKSpriteNode *creditBtn;
@property Options* options;
@property NSMutableArray *moveGroup;
@property BOOL isInOption;
@property SKSpriteNode* aboutBg;
@property BOOL properlyInView;
@property AVAudioPlayer *backgroundMusicPlayer;
@property AVAudioPlayer *clickSoundPlayer;
@end
