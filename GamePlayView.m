//
//  GamePlayView.m
//  GameIdeaProto
//
//  Created by Mike Weinberg on 6/30/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import "GamePlayView.h"

#import "GameNCOIC.h"


@implementation GPV_NotificationWindow


+ (GPV_NotificationWindow*)notificationWindowForOwner:(UIView*)owner {
    
    int sizeW = 300;
    int sizeH = 170;
    
    int posX = (owner.frame.size.width / 2) - (sizeW / 2);
    int posY = (owner.frame.size.height / 2) - (sizeH / 2);
    
    GPV_NotificationWindow* notifWindow = [[GPV_NotificationWindow alloc] initWithFrame: CGRectMake(posX, posY, sizeW, sizeH)];
    
    [notifWindow establishButtonRects];
    
    notifWindow.backgroundColor = [UIColor clearColor];
    
    notifWindow.alpha = 0.0;
    
    return notifWindow;
}



- (void)establishButtonRects {
    int buttonWidth = (self.frame.size.width - 40) / 2;
    int buttonHeight = 60;
    
    int buttonX = (self.frame.size.width / 2) - buttonWidth;
    int currentY = 70;
    
    int buttonSeperation = 10;
    
    ExitToMenuButtonRect = CGRectMake(buttonX, currentY, buttonWidth - buttonSeperation, buttonHeight);
    
    NextLevel_Retry_ButtonRect = CGRectMake(buttonX + buttonWidth + buttonSeperation, currentY, buttonWidth - buttonSeperation, buttonHeight);
}



- (void)setNotificationMode:(GPV_NotificationMode)mode {
    CurrentNotifMode = mode;
    [self setNeedsDisplay];
}


- (void)setHighScore:(BOOL)highscore {
    UserBeatHighScore = highscore;
    [self setNeedsDisplay];
}





- (void)animateIn {
    
    UIView* myGameplayView = [self superview];
    [(GamePlayView*)myGameplayView allowInteraction: FALSE];
    
    if (CurrentNotifMode == GPVNM_LevelCleared || CurrentNotifMode == GPVNM_LevelClearedPerfect) [HHC playLevelSuccessSound];
    
    [UIView animateWithDuration: 0.15 animations:^{
        
        self.alpha = 1.0;
        
    }completion:^(BOOL finished){
        
        ButtonsEnabled = TRUE;
        
    }];
    
}





- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: self];
    
    if (ButtonsEnabled) {
        ExitButtonSelected = CGRectContainsPoint(ExitToMenuButtonRect, location);
        NL_R_ButtonSelected = CGRectContainsPoint(NextLevel_Retry_ButtonRect, location);
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBegan: touches withEvent: event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: self];
    
    
    if (ButtonsEnabled) {
        
        UIView* myGameplayView = [self superview];
    
    
        if (CGRectContainsPoint(ExitToMenuButtonRect, location)) {
        
            [HHC playUnselectionSound];
            [(GamePlayView*)myGameplayView exitToMenu];
        
        }
    
    
        
        
    
        BOOL retry_nextlevelButton = CGRectContainsPoint(NextLevel_Retry_ButtonRect, location);
    
        if (CurrentNotifMode == GPVNM_LevelCleared && retry_nextlevelButton) {
        
            [HHC playSelectionSound];
            [(GamePlayView*)myGameplayView nextLevel];
        
        }
        else if (CurrentNotifMode == GPVNM_LevelFailure && retry_nextlevelButton) {
        
            [HHC playUnselectionSound];
            [(GamePlayView*)myGameplayView retryLevel];
        
        }
        else if (CurrentNotifMode == GPVNM_ExitToMenu && retry_nextlevelButton) {
            
            [HHC playUnselectionSound];
            [(GamePlayView*)myGameplayView allowInteraction: TRUE];
            
            [self removeFromSuperview];
        }
    
    
    
        ExitButtonSelected = FALSE;
        NL_R_ButtonSelected = FALSE;
    
        
    }
    
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float colorIntensity = 0.2;
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed: colorIntensity green: colorIntensity blue: colorIntensity alpha: 0.8].CGColor);
    CGContextFillRect(context, rect);
    
    
    // Draw Border
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextAddRect (context, rect);
    CGContextStrokePath(context);
    
    
    
    
    
    // Set strings according to current mode
    
    NSString* WindowTitle = @"";
    int WindowTitleX = 0;
    
    NSString* OKButtonTitle = @"";
    int OKButtonTitleX = 0;
    
    if (CurrentNotifMode == GPVNM_LevelCleared) {
        if (UserBeatHighScore) {
            WindowTitle = @"NEW HIGHSCORE";
            WindowTitleX = 60;
        }
        else {
            WindowTitle = @"LEVEL CLEARED";
            WindowTitleX = 65;
        }
        
        OKButtonTitle = @"Next";
        OKButtonTitleX = 35;
    }
    else if (CurrentNotifMode == GPVNM_LevelFailure) {
        WindowTitle = @"LEVEL FAILED";
        WindowTitleX = 75;
        
        OKButtonTitle = @"Retry";
        OKButtonTitleX = 33;
    }
    else if (CurrentNotifMode == GPVNM_ExitToMenu) {
        WindowTitle = @"EXIT TO MENU?";
        WindowTitleX = 75;
        
        OKButtonTitle = @"Continue";
        OKButtonTitleX = 17;
    }
    
    
    
    
    // Draw Title
    if (!stringAttributes) {
        NSArray* keys = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
        NSArray* objects = [NSArray arrayWithObjects: [UIFont fontWithName: @"Arial Rounded MT Bold" size: 20.0], [UIColor whiteColor], nil];
        stringAttributes = [[NSDictionary dictionaryWithObjects: objects forKeys: keys] retain];
    }
    
    
    NSAttributedString* titleString = [[NSAttributedString alloc] initWithString: WindowTitle attributes: stringAttributes];
    [titleString drawAtPoint: CGPointMake(WindowTitleX, 25)];
    
    // TODO: Test if this was a memory leak
    [titleString autorelease];
    
    
    
    // Draw Buttons
    
    [HHC drawButtonWithiPhoneRect: ExitToMenuButtonRect iPadRect: ExitToMenuButtonRect label: @"Menu" labelPosition: CGPointMake(ExitToMenuButtonRect.origin.x + 33, ExitToMenuButtonRect.origin.y + ((ExitToMenuButtonRect.size.height / 2) - 12)) selected: ExitButtonSelected context: context];
    
    
    
    [HHC drawButtonWithiPhoneRect: NextLevel_Retry_ButtonRect iPadRect: NextLevel_Retry_ButtonRect label: OKButtonTitle labelPosition: CGPointMake(NextLevel_Retry_ButtonRect.origin.x + OKButtonTitleX, NextLevel_Retry_ButtonRect.origin.y + ((NextLevel_Retry_ButtonRect.size.height / 2) - 12)) selected: NL_R_ButtonSelected context: context];
    
    
    
}



- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self release];
}


- (void)dealloc {
    
    [stringAttributes release];
    
    [super dealloc];
}


@end






@implementation GamePlayView





- (void)checkMoves {
    
    if (!TutorialMode) {
    
    if (MovesLeft) {
        // Stop the timer loop if the view is hidden (which means the game is not currently being played)
        if (!self.hidden) [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(checkMoves) userInfo: nil repeats: NO];
    }
    else if (!UserWon) {
        
        [self allowInteraction: FALSE];
        
        
        GPV_NotificationWindow* notifWindow = [GPV_NotificationWindow notificationWindowForOwner: self];
        [notifWindow setNotificationMode: GPVNM_LevelFailure];
        [self addSubview: notifWindow];
        [notifWindow animateIn];
    
    }
        
    }
}



- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor blackColor];
    
    ShowResetButton = TRUE;
    
}



- (void)setNCOIC:(id)ncoic {
    NCOIC = ncoic;
}




- (void)playRingBirthNoise {
    [HHC playRingBirthNoise];
}



#pragma mark -
#pragma mark Color Randomization

- (GameplayObjectColor)colorThatReplacesOldColor:(GameplayObjectColor)oldColor {
    return [[ColorAssignmentDictionary objectForKey: [NSNumber numberWithInt: oldColor]] intValue];
}

- (GameplayObjectColor)randomUnusedColorToReplaceColor:(GameplayObjectColor)oldColor {
    
    if (!ColorsAlreadyUsed) ColorsAlreadyUsed = [[NSMutableArray array] retain];
    if (!ColorAssignmentDictionary) ColorAssignmentDictionary = [[NSMutableDictionary dictionary] retain];
    
    
    if ([ColorsAlreadyUsed count] == 0) {
        [ColorsAlreadyUsed addObject: [NSNumber numberWithInt: GPOC_Pink]];     // Since there is no image for Pink...
        [ColorsAlreadyUsed addObject: [NSNumber numberWithInt: GPOC_Gray]];     // Since Gray looks to similar to Black and White
    }
    
    
    GameplayObjectColor returnColor = 0;
    
    
    int isCleared = 0;
    while (isCleared == 0) {
        
        returnColor = [HHC randomNumberBetweenZeroAnd: 11];
        
        if (returnColor == 10) returnColor = 9; // For added randomization
        if (returnColor == 11) returnColor = 4;
        
        if (![ColorsAlreadyUsed containsObject: [NSNumber numberWithInt: returnColor]]) isCleared++;
        
    }
    
    [ColorsAlreadyUsed addObject: [NSNumber numberWithInt: returnColor]];
    
    
    [ColorAssignmentDictionary setObject: [NSNumber numberWithInt: returnColor] forKey: [NSNumber numberWithInt: oldColor]];
    
    
    
    return returnColor;
}

#pragma mark -




