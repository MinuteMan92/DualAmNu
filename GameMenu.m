//
//  GameMenu.m
//  GameIdeaProto
//
//  Created by Mike Weinberg on 7/4/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import "GameMenu.h"

#import "GameNCOIC.h"









@implementation LevelPageObject

+ (LevelPageObject*)levelPageObjectWithLevel:(int)level rect:(CGRect)rect owner:(UIView*)owner {
    LevelPageObject* object = [[LevelPageObject alloc] init];
    
    [object setOwner: owner];
    [object setLevel: level];
    [object setRect: rect];
    
    [object autorelease];
    
    return object;
}


- (void)setOwner:(UIView*)owner {
    [myOwner release];
    myOwner = owner;
    [myOwner retain];
}

- (void)setLevel:(int)level {
    representedLevel = level;
    levelDifficulty = [(LevelPageView*)myOwner difficultyForLevel: level];
}
- (int)level {return representedLevel;}


- (void)setRect:(CGRect)rect {
    drawRect = rect;
}
- (CGRect)rect {return drawRect;}


- (void)drawSelf {
    
    CGRect selfRect = [self rect];
    
    int selfRectX = selfRect.origin.x;
    int selfRectY = selfRect.origin.y;
    int selfRectSize = selfRect.size.width;
    
    //int wallSize = selfRectSize / 7;
    //int wallOffset = selfRectSize - wallSize;
    
    
    if (levelDifficulty == LD_Easy) [[UIImage imageNamed: @"LevelBox_Easy.png"] drawInRect: selfRect];
    else if (levelDifficulty == LD_Medium) [[UIImage imageNamed: @"LevelBox_Medium.png"] drawInRect: selfRect];
    else if (levelDifficulty == LD_Difficult) [[UIImage imageNamed: @"LevelBox_Hard.png"] drawInRect: selfRect];
    
    
    
    BOOL levelUnlocked = [(LevelPageView*)myOwner levelUnlocked: representedLevel];
    
    // Draw Title
    
    if (levelUnlocked) {
        
        float fontSize = 20.0;
        
        NSArray* keys = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
        NSArray* objects = [NSArray arrayWithObjects: [UIFont fontWithName: @"Arial Rounded MT Bold" size: fontSize], [UIColor whiteColor], nil];
        NSDictionary* MenuTitleAttributes = [[NSDictionary dictionaryWithObjects: objects forKeys: keys] retain];
        
        int posY = ((selfRectY + (selfRectSize / 2)) - (fontSize / 2)) - 2;
        
        int posX = 0;
        if (representedLevel < 10) posX = selfRectX + 13;
        else if (representedLevel >= 10 && representedLevel < 20) posX = selfRectX + 8;
        else if (representedLevel >= 20) posX = selfRectX + 9;
    
        NSAttributedString* titleString = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%i", representedLevel] attributes: MenuTitleAttributes];
        [titleString drawAtPoint: CGPointMake(posX, posY)];
    
        
        NSLog(@"Level Page Object Draw Self");
        [titleString release];
        [MenuTitleAttributes release];
        
        
        
    }
    
    
    BOOL levelComplete = [(LevelPageView*)myOwner levelCompleted: representedLevel];
    if (levelComplete) [[UIImage imageNamed: @"CompletedCheckmark.png"] drawInRect: selfRect];
    
    if (!levelUnlocked) [[UIImage imageNamed: @"LockedLevel.png"] drawInRect: selfRect];
    
    
    
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: myOwner];
    
    
    if (CGRectContainsPoint (drawRect, location) && [(LevelPageView*)myOwner levelUnlocked: representedLevel]) {
        IsSelected = TRUE;
        
        [HHC playUnselectionSound];
        
        [(LevelPageView*)myOwner userSelectedLevel: representedLevel];
    }
    else IsSelected = FALSE;
    
}


- (void)deselect {
    IsSelected = FALSE;
}

@end







@implementation LevelPageView // View which displays a grid view of levels. Several of these views will be displayed as different pages in a UIScrollView



- (void)establishRectangleList {
    
    if (!levelObjectList) levelObjectList = [[NSMutableArray array] retain];
    
    [levelObjectList removeAllObjects];
    
    
    int repeatCount = 0;
    int currentLevel = FirstLevelNumber;
    
    int currentX = 5;
    int currentY = 20;
    
    int seperationValue = 10;
    int widthHeight = 40;
    
    NSLog(@"You");
    
    while (repeatCount <= 20) {
        
        CGRect currentRect = CGRectMake(currentX, currentY, widthHeight, widthHeight);
        
        LevelPageObject* currentObject = [LevelPageObject levelPageObjectWithLevel: currentLevel rect: currentRect owner: self];
        [levelObjectList addObject: currentObject];
        
        
        currentX = currentX + seperationValue + widthHeight;
        
        if (currentX > self.frame.size.width) {
            currentX = 5;
            currentY = currentY + seperationValue + widthHeight;
        }
        
        
        
        repeatCount++;
        
        currentLevel++;
        if (currentLevel > (LastLevelNumber + 1)) repeatCount = 21;
    }
    
    
    
    [self setNeedsDisplay];
}



- (void)setOwner:(UIView*)owner {
    
    
    [myOwner release];
    myOwner = owner;
    [myOwner retain];
}



