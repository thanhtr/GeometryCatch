//
//  ViewController.m
//  GeometryCatch
//
//  Created by iosdev on 23/07/14.
//  Copyright (c) 2014 c63. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "StartScene.h"
#import "TutScene.h"
#import "GameOverScene.h"
#import "GADBannerView.h"

@interface ViewController()
@property (strong, nonatomic) IBOutlet GADBannerView  *bannerView;
@end

@implementation ViewController


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [StartScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
 
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)createPost:(NSNotification *)notification{
    NSDictionary *postData = [notification userInfo];
    NSString *postText = (NSString *)[postData objectForKey:@"postText"];
    UIImage *postPicture = (UIImage*)[postData objectForKey:@"postPicture"];
    // build your tweet, facebook, etc...
    SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [mySLComposerSheet setInitialText:postText];
    [mySLComposerSheet addImage:postPicture];
    [self presentViewController:mySLComposerSheet animated:YES completion:nil];
}

-(void)showBanner:(NSNotification *)notification{
    [self showBannerView];
}

-(void)hideBanner:(NSNotification *)notification{
    [self hideBannerView];
}

-(void)createAdmobAds
{
    mBannerType = BANNER_TYPE;
    
    if(mBannerType <= kBanner_Portrait_Bottom)
        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    else
        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    
    mBannerView.adUnitID = ADMOB_BANNER_UNIT_ID;
    
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    mBannerView.rootViewController = self;
    [self.view addSubview:mBannerView];
    //#ifdef DEBUG
    //    GADRequest *request = [GADRequest request];
    //    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    //#endif
    
    
    // Initiate a generic request to load it with an ad.
    [mBannerView loadRequest:[GADRequest request]];
    
    CGSize s = [[UIScreen mainScreen] bounds].size;
    
    CGRect frame = mBannerView.frame;
    
    off_x = 0.0f;
    on_x = 0.0f;
    
    switch (mBannerType)
    {
        case kBanner_Portrait_Top:
        {
            off_y = -frame.size.height;
            on_y = 0.0f;
        }
            break;
        case kBanner_Portrait_Bottom:
        {
            off_y = s.height;
            on_y = s.height-frame.size.height;
        }
            break;
        case kBanner_Landscape_Top:
        {
            off_y = -frame.size.height;
            on_y = 0.0f;
        }
            break;
        case kBanner_Landscape_Bottom:
        {
            off_y = s.height;
            on_y = s.height-frame.size.height;
        }
            break;
            
        default:
            break;
    }
    
    frame.origin.y = off_y;
    frame.origin.x = off_x;
    
    mBannerView.frame = frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    frame = mBannerView.frame;
    frame.origin.x = on_x;
    frame.origin.y = on_y;
    
    
    mBannerView.frame = frame;
    [UIView commitAnimations];
}


-(void)showBannerView
{
    if (mBannerView)
    {
        //banner on bottom
        {
            CGRect frame = mBannerView.frame;
            frame.origin.y = off_y;
            frame.origin.x = on_x;
            mBannerView.frame = frame;
            
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^
             {
                 CGRect frame = mBannerView.frame;
                 frame.origin.y = on_y;
                 frame.origin.x = on_x;
                 
                 mBannerView.frame = frame;
             }
                             completion:^(BOOL finished)
             {
             }];
        }
    }
    
}


-(void)hideBannerView
{
    if (mBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             CGRect frame = mBannerView.frame;
             frame.origin.y = off_y;
             frame.origin.x = off_x;
             mBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             
             
         }];
    }
}


-(void)dismissAdView
{
    if (mBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             CGSize s = [[UIScreen mainScreen] bounds].size;
             CGRect frame = mBannerView.frame;
             frame.origin.y = frame.origin.y + frame.size.height ;
             frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
             mBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [mBannerView setDelegate:nil];
             [mBannerView removeFromSuperview];
             mBannerView = nil;
             
         }];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createAdmobAds];
    [self hideBannerView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createPost:)
                                                 name:@"CreatePost"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBanner:)
                                                 name:@"showAds"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBanner:)
                                                 name:@"hideAds"
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self dismissAdView];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"createPost" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"showAds" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"hideAds" object:nil];
}



@end