- (void)setUpLevelFromDictionary:(NSDictionary*)levelDict {
    
    [ColorsAlreadyUsed removeAllObjects];
    [ColorAssignmentDictionary removeAllObjects];
    
    
    
    
    
    AllowInteraction = TRUE;
    
    if (!TutorialMode) [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(checkMoves) userInfo: nil repeats: NO];
    
    MoveCount = 0;
    UserWon = FALSE;
    
    LevelDictionary = [levelDict retain];
    
    
    [[self subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    
    
    
    NSMutableArray* CoreList = [NSMutableArray array];
    
    
    
    
    NSArray* gameObjectList = [levelDict objectForKey: LevelDictionary_CoreList];
    
    
    
    int repeatCount = 0;
    while (([gameObjectList count]) > repeatCount) {
        
        
        
        NSDictionary* CurrentObject = [gameObjectList objectAtIndex: repeatCount];
        
        
        
        //NSArray* keys = [NSArray arrayWithObjects: @"core_color", @"ring_color", @"posX", @"posY", @"size", nil];
        
        
        
        
        GameplayObjectColor coreColor = [[CurrentObject objectForKey: LevelDictionary_CoreColor] intValue];
        if (!TutorialMode) coreColor = [self randomUnusedColorToReplaceColor: coreColor];
        
        GameplayObjectColor ringColor = [[CurrentObject objectForKey: LevelDictionary_RingColor] intValue];
        
        int posX = [[CurrentObject objectForKey: LevelDictionary_PositionX] intValue];
        int posY = [[CurrentObject objectForKey: LevelDictionary_PositionY] intValue];
        
        int size = [[CurrentObject objectForKey: LevelDictionary_Size] intValue];
        
        if ([[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) {
            size = (size * .85);
        }
        
        
        GP_Core* theCore = [GP_Core coreWithColor: coreColor];
        GP_Ring* theRing = [GP_Ring ringWithColor: ringColor birthed: FALSE];
        
        
        int finalSize = (size * self.frame.size.width) / 100;
        
        
        int finalX = (posX * self.bounds.size.width) / 100;
        int finalY = (posY * self.bounds.size.height) / 100;
        
        
        [theCore setSizeScale: finalSize];
        theCore.center = CGPointMake(finalX, finalY);
        [theCore setRingObject: theRing fromCore: nil];
        
        
        [CoreList addObject: theCore];
        
        
        [self addSubview: theRing];
        
        
        
        
        
        
        repeatCount = repeatCount + 1;
    }
    
    
    
    
    
    
    
    // Figure out enemies
    
    
    NSArray* enemyList = [levelDict objectForKey: LevelDictionary_EnemyList];
    
    repeatCount = 0;
    while (([enemyList count]) > repeatCount) {
        
        
        NSArray* currentEnemies = [enemyList objectAtIndex: repeatCount];
        
        
        int enemyIndexA = [[currentEnemies objectAtIndex: 0] intValue];
        int enemyIndexB = [[currentEnemies objectAtIndex: 1] intValue];
        
        
        
        GP_Core* EnemyA = [CoreList objectAtIndex: enemyIndexA];
        GP_Core* EnemyB = [CoreList objectAtIndex: enemyIndexB];
        
        
        [EnemyA addEmbargo: EnemyB];
        [EnemyB addEmbargo: EnemyA];
        
        
        repeatCount = repeatCount + 1;
    }
    
    
    
    
    
    
    
    
    // Add every core to self as subview
    repeatCount = 0;
    while (([CoreList count]) > repeatCount) {
        
        GP_Core* CurrentCore = [CoreList objectAtIndex: repeatCount];
        [self addSubview: CurrentCore];
        
        repeatCount = repeatCount + 1;
        
    }
    
    
    
    
    // Birth all subviewed Rings
    
    NSArray* mySubviews = [self subviews];
    
    repeatCount = 0;
    while (([mySubviews count]) > repeatCount) {
        
        id CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Ring class]]) [CurrentSubview setBirth: TRUE animate: TRUE];
        
        repeatCount = repeatCount + 1;
        
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval: 0.4 target: self selector: @selector(playRingBirthNoise) userInfo: nil repeats: FALSE];
    
    
    
    
    
    
    // Set up all the ring colors to match core colors from randomization
    
    
    if (!TutorialMode) {
        
        repeatCount = 0;
        while (([mySubviews count]) > repeatCount) {
            GP_Ring* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
            if ([CurrentSubview isKindOfClass: [GP_Ring class]]) [CurrentSubview setGPObjectColor: [self colorThatReplacesOldColor: [CurrentSubview GPObjectColor]]];
            repeatCount++;
        }
        
    }
    
    
    [self setNeedsDisplay];
}











- (void)setLevelDifficulty:(LevelDifficultyRating)difficulty {
    CurrentLevelDifficulty = difficulty;
    [self setNeedsDisplay];
}



- (void)setLevel:(int)level {
    CurrentLevel = level;
    [self setNeedsDisplay];
}
- (int)currentLevel {return CurrentLevel;}


- (void)levelPlayedBefore:(BOOL)playedBefore {
    LevelPlayedBefore = playedBefore;
}


- (void)setHighScore_Moves:(int)highscore {
    HighScore_Moves = highscore;
    [self setNeedsDisplay];
}




/*
- (int)moveCount {
    return MoveCount;
}

*/




- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();    
    
    
    MovesLeft = FALSE;
    
    
    
    // Draw Lines from Core to Core
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        
        if ([CurrentSubview isKindOfClass: [GP_Core class]]) {
            
            int repeatCount2 = 0;
            while (([mySubviews count]) > repeatCount2) {
                
                GP_Core* CurrentSubview2 = [mySubviews objectAtIndex: repeatCount2];
                
                if ([CurrentSubview2 isKindOfClass: [GP_Core class]] && (CurrentSubview2 != CurrentSubview) && ![CurrentSubview Query_EmbargoWithCore: CurrentSubview2]) {
                    
                    
                    // Draw Background of Line
                    CGContextSetLineWidth(context, 3.0);
                    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
                    
                    CGContextMoveToPoint(context, CurrentSubview.center.x, CurrentSubview.center.y); //start at this point
                    
                    CGContextAddLineToPoint(context, CurrentSubview2.center.x, CurrentSubview2.center.y); //draw to this point
                    CGContextStrokePath(context);
                    
                    // Determine color of line
                    if ([(GP_Core*)CurrentSubview Query_TradedWithCore: CurrentSubview2]) {
                        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
                    }
                    else {
                        MovesLeft = TRUE;
                        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
                    }
                    
                    // Draw Color of line
                    CGContextSetLineWidth(context, 2.0);
                    CGContextMoveToPoint(context, CurrentSubview.center.x, CurrentSubview.center.y); //start at this point
                    CGContextAddLineToPoint(context, CurrentSubview2.center.x, CurrentSubview2.center.y); //draw to this point
                    CGContextStrokePath(context);
                    
                    
                }
                repeatCount2 = repeatCount2 + 1;
            }
            
            
            
        }
        repeatCount = repeatCount + 1;
        
    }
    
    
    
    
    
    // Level Text
    
    float fontSize = 35;
    
    UIColor* TitleColor = [HHC colorForDifficulty: CurrentLevelDifficulty];
    
    NSArray* keys = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
    NSArray* objects = [NSArray arrayWithObjects: [UIFont fontWithName: @"Arial Rounded MT Bold" size: fontSize], TitleColor, nil];
    NSDictionary* stringAttributes = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
    
    
    NSAttributedString* levelString = nil;
    if (!TutorialMode) levelString = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"level %i", CurrentLevel] attributes: stringAttributes];
    else levelString = [[NSAttributedString alloc] initWithString: @"Tutorial" attributes: stringAttributes];
    
    
    //NSAttributedString* levelString = [HHC gameCommonAttributedString: [NSString stringWithFormat: @"level %i", CurrentLevel] withFontSize: (self.frame.size.height) / 15];
    
    int levelStringX = 20;
    int levelStringY = 15;
    
    int exitToMenuButtonSize = 35;
    
    [levelString drawAtPoint: CGPointMake(exitToMenuButtonSize + levelStringX + 12, levelStringY + 1)];
    [levelString release];
    
    ExitToMenuButtonRect = CGRectMake(levelStringX, levelStringY + 8, exitToMenuButtonSize, /*fontSize - 5*/ exitToMenuButtonSize - 5);
    
    
    /*
    CGRect touchAreaRect = CGRectMake(ExitToMenuButtonRect.origin.x - 20, ExitToMenuButtonRect.origin.y - 20, ExitToMenuButtonRect.size.width + 40, ExitToMenuButtonRect.size.height + 40);
    CGContextFillRect(context, touchAreaRect);
    */
    
   
    if (!ExitButtonUpImage) ExitButtonUpImage = [[UIImage imageNamed: @"BackToMenuButtonUp.png"] retain];
    if (!ExitButtonDownImage) ExitButtonDownImage = [[UIImage imageNamed: @"BackToMenuButtonDown.png"] retain];
    
    if (ExitButtonSelected) [ExitButtonDownImage drawInRect: ExitToMenuButtonRect];
    else [ExitButtonUpImage drawInRect: ExitToMenuButtonRect];
    
    
    
    
    
    // Reset Button
    
    
    if (ShowResetButton) {
        int ResetButtonWidth = 90;
        CGPoint labelPosition = CGPointMake(ResetButtonRect.origin.x + 16, ResetButtonRect.origin.y + ((ResetButtonRect.size.height / 2) - 12));
        
        ResetButtonRect = CGRectMake(self.frame.size.width - (ResetButtonWidth + levelStringX), levelStringY + 8, ResetButtonWidth, /*fontSize - 5*/ exitToMenuButtonSize - 5);
        if (ResetButtonSelected) [HHC drawButtonWithiPhoneRect: ResetButtonRect iPadRect: ResetButtonRect label: @"Reset" labelPosition: labelPosition selected: TRUE context: context];
        else [HHC drawButtonWithiPhoneRect: ResetButtonRect iPadRect: ResetButtonRect label: @"Reset" labelPosition: labelPosition selected: FALSE context: context];
    }
    
    
    
    
    // Score Block
    
    if (!TutorialMode) {        // Only display if during actual gameplay
        
        NSArray* keys2 = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
        NSArray* objects2 = [NSArray arrayWithObjects: [UIFont fontWithName: @"Arial Rounded MT Bold" size: 15.0], [UIColor whiteColor], nil];
        NSDictionary* stringAttributes2 = [NSDictionary dictionaryWithObjects: objects2 forKeys: keys2];
        
        
        NSString* scoreBlockString;
        
        if (LevelPlayedBefore) scoreBlockString = [NSString stringWithFormat: @"highscore: %i       moves: %i", HighScore_Moves, MoveCount];
        else scoreBlockString = [NSString stringWithFormat: @"highscore: -       moves: %i", MoveCount];
        
        
        int positionX = (self.frame.size.width / 2) - 95;
        
        if (DisplayingAd && [[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) positionX = positionX + 95;
        
        
        NSAttributedString* highscoreString = [[NSAttributedString alloc] initWithString: scoreBlockString attributes: stringAttributes2];
        [highscoreString drawAtPoint: CGPointMake(positionX, self.frame.size.height - 30)];
        [highscoreString release];
    
    }
    
    
    
    
    // Tutorial Mode
    
    
    if (TutorialMode) {
        
        int deviceType = 0; // If 0, iPhone.... if 1, iPad
        
        if ([[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) deviceType = 1;
        else deviceType = 0;
        
        
        float fontSize = 15.0;
        if (deviceType == 1) fontSize = 25.0;
        
        NSArray* keys = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
        NSArray* objects = [NSArray arrayWithObjects: [UIFont fontWithName: @"Arial Rounded MT Bold" size: fontSize], [UIColor whiteColor], nil];
        NSDictionary* stringAttributes = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
        
        
        
        NSAttributedString* TutorialAString = [[NSAttributedString alloc] initWithString: TutorialDisplayText attributes: stringAttributes];
        [TutorialAString drawAtPoint: CGPointMake(self.frame.size.width * (TutorialTextXPercent / 100.0), self.frame.size.height * (TutorialTextYPercent / 100.0))];
        [TutorialAString release];
        
        
        
        ShowLastButtonRect = CGRectMake((self.frame.size.width * 0.30) - (NavigationButtonSize / 2), self.frame.size.height - (NavigationButtonSize + 34), NavigationButtonSize, NavigationButtonSize);
        ShowNextButtonRect = CGRectMake((self.frame.size.width * 0.70) - (NavigationButtonSize / 2), self.frame.size.height - (NavigationButtonSize + 34), NavigationButtonSize, NavigationButtonSize);
        
        
        
        
        
        
        /*
        if (Tutorial_ShowLastPageButton) {
            if (Tutorial_ShowLastPageButton_Selected) [[UIImage imageNamed: @"NavArrowLeft_Sel.png"] drawInRect: ShowLastButtonRect];
            else [[UIImage imageNamed: @"NavArrowLeft.png"] drawInRect: ShowLastButtonRect];
        }
        */
        
        if (Tutorial_ShowNextPageButton) {
            
            NSAttributedString* TutorialNextString = [[NSAttributedString alloc] initWithString: @"Next" attributes: stringAttributes];
            [TutorialNextString drawAtPoint: CGPointMake((self.frame.size.width / 2) - 16, self.frame.size.height - (NavigationButtonSize + 21))];
            [TutorialNextString release];
            
            if (Tutorial_ShowNextPageButton_Selected) [[UIImage imageNamed: @"NavArrowRight_Sel.png"] drawInRect: ShowNextButtonRect];
            else [[UIImage imageNamed: @"NavArrowRight.png"] drawInRect: ShowNextButtonRect];
        }
        
        
        
    }
    
    
}





- (void)levelCleared {
    
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    
    while (([mySubviews count]) > repeatCount) {
    
        GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        
        if ([CurrentSubview isKindOfClass: [GP_Core class]]) [CurrentSubview animateMatch];
        
        repeatCount++;
        
    }
    
    
    
    
    if (HighScore_Moves > MoveCount) HighScore_Moves = MoveCount;
    [(GameNCOIC*)NCOIC saveDataForLevel: CurrentLevel moveCountHighScore: HighScore_Moves];
    
    
    
    GPV_NotificationWindow* notifWindow = [GPV_NotificationWindow notificationWindowForOwner: self];
    [notifWindow setNotificationMode: GPVNM_LevelCleared];
    
    if (HighScore_Moves > MoveCount && LevelPlayedBefore) [notifWindow setHighScore: TRUE];
    else [notifWindow setHighScore: FALSE];
    
    [self addSubview: notifWindow];
    [notifWindow animateIn];
    
}





- (void)testCoresForMatch {
    [self setNeedsDisplay];
    
    MoveCount = MoveCount + 1;
    
    
    BOOL levelCleared = TRUE;
    
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Core class]] && ![CurrentSubview hasCorrectRing]) levelCleared = FALSE;
        
        repeatCount++;
    }
    
    
    
    if (levelCleared) {
        
        if (TutorialMode) [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(tutorial_nextPage) userInfo: nil repeats: NO];
        else {
        
            UserWon = TRUE;
            
            
            [self allowInteraction: FALSE];
            
            
            [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(levelCleared) userInfo: nil repeats: NO];
        }
    }
    
    
    
    
}





