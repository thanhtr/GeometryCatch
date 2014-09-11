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
#define ADMOB_BANNER_UNIT_ID  @"ca-app-pub-4664323223854218/7145917089";

#import "GADBannerView.h"
typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
    kBanner_Landscape_Top,
    kBanner_Landscape_Bottom,
}CocosBannerType;

#define BANNER_TYPE kBanner_Portrait_Bottom

@interface ViewController : UIViewController
{
    CocosBannerType mBannerType;
    GADBannerView *mBannerView;
    float on_x, on_y, off_x, off_y;
}

-(void)createPost:(NSNotification *)notification;
-(void)showBanner:(NSNotification *)notification;
-(void)hideBanner:(NSNotification *)notification;
-(void)hideBannerView;
-(void)showBannerView;

@end
