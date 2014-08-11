//
//  TutScene.h
//  GeometryCatch
//
//  Created by iosdev on 11/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Drops.h"

@interface TutScene : SKScene <SKPhysicsContactDelegate>
@property SKSpriteNode *paddle;
@property float speedOffset;
@property NSMutableArray *paddleArray;
@property float paddleHoldShapeOffset;
@property int paddleArrayIndex;
@property SKColor *bgColor;
@property SKSpriteNode *levelBar;
//@property int level;
@property SKEmitterNode *rainNode;
@property NSMutableArray *sparkArrayPaddle;
@property NSMutableArray *sparkArrayWorld;
@property int sparkArrayIndex;
@property NSArray *bgColorArray;
//@property Drops *testShape;
@property SKSpriteNode *bg;
@property NSMutableArray *moveGroup;
@property int bgColorIndex;
@property BOOL firstStepOk;
@property BOOL secondStepOk;
@property BOOL canMovePaddle;
@property BOOL clickMoveOk;
@property BOOL dragMoveOk;
@property BOOL firstSuccessOk;
@property BOOL secondSuccessOk;
@property BOOL secondStepPhaseOneOk;
@property BOOL secondStepPhaseTwoOk;
@property BOOL canBurnEnergy;
@property BOOL partOneOk;
@property BOOL partTwoOk;
@property SKLabelNode *click;
@property SKLabelNode *drag;
@end
