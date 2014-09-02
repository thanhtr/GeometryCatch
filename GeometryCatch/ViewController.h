//
//  ViewController.h
//  GeometryCatch
//

//  Copyright (c) 2014 c63. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ViewController : UIViewController
@property UIImage *screenShot;
-(void)createPost:(NSNotification *)notification;
-(void)takeScreenShot;
@end
