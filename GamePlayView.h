//
//  GamePlayView.h
//  GameIdeaProto
//
//  Created by Mike Weinberg on 6/30/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import <AVFoundation/AVFoundation.h>

#import "GameplayObject.h"
#import "HHC.h"




@interface GPV_NotificationWindow : UIView {
    
    GPV_NotificationMode CurrentNotifMode;
    
    BOOL ButtonsEnabled;
    
    BOOL UserBeatHighScore;
    
    BOOL ExitButtonSelected;
    BOOL NL_R_ButtonSelected;
    
    CGRect ExitToMenuButtonRect;
    CGRect NextLevel_Retry_ButtonRect;
    
    
    NSDictionary* stringAttributes;
    
}

+ (GPV_NotificationWindow*)notificationWindowForOwner:(UIView*)owner;

- (void)establishButtonRects;

- (void)setNotificationMode:(GPV_NotificationMode)mode;
- (void)setHighScore:(BOOL)highscore;


- (void)animateIn;

@end





@interface GamePlayView : UIView {
    
    
    // Core Color Randomization
    
    NSMutableArray* ColorsAlreadyUsed;      // To ensure colors are not used twice in the same level
    
    NSMutableDictionary* ColorAssignmentDictionary;  // So that core colors and ring colors match
    
    // Core Color Randomization
    
    
    
    
    
    BOOL TutorialMode;
    int TutorialPage;
    NSString* TutorialDisplayText;
    float TutorialTextXPercent;
    float TutorialTextYPercent;
    
    CGRect ShowLastButtonRect;
    BOOL Tutorial_ShowLastPageButton_Selected;
    BOOL Tutorial_ShowLastPageButton;
    
    CGRect ShowNextButtonRect;
    BOOL Tutorial_ShowNextPageButton_Selected;
    BOOL Tutorial_ShowNextPageButton;
    
    
    
    
    BOOL DisplayingAd;
    
    
    
    id NCOIC;
    
    BOOL AllowInteraction;
    
    BOOL LevelPlayedBefore;
    int HighScore_Moves;
    LevelDifficultyRating CurrentLevelDifficulty;
    int CurrentLevel;
    
    int MoveCount;
    BOOL MovesLeft;
    
    BOOL UserWon;
    
    NSDictionary* LevelDictionary;
    
    
    BOOL ShowResetButton;
    BOOL ResetButtonSelected;
    CGRect ResetButtonRect;
    
    
    BOOL ExitButtonSelected;
    CGRect ExitToMenuButtonRect;
    
    UIImage* ExitButtonUpImage;
    UIImage* ExitButtonDownImage;
    
    
}

- (void)setNCOIC:(id)ncoic;

- (void)setUpLevelFromDictionary:(NSDictionary*)levelDict;

- (void)beginTutorial;
- (void)continueTutorialFromCore;


- (void)setLevelDifficulty:(LevelDifficultyRating)difficulty;
- (void)setLevel:(int)level;
- (int)currentLevel;


- (void)levelPlayedBefore:(BOOL)playedBefore;

- (void)setHighScore_Moves:(int)highscore;


- (void)testCoresForMatch;


- (void)allowInteraction:(BOOL)allow;


- (void)retryLevel;
- (void)nextLevel;
- (void)exitToMenu;


- (void)displayingAd:(BOOL)display;



@end
