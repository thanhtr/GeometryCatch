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

//define screen size constant
#define IS_568_SCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)

#define IS_IPAD_SCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)1024) < DBL_EPSILON)
static BOOL canLoadColoredColumn = YES;

@interface StartScene : SKScene
@property SKSpriteNode *startLbl;
@property SKSpriteNode *titleLbl;
@property Options* options;
@property NSMutableArray *moveGroup;
@property AVAudioPlayer *backgroundMusicPlayer;
@end
