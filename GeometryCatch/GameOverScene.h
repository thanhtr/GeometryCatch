//
//  GameOverScene.h
//  GeometryCatch
//
//  Created by iosdev on 06/09/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Options.h"
@interface GameOverScene : SKScene
@property SKSpriteNode *shareBtn;
@property SKSpriteNode *playBtn;
@property SKSpriteNode *gameCenterBtn;
@property SKSpriteNode* musicBtn;
@property SKSpriteNode* soundBtn;
@property SKSpriteNode *creditBtn;
@property SKSpriteNode *aboutBg;
@property SKSpriteNode *pauseBtn;
@property SKLabelNode *bestScoreLbl;
@property SKLabelNode *bestScorePoint;
@property SKLabelNode *yourScoreLbl;
@property SKLabelNode *yourScorePoint;
@property Options *options;
@property BOOL properlyInView;
@property NSString* lastButton;
@property AVAudioPlayer *bgMusicPlayer;
@property int score;
@property BOOL canHueHue;
@property BOOL canRevertColor;
@end
