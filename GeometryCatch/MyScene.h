//
//  MyScene.h
//  GeometryCatch
//

//  Copyright (c) 2014 c63. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "Drops.h"
#import "Options.h"
#import <AVFoundation/AVFoundation.h>

static UInt32 worldCategory = 1 << 1;
static UInt32 paddleCategory = 1 << 2;
static UInt32 dropCategory = 1 << 3;


@interface MyScene : SKScene <SKPhysicsContactDelegate>
@property SKSpriteNode *paddle;
@property float speedOffset;
@property NSMutableArray *paddleArray;
@property float paddleHoldShapeOffset;
@property int paddleArrayIndex;
@property SKColor *bgColor;
@property SKSpriteNode *levelBar;
//@property int level;
@property int score;
@property SKLabelNode *scoreLabel;
@property BOOL isGameOver;
@property BOOL gameOverTextCanBeAdded;
@property SKLabelNode *gameOverText;
@property SKLabelNode *levelLabel;
@property SKEmitterNode *rainNode;
@property int sparkArrayIndex;
@property NSArray *bgColorArray;
//@property Drops *testShape;
@property SKSpriteNode *bg;
@property SKSpriteNode *bgBlack;
@property BOOL isPause;
@property NSMutableArray *moveGroup;
@property int bgColorIndex;
@property SKSpriteNode *gameOverBg;
@property SKLabelNode *bestScoreLbl;
@property SKLabelNode *bestScorePoint;
@property SKLabelNode *yourScoreLbl;
@property SKLabelNode *yourScorePoint;
@property SKSpriteNode *shareBtn;
@property SKSpriteNode *playBtn;
@property NSMutableArray *gameOverGroup;
@property SKSpriteNode *gameCenterBtn;
@property Options *options;
@property SKSpriteNode *pauseBtn;
@property AVAudioPlayer *bgMusicPlayer;
@property AVAudioPlayer *gameOverMusicPlayer;
@end
