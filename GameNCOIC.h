//
//  GameNCOIC.h
//  GameIdeaProto
//
//  Created by Mike Weinberg on 7/4/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>


#import "GADInterstitial.h"
#import "GADBannerView.h"
#import "GADRequestError.h"

#import <RevMobAds/RevMobAds.h>
#import <iAd/iAd.h>


#import "GamePlayView.h"
#import "GameMenu.h"

#import <QuartzCore/QuartzCore.h>
#import "PayPalMobile.h"




#import "WSBugReportViewController.h"








@interface GameNCOIC : UIViewController <PayPalPaymentDelegate, ADBannerViewDelegate, GADBannerViewDelegate, GADInterstitialDelegate> {
    
    
    
    // AdMob Advertisement
    
    GADInterstitial* AdMobInterstitial;
    
    GADBannerView* AdMobBannerView;
    GADBannerView* DuringGameplayAdMobBannerView;
    
    // AdMob Advertisement
    
    
    
    
    NSMutableArray* Incomplete_UnlockedLevels;
    
    
    
    
    
    int levelStartCount;
    
    
    BOOL GameplayActive;
    
    IBOutlet GameMenu* MyGameMenu;
    IBOutlet GamePlayView* MyGamePlayView;
    
    
    NSArray* LevelList;
    NSMutableDictionary* SaveDataDictionary;
    
}


@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;



- (void)saveDataForLevel:(int)level moveCountHighScore:(int)highscore;


- (int)difficultyForLevel:(int)level;
- (BOOL)levelCompleted:(int)level;
- (BOOL)levelUnlocked:(int)level;
- (int)numberOfLevels;


- (void)launchTutorial;

- (BOOL)loadLevel:(int)level;

- (void)exitGameToMenu;


- (void)beginBugReport;
- (void)dismissBugReport;


- (void)pay:(NSString*)amount;


@end