- (void)setFirstLevel:(int)firstLN lastLevel:(int)secondLN {
    FirstLevelNumber = firstLN;
    
    // Set up a cap so there arent too many levels displayed or something
    LastLevelNumber = secondLN;
    
    
    [self establishRectangleList];
}




- (void)userSelectedLevel:(int)level {
    [(StartupMenu*)myOwner userSelectedLevel: level];
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    int repeatCount = 0;
    int objectCount = [levelObjectList count];
    
    while (repeatCount < (objectCount - 1)) {
        
        
        LevelPageObject* currentObject = [levelObjectList objectAtIndex: repeatCount];
        
        
        [currentObject touchesBegan: touches withEvent: event];
        
        repeatCount = repeatCount + 1;
        
        
    }
    
    
    [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    int repeatCount = 0;
    int objectCount = [levelObjectList count];
    
    while (repeatCount < (objectCount - 1)) {
        
        LevelPageObject* currentObject = [levelObjectList objectAtIndex: repeatCount];
        
        
        [currentObject deselect];
        
        repeatCount = repeatCount + 1;
        
        
    }
    
    
    [self setNeedsDisplay];
}




- (int)difficultyForLevel:(int)level {
    return [(StartupMenu*)myOwner difficultyForLevel: level];
}

- (BOOL)levelCompleted:(int)level {
    return [(StartupMenu*)myOwner levelCompleted: level];
}

- (BOOL)levelUnlocked:(int)level {
    return [(StartupMenu*)myOwner levelUnlocked: level];
}




- (void)drawRect:(CGRect)rect {
    
    
    int repeatCount = 0;
    int objectCount = [levelObjectList count];
    
    while (repeatCount < (objectCount - 1)) {
        
        
        LevelPageObject* currentObject = [levelObjectList objectAtIndex: repeatCount];
        
        [currentObject drawSelf];
        
        repeatCount = repeatCount + 1;
    }
    
    
    
}





- (void)dealloc {
    
    [levelObjectList removeAllObjects];
    [levelObjectList release];
    
    [super dealloc];
}


@end








@implementation StartupMenu // Menu which contains and controls buttons


- (void)establishButtonRectangles {
    
    NSLog(@"establishButtonRectangles   StartupMenu");
    
    ForLevNavEnabled = TRUE;
    BacLevNavEnabled = TRUE;
    
    
    // Replace with Images
    
    [CurrentMenuTitle release];
    CurrentMenuTitle = [[HHC appDisplayNameWithVersion: FALSE] retain];
    
    NSArray* keys = [NSArray arrayWithObjects: NSFontAttributeName, NSForegroundColorAttributeName, nil];
    NSArray* objects = [NSArray arrayWithObjects: [UIFont fontWithName: @"Arial Rounded MT Bold" size: 20.0], [UIColor whiteColor], nil];
    
    [MenuTitleAttributes release];
    MenuTitleAttributes = [[NSDictionary dictionaryWithObjects: objects forKeys: keys] retain];
    // Replace with images
    
    
    // BackButton Rectangle
    BR_BackButton = CGRectMake(15, 15, 35, 35);
    
    
    int buttonWidth = self.frame.size.width - 40;
    
    int buttonHeight = 60;
    int buttonSpacing = 20;
    
    int buttonX = (self.frame.size.width / 2) - (buttonWidth / 2);
    int currentY = 70;
    
    BR_Levels = CGRectMake(buttonX, currentY, buttonWidth, buttonHeight);
    
    currentY = currentY + buttonHeight + buttonSpacing;
    BR_About = CGRectMake(buttonX, currentY, buttonWidth, buttonHeight);
    
    currentY = currentY + buttonHeight + buttonSpacing;
    BR_Tutorial = CGRectMake(buttonX, currentY, buttonWidth, buttonHeight);
    
    currentY = currentY + buttonHeight + buttonSpacing;
    BR_Donate = CGRectMake(buttonX, currentY, buttonWidth, buttonHeight);
    
    
    
    BacLevNavRect = CGRectMake((self.frame.size.width * 0.30) - (NavigationButtonSize / 2), self.frame.size.height - (NavigationButtonSize + 23), NavigationButtonSize, NavigationButtonSize);
    ForLevNavRect = CGRectMake((self.frame.size.width * 0.70) - (NavigationButtonSize / 2), self.frame.size.height - (NavigationButtonSize + 23), NavigationButtonSize, NavigationButtonSize);
    
    
    
    //BR_BugReport = CGRectMake(buttonX, 215, buttonWidth, buttonHeight);
    BR_BugReport = BR_Donate;
    
    
    
    
    
    // Donation Buttons
    DonationButton_OneDollar = CGRectMake(BR_Tutorial.origin.x + 15, BR_Tutorial.origin.y, BR_Tutorial.size.height + 20, BR_Tutorial.size.height);
    
    DonationButton_TwoDollar = CGRectMake(self.frame.size.width - (BR_Tutorial.size.height + BR_Tutorial.origin.x + 35), BR_Tutorial.origin.y, BR_Tutorial.size.height + 20, BR_Tutorial.size.height);
    
    DonationButton_FiveDollar = CGRectMake(BR_Donate.origin.x + 15, BR_Donate.origin.y, BR_Donate.size.height + 20, BR_Donate.size.height);
    
    DonationButton_TenDollar = CGRectMake(self.frame.size.width - (BR_Donate.size.height + BR_Donate.origin.x + 35), BR_Donate.origin.y, BR_Donate.size.height + 20, BR_Donate.size.height);
    
    
    
    
    // Create Scroll view
    
    [myScrollView release];
    myScrollView = [[[UIScrollView alloc] initWithFrame: CGRectMake(15, 55, self.frame.size.width - 30, self.frame.size.height - 120)] retain];
    
    myScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    myScrollView.pagingEnabled = TRUE;
    [myScrollView setDelegate: self];
    
    // Determine the amount of pages needed
    int levelCount = [(GameNCOIC*)[(GameMenu*)MyOwner NCOIC] numberOfLevels];
    float levelCountFloat = [(GameNCOIC*)[(GameMenu*)MyOwner NCOIC] numberOfLevels];
    float pagesNeededFloat = (levelCountFloat / 20);
    int pagesNeeded = pagesNeededFloat;
    if ((pagesNeededFloat - pagesNeeded) > 0) pagesNeeded++;
    
    
    
    
    int repeatCount = 0;
    int currentFirstLevel = 1;
    int currentXPos = -10;
    int seperation = 20;
    while (repeatCount < pagesNeeded) {
        
        currentXPos = currentXPos + seperation;
        
        int LPV_Width = myScrollView.frame.size.width - 20;
        
        LevelPageView* LPV = [[LevelPageView alloc] initWithFrame: CGRectMake(currentXPos, 0, LPV_Width, myScrollView.frame.size.height)];
        
        [LPV setOwner: self];
        LPV.backgroundColor = [UIColor clearColor];
        
        
        int currentLastLevel = currentFirstLevel + 19;
        if (currentLastLevel > levelCount) currentLastLevel = levelCount;
        [LPV setFirstLevel: currentFirstLevel lastLevel: currentLastLevel];
        
        [myScrollView addSubview: LPV];
        
        
        currentXPos = currentXPos + LPV_Width;
        currentFirstLevel = currentFirstLevel + 20;
        
        repeatCount++;
    }
    
    
    
    /*
    LevelPageView* LPV_1 = [[LevelPageView alloc] initWithFrame: CGRectMake(10, 0, myScrollView.frame.size.width - 20, myScrollView.frame.size.height)];
    LPV_1.backgroundColor = [UIColor clearColor];
    [myScrollView addSubview: LPV_1];
    
    LevelPageView* LPV_2 = [[LevelPageView alloc] initWithFrame: CGRectMake(myScrollView.frame.size.width, 0, myScrollView.frame.size.width - 20, myScrollView.frame.size.height)];
    LPV_2.backgroundColor = [UIColor clearColor];
    [myScrollView addSubview: LPV_2];
    */
    
    
    
    myScrollView.contentSize = CGSizeMake((myScrollView.frame.size.width * pagesNeeded), myScrollView.frame.size.height);
    
    
}




- (id)initWithOwner:(UIView*)owner
{
    self = [super init];
    if (self) {
        
        MyOwner = owner;
        
        int sizeW = GameMenusSize_x;
        int sizeH = GameMenusSize_y;
        
        int posX = (owner.frame.size.width / 2) - (sizeW / 2);
        int posY = (owner.frame.size.height / 2) - (sizeH / 2);
        
        if (![[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) posY = posY - 25;
        
        
        self.frame = CGRectMake(posX, posY, sizeW, sizeH);
        
        self.backgroundColor = [UIColor clearColor];
        
        [self establishButtonRectangles];
        
    }
    return self;
}



- (void)userSelectedLevel:(int)level {
    NSLog(@"StartupMenu : User Selected Level %i", level);
    
    [(GameMenu*)MyOwner userSelectedLevel: level];
}



- (void)setMenuMode:(MainMenuDisplayMode)menuMode {
    MenuMode = menuMode;
    
    
    if (MenuMode != MMDM_LevelSetMenu) {
        [myScrollView removeFromSuperview];
    }
    
    
    if (MenuMode == MMDM_MainMenu) {
        CurrentMenuTitle = [HHC appDisplayNameWithVersion: FALSE];
        DisplayBackButton = FALSE;
    }
    
    else if (MenuMode == MMDM_LevelSetMenu) {
        CurrentMenuTitle = MMT_LevelSet;
        DisplayBackButton = TRUE;
        
        [self addSubview: myScrollView];
    }
    
    else if (MenuMode == MMDM_About) {
        CurrentMenuTitle = MMT_About;
        DisplayBackButton = TRUE;
    }
    
    else if (MenuMode == MMDM_Donate) {
        CurrentMenuTitle = @"Donate";
        DisplayBackButton = TRUE;
    }
    
    [self setNeedsDisplay];
}
- (MainMenuDisplayMode)menuMode {return MenuMode;}







- (void)setLevelPage:(int)page {
    
    
    int proposedOffset = (myScrollView.bounds.size.width) * page;
    
    
    if (proposedOffset >= myScrollView.contentSize.width) proposedOffset = myScrollView.contentSize.width - myScrollView.bounds.size.width;
    
    if (proposedOffset < 0) proposedOffset = 0;
    
    
    
    
    //[myScrollView setContentOffset: CGPointMake(proposedOffset, 0) animated: TRUE];
    
    // Replaced scroll view's built in operation with the UIView animation function because the scroll view doesn't work as intended on live devices
    [UIView animateWithDuration:.25 animations:^{
        myScrollView.contentOffset = CGPointMake(proposedOffset, 0);
    }];
    
    
    
    [self setNeedsDisplay];
}


- (int)currentLevelPage {
    return myScrollView.contentOffset.x / (myScrollView.bounds.size.width);
}


- (int)difficultyForLevel:(int)level {
    return [(GameMenu*)MyOwner difficultyForLevel: level];
}

- (BOOL)levelCompleted:(int)level {
    return [(GameMenu*)MyOwner levelCompleted: level];
}

- (BOOL)levelUnlocked:(int)level {
    return [(GameMenu*)MyOwner levelUnlocked: level];
}




- (void)levelPageObjectsNeedUpdating {
    LevelPageViewDrawnToDate = FALSE;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: self];
    
    
    // Only consider Back Button if in anything other than MainMenu mode
    if (MenuMode != MMDM_MainMenu) {
        BackButtonSelected = CGRectContainsPoint(BR_BackButton, location);
    }
    
    
    if (MenuMode == MMDM_MainMenu) {
        BS_Levels = CGRectContainsPoint (BR_Levels, location);
        BS_Donate = CGRectContainsPoint (BR_Donate, location);
        BS_About = CGRectContainsPoint (BR_About, location);
        BS_Tutorial = CGRectContainsPoint (BR_Tutorial, location);
    }
    
    if (MenuMode == MMDM_About) {
        BugReportButtonSelected = CGRectContainsPoint (BR_BugReport, location);
    }
    
    
    if (MenuMode == MMDM_Donate) {
        DonationButton_OneDollar_Selected = CGRectContainsPoint (DonationButton_OneDollar, location);
        DonationButton_TwoDollar_Selected = CGRectContainsPoint (DonationButton_TwoDollar, location);
        DonationButton_FiveDollar_Selected = CGRectContainsPoint (DonationButton_FiveDollar, location);
        DonationButton_TenDollar_Selected = CGRectContainsPoint (DonationButton_TenDollar, location);
    }
    
    
    if (MenuMode == MMDM_LevelSetMenu) {
        
        if (BacLevNavEnabled) BacLevNavSelected = CGRectContainsPoint (BacLevNavRect, location);
        if (ForLevNavEnabled) ForLevNavSelected = CGRectContainsPoint (ForLevNavRect, location);
        
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBegan: touches withEvent: event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: self];
    
    
    BOOL playSound = FALSE;
    
    
    if (MenuMode == MMDM_MainMenu) {
        if (CGRectContainsPoint (BR_Levels, location)) {
            playSound = TRUE;
            [self setMenuMode: MMDM_LevelSetMenu];
        }
        else if (CGRectContainsPoint (BR_About, location)) {
            playSound = TRUE;
            [self setMenuMode: MMDM_About];
        }
        else if (CGRectContainsPoint(BR_Donate, location)) {
            /*
            playSound = TRUE;
            
            
            //[self setMenuMode: MMDM_Donate];
            
            NSURL *url = [ [ NSURL alloc ] initWithString: @"https://mobile.paypal.com/us/cgi-bin/webscr?cmd=_express-checkout-mobile&useraction=commit&token=EC-006650850R759114Y#m" ];
            [[UIApplication sharedApplication] openURL:url];
            */
            
            // Donation feature has been removed until further notice
            
        }
        else if (CGRectContainsPoint(BR_Tutorial, location)) {
            playSound = TRUE;
            [(GameMenu*)MyOwner userSelectedTutorial];
        }
        
        BS_Levels = FALSE;
        BS_Donate = FALSE;
        BS_About = FALSE;
        BS_Tutorial = FALSE;
        
    }
    else if (MenuMode == MMDM_LevelSetMenu) {
        
        if (CGRectContainsPoint (BR_BackButton, location)) {
            playSound = TRUE;
            [self setMenuMode: MMDM_MainMenu];
        }
        
        if (BacLevNavEnabled && CGRectContainsPoint (BacLevNavRect, location)) {
            playSound = TRUE;
            [self setLevelPage: [self currentLevelPage] - 1];
        }
        
        if (ForLevNavEnabled && CGRectContainsPoint(ForLevNavRect, location)) {
            
            playSound = TRUE;
            [self setLevelPage: [self currentLevelPage] + 1];
        }
        
        BacLevNavSelected = FALSE;
        ForLevNavSelected = FALSE;
        BackButtonSelected = FALSE;
    }
    else if (MenuMode == MMDM_About) {
        if (CGRectContainsPoint (BR_BugReport, location)) {
            
            NSLog(@"Bug Reporting");
            
            playSound = TRUE;
            [(GameMenu*)MyOwner userSelectedBugReport];
        }
        else if (CGRectContainsPoint (BR_BackButton, location)) {
            playSound = TRUE;
            [self setMenuMode: MMDM_MainMenu];
        }
        
        BugReportButtonSelected = FALSE;
        BackButtonSelected = FALSE;
    }
    else if (MenuMode == MMDM_Donate) {
        
        if (CGRectContainsPoint (BR_BackButton, location)) {
            playSound = TRUE;
            [self setMenuMode: MMDM_MainMenu];
        }
        else if (CGRectContainsPoint(DonationButton_OneDollar, location)) {
            playSound = TRUE;
            [(GameMenu*)MyOwner userSelectedDonate: @"1.00"];
        }
        else if (CGRectContainsPoint(DonationButton_TwoDollar, location)) {
            playSound = TRUE;
            [(GameMenu*)MyOwner userSelectedDonate: @"2.00"];
        }
        else if (CGRectContainsPoint(DonationButton_FiveDollar, location)) {
            playSound = TRUE;
            [(GameMenu*)MyOwner userSelectedDonate: @"5.00"];
        }
        else if (CGRectContainsPoint(DonationButton_TenDollar, location)) {
            playSound = TRUE;
            [(GameMenu*)MyOwner userSelectedDonate: @"10.00"];
        }
        
        
        BackButtonSelected = FALSE;
        
        DonationButton_OneDollar_Selected = FALSE;
        DonationButton_TwoDollar_Selected = FALSE;
        DonationButton_FiveDollar_Selected = FALSE;
        DonationButton_TenDollar_Selected = FALSE;
    }
    
    
    if (playSound) [HHC playSelectionSound];
    
    
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
    
    
    
    
    
    // Draw Title
    NSAttributedString* titleString = [[NSAttributedString alloc] initWithString: CurrentMenuTitle attributes: MenuTitleAttributes];
    [titleString drawAtPoint: CGPointMake(60, 20)];
    
    [titleString release];
    
    
    
    // Draw Back Button
    if (DisplayBackButton) {
        
        
        UIImage* MenuImage = nil;
        if (BackButtonSelected) MenuImage = [UIImage imageNamed: @"BackToMenuButtonDown.png"];
        else MenuImage = [UIImage imageNamed: @"BackToMenuButtonUp.png"];
        
        
        [MenuImage drawInRect: BR_BackButton];
    }
    
    
    
    int labelOffset = 20;
    
    
    
    
    if (MenuMode == MMDM_MainMenu) {
        
        
        // Rearrange the order of these lines of code to rearrange buttons on startup menu
        
        
        // Levels Button
        [HHC drawButtonWithiPhoneRect: BR_Levels iPadRect: BR_Levels label: MMBT_Levels labelPosition: CGPointMake(BR_Levels.origin.x + labelOffset, BR_Levels.origin.y + ((BR_Levels.size.height / 2) - 12)) selected: BS_Levels context: context];
        
        
        // Tutorial Button
        [HHC drawButtonWithiPhoneRect: BR_Tutorial iPadRect: BR_Tutorial label: MMBT_Tutorial labelPosition: CGPointMake(BR_Tutorial.origin.x + labelOffset, BR_Tutorial.origin.y + ((BR_Tutorial.size.height / 2) - 12)) selected: BS_Tutorial context: context];
        
        
        // About Button
        [HHC drawButtonWithiPhoneRect: BR_About iPadRect: BR_About label: MMBT_About labelPosition: CGPointMake(BR_About.origin.x + labelOffset, BR_About.origin.y + ((BR_About.size.height / 2) - 12)) selected: BS_About context: context];
        
        
        // Donate Button
        [HHC drawButtonWithiPhoneRect: BR_Donate iPadRect: BR_Donate label: MMBT_Donate labelPosition: CGPointMake(BR_Donate.origin.x + labelOffset, BR_Donate.origin.y + ((BR_Donate.size.height / 2) - 12)) selected: BS_Donate context: context];
        
        
    }
    
    
    
    
    if (MenuMode == MMDM_LevelSetMenu) {
        
        
        /*
        if ([self currentLevelPage] == 0) BacLevNavEnabled = FALSE;
        else BacLevNavEnabled = TRUE;
        
        
        int page = [self currentLevelPage];
        int proposedOffset = (myScrollView.bounds.size.width) * page;
        if (proposedOffset >= myScrollView.contentSize.width) proposedOffset = myScrollView.contentSize.width - myScrollView.bounds.size.width;
        
        if (proposedOffset < 0) ForLevNavEnabled = TRUE;
        else ForLevNavEnabled = FALSE;
        */
        
        
        if (ForLevNavEnabled) {
             if (ForLevNavSelected) [[UIImage imageNamed: @"NavArrowRight_Sel.png"] drawInRect: ForLevNavRect];
             else [[UIImage imageNamed: @"NavArrowRight.png"] drawInRect: ForLevNavRect];
        }
        
        if (BacLevNavEnabled) {
            if (BacLevNavSelected) [[UIImage imageNamed: @"NavArrowLeft_Sel.png"] drawInRect: BacLevNavRect];
            else [[UIImage imageNamed: @"NavArrowLeft.png"] drawInRect: BacLevNavRect];
        }



        
        // TODO: Come up with different lock image to avoid copyright issues

        
    }
    
    
    
    
    
    
    
    if (MenuMode == MMDM_About) {
        
        
        int posX = BR_Levels.origin.x + labelOffset;
        
        
        NSAttributedString* titleAndVersion = [HHC gameCommonAttributedString: [HHC appDisplayNameWithVersion: TRUE] withFontSize: 22.0];
        [titleAndVersion drawAtPoint: CGPointMake(posX, 80)];
        
        
        
        
        int soundLineY = 150;
        NSAttributedString* soundLine1 = [HHC gameCommonAttributedString: @"Developed by" withFontSize: 13.0];
        [soundLine1 drawAtPoint: CGPointMake(posX, soundLineY)];
        
        
        UIImage* wsLogo = [UIImage imageNamed: @"WSLogoText.png"];
        [wsLogo drawInRect: CGRectMake(posX, 175, 162, 50)];
        
        
        
        [HHC drawButtonWithiPhoneRect: BR_BugReport iPadRect: BR_BugReport label: @"report a bug" labelPosition: CGPointMake(BR_BugReport.origin.x + labelOffset, BR_BugReport.origin.y + ((BR_BugReport.size.height / 2) - 12)) selected: BugReportButtonSelected context: context];
        
        
    }
    
    
    
    /*
    if (MenuMode == MMDM_Donate) {
        
        int posX = BR_Levels.origin.x + labelOffset;
        
        
        int soundLineY = 100;
        NSAttributedString* soundLine1 = [HHC gameCommonAttributedString: @"Donate to" withFontSize: 13.0];
        [soundLine1 drawAtPoint: CGPointMake(posX, soundLineY)];
        
        
        // Weinberg Software Logo
        UIImage* wsLogo = [UIImage imageNamed: @"WSLogoText.png"];
        [wsLogo drawInRect: CGRectMake(posX, 125, 162, 50)];
        
        
        
        
        [HHC drawButtonWithiPhoneRect: DonationButton_OneDollar iPadRect: DonationButton_OneDollar label: @"$1" labelPosition: CGPointMake(DonationButton_OneDollar.origin.x + labelOffset + 7, DonationButton_OneDollar.origin.y + ((DonationButton_OneDollar.size.height / 2) - 12)) selected: DonationButton_OneDollar_Selected context: context];
        
        [HHC drawButtonWithiPhoneRect: DonationButton_TwoDollar iPadRect: DonationButton_TwoDollar label: @"$2" labelPosition: CGPointMake(DonationButton_TwoDollar.origin.x + labelOffset + 7, DonationButton_TwoDollar.origin.y + ((DonationButton_TwoDollar.size.height / 2) - 12)) selected: DonationButton_TwoDollar_Selected context: context];
        
        [HHC drawButtonWithiPhoneRect: DonationButton_FiveDollar iPadRect: DonationButton_FiveDollar label: @"$5" labelPosition: CGPointMake(DonationButton_FiveDollar.origin.x + labelOffset + 7, DonationButton_FiveDollar.origin.y + ((DonationButton_FiveDollar.size.height / 2) - 12)) selected: DonationButton_FiveDollar_Selected context: context];
        
        [HHC drawButtonWithiPhoneRect: DonationButton_TenDollar iPadRect: DonationButton_TenDollar label: @"$10" labelPosition: CGPointMake(DonationButton_TenDollar.origin.x + labelOffset, DonationButton_TenDollar.origin.y + ((DonationButton_TenDollar.size.height / 2) - 12)) selected: DonationButton_TenDollar_Selected context: context];
        
        
        // Below commented out
        [HHC drawButtonWithiPhoneRect: BR_Tutorial iPadRect: BR_Tutorial label: @"donate     $1.00" labelPosition: CGPointMake(BR_Tutorial.origin.x + labelOffset, BR_Tutorial.origin.y + ((BR_Tutorial.size.height / 2) - 12)) selected: BugReportButtonSelected context: context];
     
    }
    */
    
    
    if (!LevelPageViewDrawnToDate) {
        LevelPageViewDrawnToDate = TRUE;
        LevelPageView* subordinateObject = [[myScrollView subviews] objectAtIndex: 0];
        [subordinateObject setNeedsDisplay];
    }
    
}






@end









@implementation GameMenuAnimObject


+ (GameMenuAnimObject*)newGameMenuObjectWithSuperview:(UIView*)superview {
    
    GameMenuAnimObject* newObject = [[GameMenuAnimObject alloc] init];
    
    
    [newObject setSuperview: superview];
    [newObject randomize];
    
    
    return newObject;
}




- (void)randomize {
    
    int posX = 0;
    int posY = 0;
    
    int width = [HHC randomNumberBetweenZeroAnd: 20];
    if (width < 5) width = 5;
    
    int length = [HHC randomNumberBetweenZeroAnd: 500];
    if (length < 100) length = 100;
    if ([[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) length = length * 3;
    if (length > 700) length = 700;
    
    
    int speed = [HHC randomNumberBetweenZeroAnd: 600];
    speed = speed / 100;
    if (speed < 2) speed = 2.0;
    
    GameMenuAnimDirection direction = [HHC randomNumberBetweenZeroAnd: 3];
    
    
    if (direction == AnimationDirection_TopBottom) {
        posX = [HHC randomNumberBetweenZeroAnd: My_Superview.frame.size.width];
        if (posX == 0) posX = 1;
        if (posX >= My_Superview.frame.size.width) posX = My_Superview.frame.size.width - 1;
        
        posY = 0;
    }
    else if (direction == AnimationDirection_BottomTop) {
        posX = [HHC randomNumberBetweenZeroAnd: My_Superview.frame.size.width];
        if (posX == 0) posX = 1;
        if (posX >= My_Superview.frame.size.width) posX = My_Superview.frame.size.width - 1;
        
        posY = My_Superview.frame.size.height;
    }
    else if (direction == AnimationDirection_LeftRight) {
        posY = [HHC randomNumberBetweenZeroAnd: My_Superview.frame.size.height];
        if (posY == 0) posY = 1;
        if (posY >= My_Superview.frame.size.height) posY = My_Superview.frame.size.height - 1;
        
        posX = 0;
    }
    else if (direction == AnimationDirection_RightLeft) {
        posY = [HHC randomNumberBetweenZeroAnd: My_Superview.frame.size.height];
        if (posY == 0) posY = 1;
        if (posY >= My_Superview.frame.size.height) posY = My_Superview.frame.size.height - 1;
        
        posX = My_Superview.frame.size.width;
    }
    
    
    
    [self setPositionX: posX positionY: posY length: length width: width direction: direction speed: speed];
    
    
    
    UIColor* color = [UIColor blueColor];
    
    int randColor = [HHC randomNumberBetweenZeroAnd: 9];
    if (randColor == GPOC_Red) color = [UIColor redColor];
    else if (randColor == GPOC_Orange) color = [UIColor orangeColor];
    else if (randColor == GPOC_Yellow) color = [UIColor yellowColor];
    else if (randColor == GPOC_Green) color = [UIColor greenColor];
    // Blue is already created above
    else if (randColor == GPOC_Purple) color = [UIColor purpleColor];
    else if (randColor == GPOC_Pink) color = [UIColor cyanColor];
    else if (randColor == GPOC_Gray) color = [UIColor grayColor];
    else if (randColor == GPOC_Black) color = [UIColor darkGrayColor];
    else if (randColor == GPOC_White) color = [UIColor whiteColor];
    
    
    [self setDrawColor: color];
    
    [color release];
    
}





- (void)setSuperview:(UIView*)superview {
    
    NSLog(@"SetSuperview:   in GameMenuAnimObject");
    
    [My_Superview release];
    My_Superview = superview;
    [My_Superview retain];
}


- (void)setDrawColor:(UIColor*)color {
    
    NSLog(@"setDrawColor:   in GameMenuAnimObject");
    
    [DrawColor release];
    DrawColor = color;
    [DrawColor retain];
}


- (void)setPositionX:(int)x positionY:(int)y length:(int)length width:(int)width direction:(GameMenuAnimDirection)direction speed:(int)speed {
    Pos_x = x;
    Pos_y = y;
    
    Length = length;
    Width = width;
    
    Speed = speed;
    
    MoveDirection = direction;
}



- (BOOL)withinSuperviewRectangle {
    
    CGRect SuperviewRect = My_Superview.frame;
    
    CGPoint pointA;
    CGPoint pointB;
    
    if (MoveDirection == AnimationDirection_TopBottom) {
        pointA = CGPointMake(Pos_x, Pos_y);
        pointB = CGPointMake(Pos_x, Pos_y - Length);
    }
    else if (MoveDirection == AnimationDirection_BottomTop) {
        pointA = CGPointMake(Pos_x, Pos_y);
        pointB = CGPointMake(Pos_x, Pos_y + Length);
    }
    else if (MoveDirection == AnimationDirection_LeftRight) {
        pointA = CGPointMake(Pos_x, Pos_y);
        pointB = CGPointMake(Pos_x - Length, Pos_y);
    }
    else if (MoveDirection == AnimationDirection_RightLeft) {
        pointA = CGPointMake(Pos_x, Pos_y);
        pointB = CGPointMake(Pos_x + Length, Pos_y);
    }
    
    
    BOOL ReturnValue = FALSE;
    
    
    if (Length > SuperviewRect.size.height || Length > SuperviewRect.size.width) {
        CGPoint midPoint = CGPointMake((pointA.x + pointB.x) / 2, (pointA.y + pointB.y) / 2);
        if (CGRectContainsPoint(SuperviewRect, midPoint)) ReturnValue = TRUE;
    }
    
    
    if (CGRectContainsPoint(SuperviewRect, pointA)) ReturnValue = TRUE;
    if (CGRectContainsPoint(SuperviewRect, pointB)) ReturnValue = TRUE;
    
    return ReturnValue;
}




- (void)update {
    
    
    if (MoveDirection == AnimationDirection_TopBottom) {
        Pos_y = Pos_y + Speed;
    }
    if (MoveDirection == AnimationDirection_BottomTop) {
        Pos_y = Pos_y - Speed;
    }
    if (MoveDirection == AnimationDirection_LeftRight) {
        Pos_x = Pos_x + Speed;
    }
    if (MoveDirection == AnimationDirection_RightLeft) {
        Pos_x = Pos_x - Speed;
    }
    
    
    if (![self withinSuperviewRectangle]) [self randomize];
}

- (void)drawCurrentFrame:(CGContextRef)context {
    
    
    if (MoveDirection == AnimationDirection_TopBottom) {
        
        
        CGContextMoveToPoint(context, Pos_x, Pos_y); //start at this point
        CGContextAddLineToPoint(context, Pos_x, Pos_y - Length); //draw to this point
        
        
    }
    if (MoveDirection == AnimationDirection_BottomTop) {
        
        
        CGContextMoveToPoint(context, Pos_x, Pos_y); //start at this point
        CGContextAddLineToPoint(context, Pos_x, Pos_y + Length); //draw to this point
        
        
    }
    if (MoveDirection == AnimationDirection_LeftRight) {
        
        CGContextMoveToPoint(context, Pos_x, Pos_y); //start at this point
        CGContextAddLineToPoint(context, Pos_x - Length, Pos_y); //draw to this point
        
    }
    if (MoveDirection == AnimationDirection_RightLeft) {
        
        CGContextMoveToPoint(context, Pos_x, Pos_y); //start at this point
        CGContextAddLineToPoint(context, Pos_x + Length, Pos_y); //draw to this point
        
    }
    
    
    if (!DrawColor) DrawColor = [UIColor blueColor];
    
    
    CGContextSetLineWidth(context, Width);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, DrawColor.CGColor);
    
    CGContextStrokePath(context);
    
}

@end






@implementation GameMenu  // Bottom most layer of the game menu. Animations in the background

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}





/*

- (int)randomNumberBetweenZeroAnd:(int)numba {
    FILE *fp = fopen("/dev/random", "r");
    uint64_t value = fgetc(fp);
    fclose(fp);
    return ((value * numba) / 255);
}

*/













- (void)beginGameWithNCOIC:(id)ncoic {
    
    [MyNCOIC release];
    MyNCOIC = ncoic;
    [MyNCOIC retain];
    
    
    self.backgroundColor = [UIColor blackColor];
    
    
    [MyStartUpMenu release];
    MyStartUpMenu = [[[StartupMenu alloc] initWithOwner: self] retain];
    
    [self addSubview: MyStartUpMenu];
    
    
    [self beginAnimation];
}





#pragma mark Animation Methods


// Override setHidden: to automatically pause and resume animation
- (void)setHidden:(BOOL)hidden {
    
    if (hidden) [self pauseAnimation];
    else if (!hidden) [self resumeAnimation];
    
    [super setHidden: hidden];
}



- (void)beginAnimation { // Initialize and Fire the AnimationTimer, Initialize AnimObjects
    NSLog(@"Began Animation");
    
    ContinueAnimation = TRUE;
    AnimationTimer = [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector(updateAnimation) userInfo: nil repeats: TRUE];
    
    
    if (!AnimObject1) AnimObject1 = [GameMenuAnimObject newGameMenuObjectWithSuperview: self];
    if (!AnimObject2) AnimObject2 = [GameMenuAnimObject newGameMenuObjectWithSuperview: self];
    if (!AnimObject3) AnimObject3 = [GameMenuAnimObject newGameMenuObjectWithSuperview: self];
    if (!AnimObject4) AnimObject4 = [GameMenuAnimObject newGameMenuObjectWithSuperview: self];
    
    
}


- (void)updateAnimation { // Tell AnimObjects to update to a new frame, then draw
    if (ContinueAnimation) {
        
        
        [AnimObject1 update];
        [AnimObject2 update];
        [AnimObject3 update];
        [AnimObject4 update];
        
        
        
        [self setNeedsDisplay];
    }
}


- (void)resumeAnimation { // Resume Animations from a paused state, such as when the user returns to the menu
    ContinueAnimation = TRUE;
}

- (void)pauseAnimation { // Pause Animations, such as when the user begins a game
    ContinueAnimation = FALSE;
}







#pragma mark LevelBox to GameNCOIC Communication

- (id)NCOIC {
    return MyNCOIC;
}

- (int)difficultyForLevel:(int)level {
    return [MyNCOIC difficultyForLevel: level];
}

- (BOOL)levelCompleted:(int)level {
    return [MyNCOIC levelCompleted: level];
}

- (BOOL)levelUnlocked:(int)level {
    return [MyNCOIC levelUnlocked: level];
}



- (void)userSelectedLevel:(int)level {
    [(GameNCOIC*)MyNCOIC loadLevel: level];
}


- (void)userSelectedTutorial {
    [(GameNCOIC*)MyNCOIC launchTutorial];
}


- (void)userSelectedDonate:(NSString*)amount; {
    [(GameNCOIC*)MyNCOIC pay: amount];
}


- (void)userSelectedBugReport {
    [(GameNCOIC*)MyNCOIC beginBugReport];
}




- (void)levelPageObjectsNeedUpdating {
    [MyStartUpMenu levelPageObjectsNeedUpdating];
}





- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    [AnimObject1 drawCurrentFrame: context];
    [AnimObject2 drawCurrentFrame: context];
    [AnimObject3 drawCurrentFrame: context];
    [AnimObject4 drawCurrentFrame: context];
    
    
    
    
    [MyStartUpMenu setNeedsDisplay];
}








- (void)dealloc {
    
    [super dealloc];
}


@end
