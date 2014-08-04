//
//  Options.h
//  GeometryCatch
//
//  Created by iosdev on 04/08/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Options : NSObject
@property BOOL musicOn;
@property BOOL soundOn;
-(id)init;
-(void)loadConfig;
-(void)saveConfig;
@end
