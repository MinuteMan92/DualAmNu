//
//  HHC.h
//  GameIdeaProto
//
//  Created by Mike Weinberg on 7/25/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



// Size of Navigation Buttons
#define NavigationButtonSize 45



// Frequency that Ads show during gameplay
#define WS_AdvertisementFrequency 5




// Level Dictionary Keys
#define LevelDictionary_LevelUID @"lvl_uid"
#define LevelDictionary_LevelData @"lvl_data"
#define LevelDictionary_LevelDifficulty @"lvl_diff"



// Core and Ring Dictionary Keys
#define LevelDictionary_CoreList @"core_list"
#define LevelDictionary_EnemyList @"enemy_list"

#define LevelDictionary_CoreColor @"core_color"
#define LevelDictionary_RingColor @"ring_color"
#define LevelDictionary_PositionX @"posX"
#define LevelDictionary_PositionY @"posY"
#define LevelDictionary_Size @"size"




// Level Difficulties

typedef enum {
    LD_Easy = 0,
    LD_Medium  = 1,
    LD_Difficult  = 2,
}
LevelDifficultyRating;



// Main Menu Width and Height
#define GameMenusSize_x 250
#define GameMenusSize_y 400



// Main Menu Button Titles
#define MMBT_Levels @"levels"
#define MMBT_About @"about"
#define MMBT_Tutorial @"how to play"
#define MMBT_Donate @"donate"


// Main Menu Display Titles
//#define MMT_MainMenu @"proj molon labe"
#define MMT_LevelSet @"Levels"
#define MMT_LevelGrid @"Proj Molon Labe"
#define MMT_About @"About"





typedef enum {
    MMDM_MainMenu = 0,
    MMDM_LevelSetMenu  = 1,
    MMDM_About  = 2,
    MMDM_Donate = 3,
}
MainMenuDisplayMode;                // Which menu is displayed





typedef enum {
    GPVNM_LevelCleared = 0,
    GPVNM_LevelFailure  = 1,
    GPVNM_LevelClearedPerfect  = 2,
    GPVNM_ExitToMenu  = 3,
}
GPV_NotificationMode;               // Notification Window Modes




typedef enum {
    GPOC_Red = 0,
    GPOC_Orange  = 1,
    GPOC_Yellow  = 2,
    GPOC_Green  = 3,
    GPOC_Blue  = 4,
    GPOC_Purple  = 5,
    GPOC_Pink  = 6,
    GPOC_Gray  = 7,
    GPOC_Black  = 8,
    GPOC_White  = 9,
}
GameplayObjectColor;                // Core and Ring Color Modes









@interface HHC : NSObject


+ (int)randomNumberBetweenZeroAnd:(int)numba;

+ (NSString*)appDisplayNameWithVersion:(BOOL)includeVersion;


+ (NSAttributedString*)gameCommonAttributedString:(NSString*)string withFontSize:(float)fontSize;


+ (void)drawButtonWithiPhoneRect:(CGRect)iphoneRect iPadRect:(CGRect)ipadRect label:(NSString*)label labelPosition:(CGPoint)point selected:(BOOL)selected context:(CGContextRef)context;


+ (UIColor*)colorForDifficulty:(LevelDifficultyRating)difficulty;



+ (void)playSelectionSound;
+ (void)playUnselectionSound;

+ (void)playRingBirthNoise;

+ (void)playSwitchSound;
+ (void)playRejectionSound;

+ (void)playLevelSuccessSound;


@end
