//
//  MyScene.h
//  GeometryCatch
//

//  Copyright (c) 2014 c63. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Drops.h"
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
@property int level;
@property int score;
@property SKLabelNode *scoreLabel;
@property BOOL isGameOver;
@property BOOL gameOverTextCanBeAdded;
@property SKLabelNode *gameOverText;
@property SKLabelNode *levelLabel;
@end
