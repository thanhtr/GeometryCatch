//
//  Drops.h
//  GeometryCatch
//
//  Created by iosdev on 23/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Drops : SKSpriteNode
@property int type;
@property NSMutableArray *checkMatchArray;
-(id)init:(NSString*)name;
@end
