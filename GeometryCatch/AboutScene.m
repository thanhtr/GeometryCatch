//
//  AboutScene.m
//  GeometryCatch
//
//  Created by iosdev on 03/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "AboutScene.h"

@implementation AboutScene
-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        SKSpriteNode *aboutBg = [[SKSpriteNode alloc]initWithImageNamed:@"credit_screen"];
        aboutBg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [aboutBg setScale:0.5];
        [self addChild:aboutBg];
    }
    return self;
}
@end