- (void)allowInteraction:(BOOL)allow {
    AllowInteraction = allow;
    
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Core class]]) {
            [CurrentSubview allowInteraction: allow];
        }
        
        repeatCount++;
    }
}






- (void)retryLevel {
    
    // Save MoveCount because 'setUpLevelFromDictionary' function resets it to 0
    
    
    int resetMoveCount = MoveCount + 2;
    
    [self setUpLevelFromDictionary: LevelDictionary];
    
    MoveCount = resetMoveCount;
    
    
    [self setNeedsDisplay];
    
}


- (void)nextLevel {
    
    [(GameNCOIC*)NCOIC loadLevel: (CurrentLevel + 1)];
    
}


- (void)exitToMenu {
    ShowResetButton = TRUE;
    TutorialMode = FALSE;
    TutorialPage = 0;
    
    [[self subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    [(GameNCOIC*)NCOIC exitGameToMenu];
}






- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: self];
    
    CGRect touchAreaRect = CGRectMake(ExitToMenuButtonRect.origin.x - 20, ExitToMenuButtonRect.origin.y - 20, ExitToMenuButtonRect.size.width + 40, ExitToMenuButtonRect.size.height + 40);
    
    if (AllowInteraction) {
        ExitButtonSelected = CGRectContainsPoint(touchAreaRect, location);
        
        ResetButtonSelected = CGRectContainsPoint(ResetButtonRect, location);
        
        if (TutorialMode) {
            Tutorial_ShowLastPageButton_Selected = CGRectContainsPoint(ShowLastButtonRect, location);
            Tutorial_ShowNextPageButton_Selected = CGRectContainsPoint(ShowNextButtonRect, location);
        }
        
        
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBegan: touches withEvent: event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: self];
    
    CGRect touchAreaRect = CGRectMake(ExitToMenuButtonRect.origin.x - 20, ExitToMenuButtonRect.origin.y - 20, ExitToMenuButtonRect.size.width + 40, ExitToMenuButtonRect.size.height + 40);
    if (AllowInteraction && CGRectContainsPoint(touchAreaRect, location)) {
        
        
        [self allowInteraction: FALSE];
        
        GPV_NotificationWindow* notifWindow = [GPV_NotificationWindow notificationWindowForOwner: self];
        [notifWindow setNotificationMode: GPVNM_ExitToMenu];
        
        [self addSubview: notifWindow];
        [notifWindow animateIn];
        
        [HHC playUnselectionSound];
        
    }
    
    
    if (AllowInteraction && CGRectContainsPoint(ResetButtonRect, location) && ShowResetButton) {
        
        [HHC playUnselectionSound];
        
        [self retryLevel];
        if (TutorialMode && TutorialPage == 16) [self tutorial_nextPage];
    }
    
    
    if (AllowInteraction && TutorialMode && Tutorial_ShowLastPageButton && CGRectContainsPoint(ShowLastButtonRect, location)) {
        [HHC playUnselectionSound];
        [self tutorial_lastPage];
    }
    
    if (AllowInteraction && TutorialMode && Tutorial_ShowNextPageButton && CGRectContainsPoint(ShowNextButtonRect, location)) {
        [HHC playUnselectionSound];
        [self tutorial_nextPage];
    }
    
    
    ExitButtonSelected = FALSE;
    
    Tutorial_ShowLastPageButton_Selected = FALSE;
    Tutorial_ShowNextPageButton_Selected = FALSE;
    
    ResetButtonSelected = FALSE;
    
    [self setNeedsDisplay];
}









