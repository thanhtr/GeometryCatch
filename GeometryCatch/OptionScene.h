//
//  OptionScene.h
//  GeometryCatch
//
//  Created by iosdev on 04/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Options.h"
@interface OptionScene : SKScene
@property SKSpriteNode* backBtn;
@property SKSpriteNode* musicBtn;
@property SKSpriteNode* soundBtn;
@property SKSpriteNode *creditBtn;
@property Options* options;
@property NSMutableArray *moveGroup;
@end
