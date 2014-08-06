//
//  StartScene.h
//  GeometryCatch
//
//  Created by iosdev on 03/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Options.h"

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
@end