- (void)dealloc {
    
    [[self subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [LevelDictionary release];
    
    [super dealloc];
}








- (void)displayingAd:(BOOL)display {
    DisplayingAd = TRUE;
    [self setNeedsDisplay];
}







#pragma  mark - Tutorial


- (void)tutorial_lastPage {
    
    TutorialPage = TutorialPage - 1;
    [self tutorialPage: TutorialPage];
    
}

- (void)tutorial_nextPage {
    
    TutorialPage++;
    [self tutorialPage: TutorialPage];
    
    
}




- (void)loadCoreRingDifferencePage {
    CurrentLevelDifficulty = 5;
    TutorialMode = TRUE;
    TutorialPage = -1;
    
    
    NSMutableArray* coreList = [NSMutableArray array];
    
    
    
    NSArray* keys = [NSArray arrayWithObjects: LevelDictionary_CoreColor, LevelDictionary_RingColor, LevelDictionary_PositionX, LevelDictionary_PositionY, LevelDictionary_Size, nil];
    
    NSNumber* coreColor = [NSNumber numberWithInt: GPOC_Black];
    NSNumber* ringColor = [NSNumber numberWithInt: GPOC_Red];
    NSNumber* posX = [NSNumber numberWithInt: 20];
    NSNumber* posY = [NSNumber numberWithInt: 30];
    NSNumber* size = [NSNumber numberWithInt: 20];
    
    NSArray* objects = [NSArray arrayWithObjects: coreColor, ringColor, posX, posY, size, nil];
    NSDictionary* coreAlpha = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
    
    
    // Create Cores
    NSArray* keys2 = [NSArray arrayWithObjects: LevelDictionary_CoreColor, LevelDictionary_RingColor, LevelDictionary_PositionX, LevelDictionary_PositionY, LevelDictionary_Size, nil];
    
    NSNumber* coreColor2 = [NSNumber numberWithInt: GPOC_Red];
    NSNumber* ringColor2 = [NSNumber numberWithInt: GPOC_Black];
    NSNumber* posX2 = [NSNumber numberWithInt: 65];
    NSNumber* posY2 = [NSNumber numberWithInt: 65];
    NSNumber* size2 = [NSNumber numberWithInt: 20];
    
    NSArray* objects2 = [NSArray arrayWithObjects: coreColor2, ringColor2, posX2, posY2, size2, nil];
    NSDictionary* coreBravo = [NSDictionary dictionaryWithObjects: objects2 forKeys: keys2];
    
    
    [coreList addObject: coreAlpha];
    [coreList addObject: coreBravo];
    
    
    
    
    NSMutableArray* enemyList = [NSMutableArray array];
    
    
    
    NSArray* mainkeys = [NSArray arrayWithObjects: LevelDictionary_CoreList, LevelDictionary_EnemyList, nil];
    NSArray* mainobjects = [NSArray arrayWithObjects: coreList, enemyList, nil];
    
    NSDictionary* levelDict = [NSDictionary dictionaryWithObjects: mainobjects forKeys: mainkeys];
    
    
    [self setUpLevelFromDictionary: levelDict];
    
    
    // Address Memory Issues
    [levelDict release];
    
    
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Ring* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Ring class]]) [CurrentSubview setTutorialMode: TRUE];
        
        repeatCount++;
    }
    
}




