//
//  GameNCOIC.m
//  GameIdeaProto
//
//  Created by Mike Weinberg on 7/4/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import "GameNCOIC.h"





//#warning "Enter your credentials"
#define kPayPalClientId @"AQMLJhA6S1oGFm4_2t2PldklerePKCzQDuYU6R8M-l9TMQeEw4Ea3S9SzU8z"
#define kPayPalReceiverEmail @"mweinberg@weinbergsoftware.com"





@implementation GameNCOIC



- (id)init {
    if (self = [super init]) {
        
        
        
    }
    return self;
}




- (void)WS_showBannerAd {
    [UIView beginAnimations:@"BannerSlide" context:nil];
    AdMobBannerView.frame = CGRectMake((self.view.frame.size.width / 2) - (AdMobBannerView.frame.size.width /2),
                                  self.view.frame.size.height -
                                  AdMobBannerView.frame.size.height,
                                  AdMobBannerView.frame.size.width,
                                  AdMobBannerView.frame.size.height);
    [UIView commitAnimations];
    
    
    
    
    if ([[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) {
        
        NSLog(@"Yes");
        
        [UIView beginAnimations:@"BannerSlide" context:nil];
        DuringGameplayAdMobBannerView.frame = CGRectMake(0.0 - DuringGameplayAdMobBannerView.frame.size.width,
                                                         self.view.frame.size.height -
                                                         DuringGameplayAdMobBannerView.frame.size.height,
                                                         DuringGameplayAdMobBannerView.frame.size.width,
                                                         DuringGameplayAdMobBannerView.frame.size.height);
        [UIView commitAnimations];
        
        
    }
}





- (void)WS_hideBannerAd {
    
    GameplayActive = TRUE;
    
    
    [UIView beginAnimations:@"BannerSlide" context:nil];
    AdMobBannerView.frame = CGRectMake((self.view.frame.size.width / 2) - (AdMobBannerView.frame.size.width /2),
                                       self.view.frame.size.height +
                                       AdMobBannerView.frame.size.height,
                                       AdMobBannerView.frame.size.width,
                                       AdMobBannerView.frame.size.height);;
    [UIView commitAnimations];
    
    
    
    
    if ([[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) {
        
        [MyGamePlayView displayingAd: TRUE];
        
        [UIView beginAnimations:@"BannerSlide" context:nil];
        DuringGameplayAdMobBannerView.frame = CGRectMake(0.0,
                                                         self.view.frame.size.height -
                                                         DuringGameplayAdMobBannerView.frame.size.height,
                                                         DuringGameplayAdMobBannerView.frame.size.width,
                                                         DuringGameplayAdMobBannerView.frame.size.height);
        [UIView commitAnimations];
        
        
    }
    
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.acceptCreditCards = YES;
    self.environment = PayPalEnvironmentProduction;
    
    // TODO: Switch Paypal Environment and quickly test before releasing
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalPaymentViewController libraryVersion]);
    
    
    
    
    
    
    
    // Load AdMob Shit
    
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    
    
    
    if ([[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) { // load for iPad
        
        AdMobBannerView = [[GADBannerView alloc] initWithAdSize: kGADAdSizeLeaderboard];     // 728x90 Tablet Banner
        AdMobBannerView.adUnitID = @"ca-app-pub-5878740139610828/7210321992";
        
        
        
        
        DuringGameplayAdMobBannerView = [[GADBannerView alloc] initWithAdSize: kGADAdSizeBanner];   // This bannerView uses the same adUnitID as the iPod
        DuringGameplayAdMobBannerView.adUnitID = @"ca-app-pub-5878740139610828/1523715196";
        
        DuringGameplayAdMobBannerView.rootViewController = self;
        DuringGameplayAdMobBannerView.frame = CGRectMake(0.0 - DuringGameplayAdMobBannerView.frame.size.width,
                                           self.view.frame.size.height -
                                           DuringGameplayAdMobBannerView.frame.size.height,
                                           DuringGameplayAdMobBannerView.frame.size.width,
                                           DuringGameplayAdMobBannerView.frame.size.height);
        
        [self.view addSubview: DuringGameplayAdMobBannerView];
        
        
        // Initiate a generic request to load it with an ad.
        
        DuringGameplayAdMobBannerView.delegate = self;
        
        GADRequest* request = [GADRequest request];
        //request.testDevices = [NSArray arrayWithObjects:@"ca72d3d9feef8e6f02e29189ef1ef3b8", GAD_SIMULATOR_ID, nil];
        
        [DuringGameplayAdMobBannerView loadRequest: request];
        
    }
    else { // Load for iPod/iPhone
        
        AdMobBannerView = [[GADBannerView alloc] initWithAdSize: kGADAdSizeBanner];         // 320x50 iPod Standard
        AdMobBannerView.adUnitID = @"ca-app-pub-5878740139610828/1523715196";
        
    }
    
    
    
    
    
    
    AdMobBannerView.rootViewController = self;
    
    AdMobBannerView.frame = CGRectMake((self.view.frame.size.width / 2) - (AdMobBannerView.frame.size.width /2),
               self.view.frame.size.height +
               AdMobBannerView.frame.size.height,
               AdMobBannerView.frame.size.width,
               AdMobBannerView.frame.size.height);
    
    [self.view addSubview: AdMobBannerView];
    
    
    // Initiate a generic request to load it with an ad.
    
    AdMobBannerView.delegate = self;
    
    GADRequest* request = [GADRequest request];
    //request.testDevices = [NSArray arrayWithObjects:@"ca72d3d9feef8e6f02e29189ef1ef3b8", GAD_SIMULATOR_ID, nil];
    
    [AdMobBannerView loadRequest: request];
    
    
}





- (NSString *)saveFilePath {
	NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"savefile"];
}




- (void)saveData {
    // SaveDataDictionary
    
    [SaveDataDictionary writeToFile: [self saveFilePath] atomically: TRUE];
    
}






- (void)beginGame {
    
    
    
    // Load Save File
    
    NSString* SaveFilePath = [self saveFilePath];
    
    SaveDataDictionary = [[NSMutableDictionary dictionary] retain];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: SaveFilePath];
    
    if (fileExists) {
        [SaveDataDictionary release];
        SaveDataDictionary = [[NSMutableDictionary dictionaryWithContentsOfFile: SaveFilePath] retain];
    }
    
    
    
    
    
    // Load Level Data
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource: @"leveldata" ofType:@""];
    LevelList = [[NSArray arrayWithContentsOfFile: filePath] retain];
    
    
    
    levelStartCount = 0;
    
    [MyGameMenu setHidden: FALSE];
    [MyGamePlayView setHidden: TRUE];
    
    
    
    [MyGameMenu beginGameWithNCOIC: self];
    [MyGamePlayView setNCOIC: self];
    
    
    
}



- (int)numberOfLevels {
    return [LevelList count];
}



- (void)launchTutorial {
    
    [self WS_hideBannerAd];
    
    
    
    [MyGameMenu setHidden: TRUE];
    [MyGamePlayView setHidden: FALSE];
    
    [MyGamePlayView beginTutorial];
}






- (int)difficultyForLevel:(int)level {
    
    if (level > (int)[LevelList count]) return 0;
    
    NSDictionary* levelData = [LevelList objectAtIndex: (level - 1)];
    return [[levelData objectForKey: LevelDictionary_LevelDifficulty] intValue];
}



- (int)moveCountHighScoreForLevel:(int)level {
    
    if (level > (int)[LevelList count]) return 0;
    
    
    int returnValue = 0;
    
    
    if ([self levelCompleted: level]) {
        
        NSString* levelUID = [[LevelList objectAtIndex: (level - 1)] objectForKey: LevelDictionary_LevelUID];
    
        returnValue = [[SaveDataDictionary objectForKey: levelUID] intValue];
        
    }
    
    return returnValue;
}



- (BOOL)levelCompleted:(int)level {
    
    if (level > (int)[LevelList count]) return 0;
    
    NSString* levelUID = [[LevelList objectAtIndex: (level - 1)] objectForKey: LevelDictionary_LevelUID];
    return [[SaveDataDictionary allKeys] containsObject: levelUID];
}






- (void)re_establishUnlockedLevels {
    if (!Incomplete_UnlockedLevels) Incomplete_UnlockedLevels = [[NSMutableArray array] retain];
    [Incomplete_UnlockedLevels removeAllObjects];
    
    int repeatCount = 1;
    int levelCount = [self numberOfLevels] + 1;
    while (levelCount > repeatCount) {
        if (![self levelCompleted: repeatCount] && [Incomplete_UnlockedLevels count] < 10) [Incomplete_UnlockedLevels addObject: [NSNumber numberWithInt: repeatCount]];
        repeatCount++;
    }
    
}




- (BOOL)levelUnlocked:(int)level {
    
    if (!Incomplete_UnlockedLevels) [self re_establishUnlockedLevels];
    
    if ([self levelCompleted: level]) return TRUE;                                              // Return TRUE if the level was completed
    return [Incomplete_UnlockedLevels containsObject: [NSNumber numberWithInt: level]];         // If the level is listed in Incomplete_UnlockedLevels array, return TRUE
}








- (NSDictionary*)retreiveDictionaryForLevel:(int)levelNum {
    NSDictionary* levelData = [[LevelList objectAtIndex: (levelNum - 1)] objectForKey: LevelDictionary_LevelData];
    return levelData;
}






- (void)saveDataForLevel:(int)level moveCountHighScore:(int)highscore {
    
    NSString* levelUID = [[LevelList objectAtIndex: (level - 1)] objectForKey: LevelDictionary_LevelUID];
    
    
    [SaveDataDictionary setObject: [NSNumber numberWithInt: highscore] forKey: levelUID];
    
    
    [self saveData];
    
    
    [self re_establishUnlockedLevels];
    
    [MyGameMenu levelPageObjectsNeedUpdating];
    
    [MyGameMenu setNeedsDisplay];
}




- (BOOL)loadLevel:(int)level {
    
    GameplayActive = TRUE;
    
    [self WS_hideBannerAd];
    
    
    
    int AdFrequency = WS_AdvertisementFrequency;
    
    
    if (level > [self numberOfLevels]) {
        [MyGameMenu setHidden: FALSE];
        [MyGamePlayView setHidden: TRUE];
        
        GameplayActive = FALSE;
        
        [self WS_showBannerAd];
        
        return FALSE;
    }
    
    
    levelStartCount++;
    
    
    if (levelStartCount == (AdFrequency - 1)) {
        
        // Load an Intertitial on the level before it actual shows to expidite view time
        
        [AdMobInterstitial release];
        
        AdMobInterstitial = [[[GADInterstitial alloc] init] retain];
        AdMobInterstitial.adUnitID = @"ca-app-pub-5878740139610828/9405078796";
        AdMobInterstitial.delegate = self;
        
        [AdMobInterstitial loadRequest: [GADRequest request]];
    }
    
    if (levelStartCount >= AdFrequency) {
        levelStartCount = 0;
        
        if (AdMobInterstitial.isReady) [AdMobInterstitial presentFromRootViewController: self];
        else levelStartCount = AdFrequency - 1;
        
    }
    
    
    
    
    
    [MyGamePlayView setUpLevelFromDictionary: [self retreiveDictionaryForLevel: level]];
    
    
    
    
    // Load this shit from save file
    [MyGamePlayView setHighScore_Moves: [self moveCountHighScoreForLevel: level]];
    [MyGamePlayView levelPlayedBefore: [self levelCompleted: level]];
    [MyGamePlayView setLevelDifficulty: [self difficultyForLevel: level]];
    
    
    
    [MyGamePlayView setLevel: level];
    
    
    
    [MyGameMenu setHidden: TRUE];
    [MyGamePlayView setHidden: FALSE];
    
    return TRUE;
}



- (void)exitGameToMenu {
    
    GameplayActive = FALSE;
    
    [MyGameMenu setHidden: FALSE];
    [MyGamePlayView setHidden: TRUE];
    
    
    [self WS_showBannerAd];
}




- (BOOL)shouldAutorotate {
    return FALSE;
}





- (void)awakeFromNib {
    
    
    // Because, for some reason, MyGamePlayView says FUCK YOU when I try to do this within awakeFromNib
    [NSTimer scheduledTimerWithTimeInterval: 0.0 target: self selector: @selector(beginGame) userInfo: nil repeats: NO];
    
    [super viewDidLoad];
    
}


















#pragma mark - Present Bug Reporting



- (void)beginBugReport {
    
    // If iPad, leave the Ad as is
    if (![[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) [self WS_hideBannerAd];
    
    
    NSString* ConnectionTest = [NSString stringWithContentsOfURL: [NSURL URLWithString: @"http://weinbergsoftware.com/BugReports/ReportCount.txt"] encoding: NSASCIIStringEncoding error:nil];
    if (!ConnectionTest) [[[UIAlertView alloc] initWithTitle: @"No Internet Connection" message: @"Unable to connect to weinbergsoftware.com" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
    else {
        
        WSBugReportViewController* bugReportVC = [[WSBugReportViewController alloc] initWithNibName: @"BugReport" bundle: [NSBundle mainBundle]];
        
        bugReportVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [bugReportVC setNCOIC: self];
        
        [self presentViewController: bugReportVC animated: YES completion: nil];
        
        // Call this command after presentation because the view is not loaded until after presentation
        [bugReportVC setLevelCount: [self numberOfLevels]];
        
    }
}



- (void)dismissBugReport {
    
    [self WS_showBannerAd];
    
    [self dismissViewControllerAnimated: TRUE completion: nil];
}
















#pragma mark - Paypal Shit



#pragma mark - Pay action

- (void)pay:(NSString*)amount {
    
    
    // If iPad, leave the Ad as is
    if (![[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) [self WS_hideBannerAd];
    
    
    // Remove our last completed payment, just for demo purposes.
    self.completedPayment = nil;
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString: amount];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Donation to Weinberg Software";
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Any customer identifier that you have will work here. Do NOT use a device- or
    // hardware-based identifier.
    //NSString *customerId = @"user-11723";
    NSString *customerId = @"Yes";
    
    // Set the environment:
    // - For live charges, use PayPalEnvironmentProduction (default).
    // - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
    // - For testing, use PayPalEnvironmentNoNetwork.
    [PayPalPaymentViewController setEnvironment:self.environment];
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId: kPayPalClientId receiverEmail: kPayPalReceiverEmail
                                                                                                       payerId: customerId
                                                                                                       payment: payment
                                                                                                      delegate: self];
    paymentViewController.hideCreditCardButton = !self.acceptCreditCards;
    
    [self presentViewController: paymentViewController animated: YES completion: nil];
    
    
    [payment release];
}









#pragma mark - Proof of payment validation




- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    
    NSDictionary* PayConfirmation = completedPayment.confirmation;
    
    
    NSDictionary* ProofOfPayment = [[PayConfirmation objectForKey: @"proof_of_payment"] objectForKey: @"adaptive_payment"];
    
    NSString* PayAmount = completedPayment.localizedAmountForDisplay;
    NSString* PayKey = [ProofOfPayment objectForKey: @"pay_key"];
    NSString* PayStatus = [ProofOfPayment objectForKey: @"payment_exec_status"];
    
    
    
    
    NSString* DonationForm = [NSString stringWithFormat: @"http://www.weinbergsoftware.com/DualAmNu/Remote.php?func=processppdonation&key=%@&amount=%@&status=%@", PayKey, PayAmount, PayStatus];
    NSString* DonationRequestURL = [DonationForm stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    
    NSString* DonationResult = [NSString stringWithContentsOfURL: [NSURL URLWithString: DonationRequestURL] encoding: NSASCIIStringEncoding error: nil];
    
    
    
    // Save the fact that the user donated... in case of unlockable features in the future
    [SaveDataDictionary setObject: [NSNumber numberWithBool: TRUE] forKey: @"DidDonate"];
    [self saveData];
    
    
    if ([DonationResult isEqualToString: @"true"]) {
        
        // Yup
        
    }
    else {
        
        // TODO: Create way to save confirmation in the event the server is down
        
    }

    
}








#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    
    [self WS_showBannerAd];
    
    NSLog(@"PayPal Payment Success!");
    self.completedPayment = completedPayment;
    //self.successView.hidden = NO;
    
    [self sendCompletedPaymentToServer: completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    
    [self WS_showBannerAd];
    
    
    NSLog(@"PayPal Payment Canceled");
    self.completedPayment = nil;
    //self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}














#pragma mark Google Ad Banner Delegate



- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
    [bannerView setHidden: FALSE];
    if (!GameplayActive) [self WS_showBannerAd];
    else [self WS_hideBannerAd];
    
    
}


- (void)retryLoadingAd {
    /*
    NSLog(@"RETRY");
    
    GADRequest* request = [GADRequest request];
    [AdMobBannerView loadRequest: request];
    
    
    GADRequest* request2 = [GADRequest request];
    [DuringGameplayAdMobBannerView loadRequest: request2];
     */
}



- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [MyGamePlayView displayingAd: FALSE];
    
    if (bannerView == AdMobBannerView) {
        [AdMobBannerView setHidden: TRUE];
    }
    
    if (bannerView == DuringGameplayAdMobBannerView) {
        [AdMobBannerView setHidden: TRUE];
    }

    
    // Try again in 3 minutes
    [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector: @selector(retryLoadingAd) userInfo: nil repeats: FALSE];
    
}



@end
