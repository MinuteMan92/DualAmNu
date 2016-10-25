//
//  HHC.m
//  GameIdeaProto
//
//  Created by Mike Weinberg on 7/25/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import "HHC.h"


@implementation HHC






+ (int)randomNumberBetweenZeroAnd:(int)numba {
    FILE *fp = fopen("/dev/random", "r");
    uint64_t value = fgetc(fp);
    fclose(fp);
    return ((value * numba) / 255);
}



+ (NSString*)appDisplayNameWithVersion:(BOOL)includeVersion {
    
    NSDictionary* appInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSString* returnString = [appInfo objectForKey: @"CFBundleDisplayName"];
    
    if (includeVersion) returnString = [NSString stringWithFormat: @"%@ %@", returnString, [appInfo objectForKey:@"CFBundleVersion"]];
    
    
    return returnString;
}





+ (NSAttributedString*)gameCommonAttributedString:(NSString*)string withFontSize:(float)fontSize {
    NSArray* keys = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
    NSArray* objects = [NSArray arrayWithObjects: [UIFont fontWithName: @"Arial Rounded MT Bold" size: fontSize], [UIColor whiteColor], nil];
    NSDictionary* stringAttributes = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
    
    NSAttributedString* returnString = [[NSAttributedString alloc] initWithString: string attributes: stringAttributes];
    [returnString autorelease];
    
    
    return returnString;
}




+ (void)drawButtonWithiPhoneRect:(CGRect)iphoneRect iPadRect:(CGRect)ipadRect label:(NSString*)label labelPosition:(CGPoint)point selected:(BOOL)selected context:(CGContextRef)context {
    
    
    
    // Determine device
    CGRect buttonRect;
    
    if ([[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) buttonRect = ipadRect;
    else buttonRect = iphoneRect;
    
    
    
    // Set up a context if one does not exist
    if (!context) context = UIGraphicsGetCurrentContext();
    
    
    
    
    struct CGColor* unselectedColor = [UIColor grayColor].CGColor;
    struct CGColor* selectedColor = [UIColor lightGrayColor].CGColor;
    
    struct CGColor* buttonBackgroundColor = [UIColor colorWithRed: 0.4 green: 0.4 blue: 0.4 alpha: 0.5].CGColor;
    CGContextSetFillColorWithColor(context, buttonBackgroundColor);
    
    CGContextSetLineWidth(context, 2.0);
    
    
    
    
    
    CGContextFillRect(context, buttonRect);
    if (selected) CGContextSetStrokeColorWithColor(context, selectedColor);
    else CGContextSetStrokeColorWithColor(context, unselectedColor);
    
    CGContextAddRect(context, buttonRect);
    CGContextStrokePath(context);
    
    
    
    
    
    
    if (label) {
        
        [[HHC gameCommonAttributedString: label withFontSize: 20.0] drawAtPoint: point];
        
    }
    
    
}





+ (UIColor*)colorForDifficulty:(LevelDifficultyRating)difficulty {
    
    UIColor* drawColor = [UIColor blueColor];
    if (difficulty == LD_Easy) drawColor = [UIColor greenColor];
    else if (difficulty == LD_Medium) drawColor = [UIColor yellowColor];
    else if (difficulty == LD_Difficult) drawColor = [UIColor redColor];
    
    [drawColor autorelease];
    
    return drawColor;
    
}








+ (void)playSelectionSound {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Select" ofType:@"wav"];
    AVAudioPlayer* tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error:NULL];
    [tapSound prepareToPlay];
    
    
    [tapSound play];
    
}

+ (void)playUnselectionSound {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Unselect" ofType:@"wav"];
    AVAudioPlayer* tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error:NULL];
    [tapSound prepareToPlay];
    
    [tapSound play];
    
}


+ (void)playRingBirthNoise {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RingBirth" ofType:@"wav"];
    AVAudioPlayer* tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error:NULL];
    [tapSound prepareToPlay];
    
    [tapSound play];
    
}


+ (void)playSwitchSound {
    
    // Random number function called twice to enhance randomness
    
    int swish = [HHC randomNumberBetweenZeroAnd: 3];
    swish = 0;  // Put this line in to get rid of the warning
    int swish1 = [HHC randomNumberBetweenZeroAnd: 3];
    
    if (swish1 == 0) swish1 = 3;
    
    NSString *path = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"Swish%i", swish1] ofType:@"wav"];
    AVAudioPlayer* tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error:NULL];
    [tapSound prepareToPlay];
    
    [tapSound play];
    
}

+ (void)playRejectionSound {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Rejection" ofType:@"wav"];
    AVAudioPlayer* tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error:NULL];
    [tapSound prepareToPlay];
    
    [tapSound play];
    
}

+ (void)playLevelSuccessSound {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Success" ofType:@"wav"];
    AVAudioPlayer* tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error:NULL];
    [tapSound prepareToPlay];
    
    [tapSound play];
    
}


@end