- (void)loadTutorialLevel {
    CurrentLevelDifficulty = 5;
    TutorialMode = TRUE;
    
    
    NSMutableArray* coreList = [NSMutableArray array];
    
    
    // Create Cores
    NSArray* keys = [NSArray arrayWithObjects: LevelDictionary_CoreColor, LevelDictionary_RingColor, LevelDictionary_PositionX, LevelDictionary_PositionY, LevelDictionary_Size, nil];
    
    NSNumber* coreColor = [NSNumber numberWithInt: GPOC_Red];
    NSNumber* ringColor = [NSNumber numberWithInt: GPOC_Blue];
    NSNumber* posX = [NSNumber numberWithInt: 30];
    NSNumber* posY = [NSNumber numberWithInt: 30];
    NSNumber* size = [NSNumber numberWithInt: 20];
    
    NSArray* objects = [NSArray arrayWithObjects: coreColor, ringColor, posX, posY, size, nil];
    NSDictionary* coreAlpha = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
    
    
    // Create Cores
    NSArray* keys2 = [NSArray arrayWithObjects: LevelDictionary_CoreColor, LevelDictionary_RingColor, LevelDictionary_PositionX, LevelDictionary_PositionY, LevelDictionary_Size, nil];
    
    NSNumber* coreColor2 = [NSNumber numberWithInt: GPOC_Blue];
    NSNumber* ringColor2 = [NSNumber numberWithInt: GPOC_Green];
    NSNumber* posX2 = [NSNumber numberWithInt: 70];
    NSNumber* posY2 = [NSNumber numberWithInt: 50];
    NSNumber* size2 = [NSNumber numberWithInt: 20];
    
    NSArray* objects2 = [NSArray arrayWithObjects: coreColor2, ringColor2, posX2, posY2, size2, nil];
    NSDictionary* coreBravo = [NSDictionary dictionaryWithObjects: objects2 forKeys: keys2];
    
    
    
    // Create Cores
    NSArray* keys3 = [NSArray arrayWithObjects: LevelDictionary_CoreColor, LevelDictionary_RingColor, LevelDictionary_PositionX, LevelDictionary_PositionY, LevelDictionary_Size, nil];
    
    NSNumber* coreColor3 = [NSNumber numberWithInt: GPOC_Green];
    NSNumber* ringColor3 = [NSNumber numberWithInt: GPOC_Red];
    NSNumber* posX3 = [NSNumber numberWithInt: 20];
    NSNumber* posY3 = [NSNumber numberWithInt: 70];
    NSNumber* size3 = [NSNumber numberWithInt: 20];
    
    NSArray* objects3 = [NSArray arrayWithObjects: coreColor3, ringColor3, posX3, posY3, size3, nil];
    NSDictionary* coreCharlie = [NSDictionary dictionaryWithObjects: objects3 forKeys: keys3];
    
    
    [coreList addObject: coreAlpha];
    [coreList addObject: coreBravo];
    [coreList addObject: coreCharlie];
    
    
    // Create Level Dictionary
    
    NSMutableArray* enemyList = [NSMutableArray array];
    [enemyList addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: 0], [NSNumber numberWithInt: 2], nil]];  // 2 and 3 will not be able to trade
    
    
    NSArray* mainkeys = [NSArray arrayWithObjects: LevelDictionary_CoreList, LevelDictionary_EnemyList, nil];
    NSArray* mainobjects = [NSArray arrayWithObjects: coreList, enemyList, nil];
    
    NSDictionary* levelDict = [NSDictionary dictionaryWithObjects: mainobjects forKeys: mainkeys];
    
    
    [self setUpLevelFromDictionary: levelDict];
    
    
    
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Ring* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Ring class]]) [CurrentSubview setTutorialMode: TRUE];
        
        repeatCount++;
    }
    
    // Address Memory Issue
    /*
    [levelDict release];
     
     Ignore this line of code, releasing LevelDict will cause crash when the reset button is touched
     
     */
}





- (void)setTutorialText:(NSString*)text posX:(float)x posY:(float)y {
    TutorialTextXPercent = x;
    TutorialTextYPercent = y;
    TutorialDisplayText = [text retain];
    [self setNeedsDisplay];
}






- (void)beginTutorial {
    
    Tutorial_ShowLastPageButton = TRUE;
    Tutorial_ShowNextPageButton = TRUE;
    
    ShowResetButton = FALSE;
    
    
    [self loadCoreRingDifferencePage];
    
    
    
    [self setTutorialText: @"Use the Navigation\nbutton at the bottom\nof this screen to\nproceed through each\nslide" posX: 40.0 posY: 22.0];
    //[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(tutorial_nextPage) userInfo: nil repeats: NO];
    
}





