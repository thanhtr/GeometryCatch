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
#import <GameKit/GameKit.h>

@interface ViewController()<GKGameCenterControllerDelegate>
@property (strong, nonatomic) IBOutlet GADBannerView  *bannerView;
@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self authenticateLocalUser];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createAdmobAds];
    [self hideBannerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createPost:)
                                                 name:@"CreatePost"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getScore:)
                                                 name:@"GetScore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pause:)
                                                 name:@"Pause"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resume:)
                                                 name:@"Resume"
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
                                                    name:@"CreatePost" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"showAds" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"hideAds" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetScore" object:nil];
}

#pragma mark - Notification method
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

-(void)getScore:(NSNotification *)notification{
    NSDictionary *postData = [notification userInfo];
    NSNumber *number = (NSNumber *)[postData objectForKey:@"score"];
    if ([GKLocalPlayer localPlayer].authenticated){
        [self insertCurrentTimeIntoLeaderboard:@"ATOXScore1" withScore:[number intValue]];
        [self showLeaderboard:@"ATOXScore1"];
    } else{
        [self authenticateLocalUser];
        if ([GKLocalPlayer localPlayer].authenticated){
            [self insertCurrentTimeIntoLeaderboard:@"ATOXScore1" withScore:[number intValue]];
            [self showLeaderboard:@"ATOXScore1"];
        }
    }
}

-(void)pause:(NSNotification *)notification{
    SKView * skView = (SKView *)self.view;
    skView.paused = YES;
}

-(void)resume:(NSNotification *)notification{
    SKView * skView = (SKView *)self.view;
    skView.paused = NO;
}

-(void)showBanner:(NSNotification *)notification{
    [self showBannerView];
}

-(void)hideBanner:(NSNotification *)notification{
    [self hideBannerView];
}


#pragma mark - Admob method
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

#pragma mark - LeaderBoard method

- (void)authenticateLocalUser {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (!localPlayer.authenticated) {
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil) {
                [self presentViewController:viewController animated:YES completion:nil];
            } else if (error){
                NSLog(@"%@",[error localizedDescription]);
            } 
        };
    }
}

- (void)showLeaderboard:(NSString *)leaderboard
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardIdentifier=leaderboard;
        [self presentViewController:gameCenterController animated:YES completion:nil];
    }
}

- (void)insertCurrentTimeIntoLeaderboard:(NSString*)leaderboard withScore:(int64_t)mScore
{
    //    NSDate *today = [NSDate date];
    GKScore * submitScore = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboard];
    submitScore.value = mScore;
    [GKScore reportScores:@[submitScore] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
}

#pragma mark - Game Center Delegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
