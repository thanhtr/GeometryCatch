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
static int score;

@interface MyScene : SKScene <SKPhysicsContactDelegate>
@property SKSpriteNode *paddle;
@property SKSpriteNode *levelBar;
@property SKSpriteNode *bg;
@property SKSpriteNode *bgBlack;
@property SKSpriteNode *gameOverBg;
@property SKSpriteNode *shareBtn;
@property SKSpriteNode *playBtn;
@property SKSpriteNode *gameCenterBtn;
@property SKSpriteNode* musicBtn;
@property SKSpriteNode* soundBtn;
@property SKSpriteNode *creditBtn;
@property SKSpriteNode *aboutBg;
@property SKSpriteNode *pauseBtn;
@property SKSpriteNode *multiplierAnnouncer;
@property SKLabelNode *gameOverText;
@property SKLabelNode *bestScoreLbl;
@property SKLabelNode *bestScorePoint;
@property SKLabelNode *yourScoreLbl;
@property SKLabelNode *scoreLabel;
@property SKLabelNode *yourScorePoint;
@property SKLabelNode *comboAnnouncer;
@property SKEmitterNode *rainNode;
@property NSArray *bgColorArray;
@property NSMutableArray *paddleArray;
@property NSMutableArray *moveGroup;
@property NSMutableArray *gameOverGroup;
@property NSMutableArray *trailingSpriteArray;
@property NSMutableArray *dropArray;
@property AVAudioPlayer *bgMusicPlayer;
@property NSString* lastButton;
@property float timeSinceUpdated;
@property float speedOffset;
@property float paddleHoldShapeOffset;
@property int paddleArrayIndex;
@property int sparkArrayIndex;
@property int bgColorIndex;
@property int trailingSpriteArrayIndex;
@property int dropArrayIndex;
@property int level;
@property int combo;
@property BOOL isGameOver;
@property BOOL gameOverTextCanBeAdded;
@property BOOL isPause;
@property BOOL properlyInView;
@property BOOL isDoubleScore;
@property SKColor *bgColor;
@property Options *options;
+(int)getScore;
@end