- (void)continueTutorialFromCore {
    if (TutorialPage == 5) [self tutorial_nextPage];
    else if (TutorialPage == 6) [self tutorial_nextPage];
    
    else if (TutorialPage == 12) [self tutorial_nextPage];
    else if (TutorialPage == 13) [self tutorial_nextPage];
}






- (void)tutorialPage:(int)page {
    
    if (page == 0) [self setTutorialText: @"Welcome to\nDualAmNu!\nYou can exit this\ntutorial at any time\nby selecting the\nmenu button in\nthe top left corner" posX: 10.0 posY: 45.0];
    
    else if (page == 1) [self setTutorialText: @"The black center\nis called a 'Core'\nand the outer layer\nis called a 'Ring'" posX: 40.0 posY: 25.0];
    else if (page == 2) [self setTutorialText: @"The object of the game\nis to match each 'Core'\nwith its corresponding\n'Ring'" posX: 40.0 posY: 25.0];
    else if (page == 3) [self setTutorialText: @"In order to do this\nthe player must\nselect two Cores to\nexchange Rings" posX: 40.0 posY: 25.0];
    else if (page == 4) [self setTutorialText: @"The green line\ndrawn between\nthe two Cores\nmeans that the\ntwo Cores can\nperform an\nexchange" posX: 10.0 posY: 50.0];
    else if (page == 5) {
        
        int repeatCount = 0;
        NSArray* mySubviews = [self subviews];
        while (([mySubviews count]) > repeatCount) {
            
            GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
            if ([CurrentSubview isKindOfClass: [GP_Core class]] && [CurrentSubview GPObjectColor] == GPOC_Black) [CurrentSubview allowInteraction: TRUE];
            
            repeatCount++;
        }
        
        Tutorial_ShowNextPageButton = FALSE;
        [self setTutorialText: @"Select the black Core" posX: 37.0 posY: 28.0];
        
    }
    else if (page == 6) {
        
        
        int repeatCount = 0;
        NSArray* mySubviews = [self subviews];
        while (([mySubviews count]) > repeatCount) {
            
            GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
            if ([CurrentSubview isKindOfClass: [GP_Core class]] && [CurrentSubview GPObjectColor] == GPOC_Black) [CurrentSubview allowInteraction: FALSE];
            if ([CurrentSubview isKindOfClass: [GP_Core class]] && [CurrentSubview GPObjectColor] == GPOC_Red) [CurrentSubview allowInteraction: TRUE];
            
            repeatCount++;
        }
        
        
        [self setTutorialText: @"Now, select the\nred Core" posX: 10.0 posY: 60.0];
        
    }
    else if (page == 7) [self setTutorialText: @"" posX: 10.0 posY: 60.0];
    else if (page == 8) {
        
        
        [self allowInteraction: FALSE];
        AllowInteraction = TRUE;
        
        
        Tutorial_ShowNextPageButton = TRUE;
        [self setTutorialText: @"Two Cores can perform\nan exchange only one time" posX: 37.0 posY: 25.0];
        
        
        int repeatCount = 0;
        NSArray* mySubviews = [self subviews];
        while (([mySubviews count]) > repeatCount) {
            
            GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
            if ([CurrentSubview isKindOfClass: [GP_Core class]]) [CurrentSubview setSelected: FALSE];
            
            repeatCount++;
        }
        
        
    }
    else if (page == 9) [self setTutorialText: @"The red line\nindicates that\nthe Cores cannot\nexchange Rings\nagain" posX: 10.0 posY: 50.0];
    else if (page == 10) {
        
        
        Tutorial_ShowNextPageButton = FALSE;
        [self loadTutorialLevel];
        [self setTutorialText: @"" posX: 10.0 posY: 50.0];
        
        [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(tutorial_nextPage) userInfo: nil repeats: NO];
        
        
    }
    else if (page == 11) {
        Tutorial_ShowNextPageButton = TRUE;
        [self setTutorialText: @"If no line exists\nbetween two Cores,\nthey cannot\nexchange Rings" posX: 10.0 posY: 42.0];
    }
    else if (page == 12) {
        
        
        int repeatCount = 0;
        NSArray* mySubviews = [self subviews];
        while (([mySubviews count]) > repeatCount) {
            
            GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
            if ([CurrentSubview isKindOfClass: [GP_Core class]] && [CurrentSubview GPObjectColor] == GPOC_Red) [CurrentSubview allowInteraction: TRUE];
            
            repeatCount++;
        }
        
        
        Tutorial_ShowNextPageButton = FALSE;
        [self setTutorialText: @"Select the red Core" posX: 45.0 posY: 28.0];
        
    }
    else if (page == 13) {
        
        
        int repeatCount = 0;
        NSArray* mySubviews = [self subviews];
        while (([mySubviews count]) > repeatCount) {
            
            GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
            if ([CurrentSubview isKindOfClass: [GP_Core class]] && [CurrentSubview GPObjectColor] == GPOC_Red) [CurrentSubview allowInteraction: FALSE];
            if ([CurrentSubview isKindOfClass: [GP_Core class]] && [CurrentSubview GPObjectColor] == GPOC_Blue) [CurrentSubview allowInteraction: TRUE];
            
            repeatCount++;
        }
        
        
        [self setTutorialText: @"Now select the\nblue Core" posX: 10.0 posY: 45.0];
    }
    else if (page == 14) {
        
        [self allowInteraction: FALSE];
        AllowInteraction = TRUE;
        
        Tutorial_ShowNextPageButton = TRUE;
        [self setTutorialText: @"If you exchange the\nblue and green Cores,\nyou will fail this\nlevel" posX: 45.0 posY: 20.0];
        
    }
    else if (page == 15) [self setTutorialText: @"When you make a\nmistake, you can reset\nthe level and try again" posX: 45.0 posY: 22.0];
    else if (page == 16) {
        ShowResetButton = TRUE;
        Tutorial_ShowNextPageButton = FALSE;
        [self setTutorialText: @"To reset, select the\nReset button in the top\nright corner" posX: 45.0 posY: 22.0];
    }
    else if (page == 17) {
        ShowResetButton = TRUE;
        [self setTutorialText: @"Solve the level" posX: 50.0 posY: 27.0];
    }
    else if (page == 18) {
        
        ShowResetButton = FALSE;
        Tutorial_ShowNextPageButton = TRUE;
        [self allowInteraction: FALSE];
        AllowInteraction = TRUE;
        
        
        int repeatCount = 0;
        NSArray* mySubviews = [self subviews];
        while (([mySubviews count]) > repeatCount) {
            
            GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
            if ([CurrentSubview isKindOfClass: [GP_Core class]]) [CurrentSubview setSelected: FALSE];
            
            repeatCount++;
        }
        
        
        [self setTutorialText: @"That concludes this\ntutorial" posX: 45.0 posY: 25.0];
        
        
        
    }
    else if (page == 19) {
        
        Tutorial_ShowNextPageButton = FALSE;
        
        [self setTutorialText: @"Select the menu button\nin the top left corner to\nexit back to the menu" posX: 45.0 posY: 22.0];
        
    }
    
    
}














