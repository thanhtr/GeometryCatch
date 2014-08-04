//
//  Options.m
//  GeometryCatch
//
//  Created by iosdev on 04/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "Options.h"

@implementation Options
-(id)init{
    self = [super init];
    [self loadConfig];
    return self;
}

-(void)loadConfig{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"sound"] != nil){
        self.soundOn = [defaults boolForKey:@"sound"];
    } else self.soundOn = YES;
    if([defaults objectForKey:@"music"] != nil){
        self.musicOn = [defaults boolForKey:@"music"];
    } else self.musicOn = YES;
}

-(void)saveConfig{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.soundOn) forKey:@"sound"];
    [defaults setObject:@(self.musicOn) forKey:@"music"];
    [defaults synchronize];
}
@end
