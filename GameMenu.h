//
//  GameMenu.h
//  GameIdeaProto
//
//  Created by Mike Weinberg on 7/4/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


#import "GameplayObject.h"
#import "GamePlayView.h"
#import "HHC.h"




@interface Menu_GP_Core : GP_Core

@end






@interface LevelPageObject : NSObject {
    
    LevelDifficultyRating levelDifficulty;
    int representedLevel;
    
    CGRect drawRect;
    
    UIView* myOwner;
    
    BOOL IsSelected;
    
}

+ (LevelPageObject*)levelPageObjectWithLevel:(int)level rect:(CGRect)rect owner:(UIView*)owner;

- (void)setOwner:(UIView*)owner;

- (void)setLevel:(int)level;
- (int)level;

- (void)setRect:(CGRect)rect;
- (CGRect)rect;

@end





@interface LevelPageView : UIView {
    
    UIView* myOwner;
    
    NSMutableArray* levelObjectList;
    
    int FirstLevelNumber;
    int LastLevelNumber;
    
}

- (void)userSelectedLevel:(int)level;

- (void)setOwner:(UIView*)owner;
- (void)setFirstLevel:(int)firstLN lastLevel:(int)secondLN;

- (int)difficultyForLevel:(int)level;
- (BOOL)levelCompleted:(int)level;
- (BOOL)levelUnlocked:(int)level;

@end






@interface StartupMenu : UIView <UIScrollViewDelegate> {
    
    id MyOwner;
    
    
    BOOL LevelPageViewDrawnToDate;
    
    
    NSString* CurrentMenuTitle;
    NSDictionary* MenuTitleAttributes;
    
    
    MainMenuDisplayMode MenuMode;
    
    
    // Back Button
    BOOL DisplayBackButton;
    BOOL BackButtonSelected;
    CGRect BR_BackButton;
    
    
    
    // Level Navigation Buttons
    BOOL BacLevNavEnabled;
    BOOL BacLevNavSelected;
    CGRect BacLevNavRect;
    
    BOOL ForLevNavEnabled;
    BOOL ForLevNavSelected;
    CGRect ForLevNavRect;
    
    
    
    // Main Menu Buttons
    BOOL BS_Levels;
    CGRect BR_Levels;
    
    BOOL BS_Donate;
    CGRect BR_Donate;
    
    BOOL BS_About;
    CGRect BR_About;
    
    BOOL BS_Tutorial;
    CGRect BR_Tutorial;
    
    
    
    // About Menu Button
    BOOL BugReportButtonSelected;
    CGRect BR_BugReport;
    
    
    
    // Donation Buttons
    BOOL DonationButton_OneDollar_Selected;
    CGRect DonationButton_OneDollar;
    
    BOOL DonationButton_TwoDollar_Selected;
    CGRect DonationButton_TwoDollar;
    
    BOOL DonationButton_FiveDollar_Selected;
    CGRect DonationButton_FiveDollar;
    
    BOOL DonationButton_TenDollar_Selected;
    CGRect DonationButton_TenDollar;
    
    
    
    
    UIScrollView* myScrollView;
}

- (void)userSelectedLevel:(int)level;


- (void)setMenuMode:(MainMenuDisplayMode)menuMode;
- (MainMenuDisplayMode)menuMode;


- (void)setLevelPage:(int)page;
- (int)currentLevelPage;

- (int)difficultyForLevel:(int)level;
- (BOOL)levelCompleted:(int)level;
- (BOOL)levelUnlocked:(int)level;

- (void)levelPageObjectsNeedUpdating;

@end









typedef enum {
    AnimationDirection_TopBottom = 0,
    AnimationDirection_BottomTop  = 1,
    
    AnimationDirection_LeftRight = 2,
    AnimationDirection_RightLeft = 3,
}
GameMenuAnimDirection;



@interface GameMenuAnimObject : NSObject {
    
    UIView* My_Superview;
    
    GameMenuAnimDirection MoveDirection;
    
    UIColor* DrawColor;
    
    int Pos_x;
    int Pos_y;
    
    int Length;
    int Width;
    
    float Speed;
}

+ (GameMenuAnimObject*)newGameMenuObjectWithSuperview:(UIView*)superview;

- (void)update;

- (void)drawCurrentFrame:(CGContextRef)context;

- (void)setSuperview:(UIView*)superview;
- (void)setDrawColor:(UIColor*)color;
- (void)setPositionX:(int)x positionY:(int)y length:(int)length width:(int)width direction:(GameMenuAnimDirection)direction speed:(int)speed;

@end




@interface GameMenu : UIView {
    
    id MyNCOIC;
    
    BOOL FireFirst;
    
    StartupMenu* MyStartUpMenu;
    
    
    
    // Animation Shit
    BOOL ContinueAnimation;
    NSTimer* AnimationTimer;
    
    GameMenuAnimObject* AnimObject1;
    GameMenuAnimObject* AnimObject2;
    GameMenuAnimObject* AnimObject3;
    GameMenuAnimObject* AnimObject4;
}



- (void)beginGameWithNCOIC:(id)ncoic;
- (id)NCOIC;



- (void)beginAnimation;
- (void)resumeAnimation;
- (void)pauseAnimation;



- (void)userSelectedLevel:(int)level;
- (void)userSelectedTutorial;
- (void)userSelectedDonate:(NSString*)amount;
- (void)userSelectedBugReport;



- (int)difficultyForLevel:(int)level;
- (BOOL)levelCompleted:(int)level;
- (BOOL)levelUnlocked:(int)level;


- (void)levelPageObjectsNeedUpdating;

@end
