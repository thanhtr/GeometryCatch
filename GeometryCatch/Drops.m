//
//  Drops.m
//  GeometryCatch
//
//  Created by iosdev on 23/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "Drops.h"
#import "MyScene.h"
@implementation Drops
-(id)init:(NSString *)name{
    self = [super initWithImageNamed:name];
    self.type = 0;
    self.checkMatchArray = [[NSMutableArray alloc] initWithCapacity:3];
    [self setScale:0.35];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height/2];
    self.physicsBody.dynamic = true;
    self.physicsBody.categoryBitMask = dropCategory;
    self.physicsBody.contactTestBitMask = paddleCategory | worldCategory;
    return self;
}
@end
