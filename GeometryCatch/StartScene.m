//
//  StartScene.m
//  GeometryCatch
//
//  Created by iosdev on 03/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "StartScene.h"
#import "OptionScene.h"
#import "MyScene.h"

@implementation StartScene
@synthesize startLbl, titleLbl,menuBtn;

-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){        
        SKSpriteNode *column1 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)219/255 green:(float)68/255 blue:(float)83/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
        column1.position = CGPointMake(self.size.width/8 - column1.size.width/2, self.size.height/2);
        [self addChild:column1];
        
        SKSpriteNode *column2 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)233/255 green:(float)87/255 blue:(float)63/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
        column2.position = CGPointMake(2*self.size.width/8 - column2.size.width/2, self.size.height/2);
        [self addChild:column2];
        
        SKSpriteNode *column3 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)246/255 green:(float)187/255 blue:(float)66/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
        column3.position = CGPointMake(3*self.size.width/8 - column3.size.width/2, self.size.height/2);
        [self addChild:column3];
        
        
        SKSpriteNode *column4 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)140/255 green:(float)193/255 blue:(float)82/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
        column4.position = CGPointMake(4*self.size.width/8 - column4.size.width/2, self.size.height/2);
        [self addChild:column4];
        
        
        SKSpriteNode *column5 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)55/255 green:(float)188/255 blue:(float)155/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
        column5.position = CGPointMake(5*self.size.width/8 - column5.size.width/2, self.size.height/2);
        [self addChild:column5];
        
        SKSpriteNode *column6 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)59/255 green:(float)175/255 blue:(float)218/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
        column6.position = CGPointMake(6*self.size.width/8 - column6.size.width/2, self.size.height/2);
        [self addChild:column6];
        
        SKSpriteNode *column7 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)74/255 green:(float)137/255 blue:(float)220/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
        column7.position = CGPointMake(7*self.size.width/8 - column7.size.width/2, self.size.height/2);
        [self addChild:column7];
        
        SKSpriteNode *column8 = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:(float)67/255 green:(float)74/255 blue:(float)84/255 alpha:1.0] size:CGSizeMake(self.size.width/8, self.size.height)];
        column8.position = CGPointMake(8*self.size.width/8 - column8.size.width/2, self.size.height/2);
        [self addChild:column8];
        

        startLbl = [[SKSpriteNode alloc] initWithImageNamed:@"start"];
        startLbl.position = CGPointMake(self.size.width/2, self.size.height * 0.45);
        [startLbl setScale:0.5];
        startLbl.name = @"startLbl";
        [self addChild:startLbl];
        
        titleLbl = [[SKSpriteNode alloc] initWithImageNamed:@"title"];
        titleLbl.position = CGPointMake(self.size.width/2, self.size.height*0.6);
        [titleLbl setScale:0.5];
        [self addChild:titleLbl];
        
        menuBtn = [[SKSpriteNode alloc] initWithImageNamed:@"optionbutton"];
        menuBtn.position = CGPointMake(self.size.width*0.95, self.size.height*0.95);
        menuBtn.name = @"menuBtn";
        [menuBtn setScale:0.5];
        [self addChild:menuBtn];
        
           }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if([node.name isEqualToString:@"menuBtn"]){
            OptionScene *optionScene = [[OptionScene alloc] initWithSize:self.size];
//            SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:1];
            [self.view presentScene:optionScene];
        }
        else if([node.name isEqualToString:@"startLbl"]){
            MyScene *myScene = [[MyScene alloc]initWithSize:self.size];
            [self.view presentScene:myScene];
        }
    }

}

-(void)drawBg{

}
@end