/*

 
 
 
 - (void)continueTutorialFromCore {
 if (TutorialPage == 2) [self continueTutorial3];
 else if (TutorialPage == 3) [self continueTutorial4];
 }
 
 
 

- (void)continueTutorial {
    
    AllowInteraction = TRUE;
    
    TutorialDisplayText = [@"The object of DualAmNu\nis to match each 'core'\nwith its corresponding\n'ring'" retain];
    
    
    [self setNeedsDisplay];
    
    [NSTimer scheduledTimerWithTimeInterval: 4.0 target: self selector: @selector(continueTutorial2) userInfo: nil repeats: NO];
}




- (void)continueTutorial_Amendment1 {
    
    
    //[self allowInteraction: FALSE];
    
    TutorialDisplayText = [@"The object of DualAmNu\nis to match each 'core'\nwith its corresponding\n'ring'" retain];
    
    AllowInteraction = TRUE;
    
    
    [self setNeedsDisplay];
    
    [NSTimer scheduledTimerWithTimeInterval: 4.0 target: self selector: @selector(continueTutorial2) userInfo: nil repeats: NO];
    
    
    
}




- (void)continueTutorial2 {
    
    [self allowInteraction: FALSE];
    AllowInteraction = TRUE;
    
    
    // Enable the blue core
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Core class]]) {
            if ([CurrentSubview GPObjectColor] == GPOC_Blue) [CurrentSubview allowInteraction: TRUE];
        }
        
        repeatCount++;
    }
    
    
    // Show Page 2
    TutorialPage = 2;
    TutorialDisplayText = [@"Select the Blue core..." retain];
    
    [self setNeedsDisplay];
}


- (void)continueTutorial3 {
    
    
    // Disable the blue core and enable the green core
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Core class]]) {
            if ([CurrentSubview GPObjectColor] == GPOC_Blue) [CurrentSubview allowInteraction: FALSE];
            else if ([CurrentSubview GPObjectColor] == GPOC_Green) [CurrentSubview allowInteraction: TRUE];
        }
        
        repeatCount++;
    }
    
    
    // Show Page 3
    TutorialPage = 3;
    TutorialDisplayText = [@"Now, select the Green\ncore..." retain];
    
    [self setNeedsDisplay];
}

- (void)continueTutorial4 {
    
    [self allowInteraction: FALSE];
    AllowInteraction = TRUE;
    
    // Show Page 4
    TutorialDisplayText = [@"The Green core now has\nits corresponding ring" retain];
    
    [self setNeedsDisplay];
    
    [NSTimer scheduledTimerWithTimeInterval: 4.0 target: self selector: @selector(continueTutorial5) userInfo: nil repeats: NO];
}

- (void)continueTutorial5 {
    
    //Show Page 5
    TutorialDisplayText = [@"Note that the green line\nconnecting the cores\nis now red" retain];
    
    [self setNeedsDisplay];
    
    [NSTimer scheduledTimerWithTimeInterval: 4.0 target: self selector: @selector(continueTutorial6) userInfo: nil repeats: NO];
}

- (void)continueTutorial6 {
    
    //Show Page 6
    TutorialDisplayText = [@"The red line indicates\nthat the cores cannot\nbe switched again" retain];
    
    [self setNeedsDisplay];
    
    [NSTimer scheduledTimerWithTimeInterval: 4.0 target: self selector: @selector(continueTutorial7) userInfo: nil repeats: NO];
}

- (void)continueTutorial7 {
    
    // Enable the red and blue cores
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Core class]]) {
            if ([CurrentSubview GPObjectColor] == GPOC_Blue) [CurrentSubview allowInteraction: TRUE];
            else if ([CurrentSubview GPObjectColor] == GPOC_Red) [CurrentSubview allowInteraction: TRUE];
        }
        
        repeatCount++;
    }
    
    
    //Show Page 7
    TutorialPage = 7;
    TutorialDisplayText = [@"Now, switch the red\nand blue cores..." retain];
    
    [self setNeedsDisplay];
}

- (void)continueTutorial8 {
    
    //Show Page 8
    TutorialDisplayText = [@"Each core now has\nits corresponding ring" retain];
    
    [self setNeedsDisplay];
    
    [NSTimer scheduledTimerWithTimeInterval: 4.0 target: self selector: @selector(continueTutorial9) userInfo: nil repeats: NO];
}

- (void)continueTutorial9 {
    
    [self allowInteraction: TRUE];
    
    // Enable the red and blue cores
    int repeatCount = 0;
    NSArray* mySubviews = [self subviews];
    while (([mySubviews count]) > repeatCount) {
        
        GP_Core* CurrentSubview = [mySubviews objectAtIndex: repeatCount];
        if ([CurrentSubview isKindOfClass: [GP_Core class]]) {
            [CurrentSubview allowInteraction: FALSE];
        }
        
        repeatCount++;
    }
    
    
    
    //Show Page 8
    TutorialDisplayText = [@"Select the menu button\nin the top left corner of\nthis screen to return\nto the main menu" retain];
    
    [self setNeedsDisplay];
    
    //[NSTimer scheduledTimerWithTimeInterval: 4.0 target: self selector: @selector(continueTutorial7) userInfo: nil repeats: NO];
}


*/




@end
