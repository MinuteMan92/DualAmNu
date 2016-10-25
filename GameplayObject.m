//
//  GameplayObject.m
//  GameIdeaProto
//
//  Created by Mike Weinberg on 6/30/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import "GameplayObject.h"

#import "GamePlayView.h"





@implementation GP_Ring



+ (GP_Ring*)ringWithColor:(GameplayObjectColor)objColor birthed:(BOOL)birthed {
    GP_Ring* newRing = [[GP_Ring alloc] init];
    
    [newRing setGPObjectColor: objColor];
    [newRing setBirth: birthed animate: FALSE];
    [newRing setBackgroundColor: [UIColor clearColor]];
    
    return newRing;
}





- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [MyCore touchesBegan: touches withEvent: event];
}




- (void)setTutorialMode:(BOOL)mode {
    TutorialMode = mode;
}




- (void)setGPObjectColor:(GameplayObjectColor)color {
    MyObjColor = color;
    
    RingImage = nil;
    
    
    
    /*
     GPOC_Red = 0,
     GPOC_Orange  = 1,
     GPOC_Yellow  = 2,
     GPOC_Green  = 3,
     GPOC_Blue  = 4,
     
     GPOC_Purple  = 5,
     GPOC_Pink  = 6,
     GPOC_Gray  = 7,
     GPOC_Black  = 8,
     GPOC_White = 9,
     */
    
    
    if (MyObjColor == GPOC_Red) RingImage = [UIImage imageNamed: @"Ring_Red"];
    else if (MyObjColor == GPOC_Orange) RingImage = [UIImage imageNamed: @"Ring_Orange"];
    else if (MyObjColor == GPOC_Yellow) RingImage = [UIImage imageNamed: @"Ring_Yellow"];
    else if (MyObjColor == GPOC_Green) RingImage = [UIImage imageNamed: @"Ring_Green"];
    else if (MyObjColor == GPOC_Blue) RingImage = [UIImage imageNamed: @"Ring_Blue.png"];
    else if (color == GPOC_Purple) RingImage = [UIImage imageNamed: @"Ring_Purple.png"];
    else if (color == GPOC_Gray) RingImage = [UIImage imageNamed: @"Ring_Gray.png"];
    else if (color == GPOC_Black) RingImage = [UIImage imageNamed: @"Ring_Black.png"];
    else if (color == GPOC_White) RingImage = [UIImage imageNamed: @"Ring_White.png"];
    
    
    
    
    RingImage = [RingImage retain];
    
    [self setNeedsDisplay];
}
- (GameplayObjectColor)GPObjectColor {return MyObjColor;}




- (int)scaleFromCore {
    int coreScale = MyCore.frame.size.width;
    return (coreScale + (coreScale / 4));
}




- (void)moveToCore:(UIView*)core animate:(BOOL)animate; {
    
    MyCore = nil;
    
    
    MyCore = core;
    
    
    
    if (animate) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if (Birthed) {
                int myNewScale = [self scaleFromCore];
                self.frame = CGRectMake(self.center.x - ([self scaleFromCore] / 2), self.center.y - ([self scaleFromCore] / 2), myNewScale, myNewScale);
            }
            
            self.center = MyCore.center;
        }];
    }
    else {
        if (Birthed) {
            int myNewScale = [self scaleFromCore];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, myNewScale, myNewScale);
        }
        self.center = MyCore.center;
    }
    
    
    
    [self setNeedsDisplay];
}



- (void)setBirth:(BOOL)isBirthed animate:(BOOL)animate {
    Birthed = isBirthed;
    
    if (animate && Birthed) {
        
        if (Birthed && MyCore) {
            self.center = MyCore.center;
            [UIView animateWithDuration: 0.6 animations:^{
                self.frame = CGRectMake(MyCore.center.x - ([self scaleFromCore] / 2), MyCore.center.y - ([self scaleFromCore] / 2), [self scaleFromCore], [self scaleFromCore]);
                self.center = MyCore.center;
            }completion:^(BOOL finished){
                
                if (!TutorialMode) [(GP_Core*)MyCore allowInteraction: TRUE];
                
            }];
        }
    }
    
    
    
    if (!animate) {
        
        
        if (Birthed && MyCore) {
            self.frame = CGRectMake(0, 0, [self scaleFromCore], [self scaleFromCore]);
            self.center = MyCore.center;
        }
        else if (!Birthed) {
            CGPoint myCenter = self.center;
            self.frame = CGRectMake(myCenter.x, myCenter.y, MyCore.frame.size.width, MyCore.frame.size.width);
            self.center = myCenter;
        }
        
        
        
        [self setNeedsDisplay];
    }
}
- (BOOL)isBirthed {return Birthed;}





- (void)drawRect:(CGRect)rect {
    
    [RingImage drawInRect: CGRectMake(rect.origin.x + 1, rect.origin.y + 1, rect.size.width - 2, rect.size.width - 2)];
    
}




- (void)dealloc {
    
    [RingImage release];
    
    [super dealloc];
}


@end



@implementation GP_Core



+ (GP_Core*)coreWithColor:(GameplayObjectColor)objColor {
    GP_Core* newCore = [[GP_Core alloc] init];
    
    [newCore beginSetup];
    
    [newCore setGPObjectColor: objColor];
    
    
    return newCore;
}



- (void)beginSetup {
    
    IsSelected = FALSE;
    
    CoresTradedWith = [[NSMutableArray array] retain];
    EmbargoList = [[NSMutableArray array] retain];
    
    self.frame = CGRectMake(0, 0, 300, 300);
    
    [self setBackgroundColor: [UIColor clearColor]];
    
    CoreSelected = [[UIImage imageNamed: @"Core_Selected.png"] retain];
    
}



- (void)allowInteraction:(BOOL)allow {
    AllowInteraction = allow;
}




- (BOOL)hasCorrectRing {
    if ([MyRing GPObjectColor] == MyObjColor) return TRUE;
    return FALSE;
}





- (void)animateMatch {
    
    
    // TODO: Match Animation?
    
    
}





- (void)setSizeScale:(int)scale {
    SizeScale = scale;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scale, scale);
    
    [self setNeedsDisplay];
}
- (int)sizeScale {return SizeScale;}






- (void)setSelected:(BOOL)selected {
    IsSelected = selected;
    
    
    
    if (IsSelected) {
        
        PlaySelectedSound = TRUE;
    
        NSArray* super_subviews = [[self superview] subviews];
        
        
        int repeatCount = 0;
        while (([super_subviews count]) > repeatCount) {
            
            id CurrentSubview = [super_subviews objectAtIndex: repeatCount];
            
            IsDominant = TRUE;
            
            if ([CurrentSubview isKindOfClass: [GP_Core class]] && CurrentSubview != self && [CurrentSubview isSelected]) {
                
                
                if ([self Query_TradedWithCore: CurrentSubview]) {
                    
                    // Reject trade
                    
                    
                    IsSelected = FALSE;
                    IsDominant = FALSE;
                    
                    PlaySelectedSound = FALSE;
                    PlayRejectionSound = TRUE;
                    
                    [self animateRejection];
                    [CurrentSubview animateRejection];
                    
                    [CurrentSubview setSelected: FALSE];
                    
                }
                else {
                    
                    GP_Ring* myNewRing = [CurrentSubview ring];
                    
                    IsSelected = FALSE;
                    
                    [CurrentSubview setRingObject: MyRing fromCore: self];
                    [CurrentSubview setSelected: FALSE];
                    
                    IsDominant = FALSE;
                    PlaySelectedSound = FALSE;
                    
                    [self setRingObject: myNewRing fromCore: CurrentSubview];
                    
                    
                }
                
                
                
            }
            repeatCount = repeatCount + 1;
        }
    
        
        
    }
    else {
        
        IsDominant = FALSE;
        
        PlayUnselectedSound = TRUE;
        
    }
    
    
    
    
    
    [self setNeedsDisplay];
}
- (BOOL)isSelected {return IsSelected;}



- (void)setGPObjectColor:(GameplayObjectColor)color {
    MyObjColor = color;
    
    CoreImage = nil;
    
    
    
    if (color == GPOC_Red) CoreImage = [UIImage imageNamed: @"Core_Red.png"];
    else if (color == GPOC_Orange) CoreImage = [UIImage imageNamed: @"Core_Orange.png"];
    else if (color == GPOC_Yellow) CoreImage = [UIImage imageNamed: @"Core_Yellow.png"];
    else if (color == GPOC_Green) CoreImage = [UIImage imageNamed: @"Core_Green.png"];
    else if (color == GPOC_Blue) CoreImage = [UIImage imageNamed: @"Core_Blue.png"];
    else if (color == GPOC_Purple) CoreImage = [UIImage imageNamed: @"Core_Purple.png"];
    else if (color == GPOC_Gray) CoreImage = [UIImage imageNamed: @"Core_Gray.png"];
    else if (color == GPOC_Black) CoreImage = [UIImage imageNamed: @"Core_Black.png"];
    else if (color == GPOC_White) CoreImage = [UIImage imageNamed: @"Core_White.png"];
    
    
    
    
    CoreImage = [CoreImage retain];
    
    
    [self setNeedsDisplay];
}
- (GameplayObjectColor)GPObjectColor {return MyObjColor;}




- (void)setRingObject:(GP_Ring*)myRing fromCore:(GP_Core*)core {
    
    
    
    
    // Animations play if core is not nil
    
    [[self superview] setNeedsDisplay];
    
    
    MyRing = myRing;
    
    BOOL animate = TRUE;
    if (!core) animate = FALSE;
    
    if (!IsDominant && animate) [HHC playSwitchSound];
    [MyRing moveToCore: self animate: animate];
    
    if (core) [CoresTradedWith addObject: core];
    
    
    
    if ([self hasCorrectRing] && core) {
        
        [self animateMatch];
        
    }
    
    
    if (!IsDominant) [(GamePlayView*)[self superview] testCoresForMatch];   // It has to be the non-dominant ring because it is the last core to receive its ring during a switch
    
    //[[self superview] setNeedsDisplay];
    
    
    
}
- (GP_Ring*)ring {return MyRing;}









- (void)addEmbargo:(GP_Core*)enemy {
    [EmbargoList addObject: enemy];
    [CoresTradedWith addObject: enemy];
}

- (BOOL)Query_EmbargoWithCore:(GP_Core*)core {
    return [EmbargoList containsObject: core];
}








- (BOOL)Query_TradedWithCore:(GP_Core*)core {
    return [CoresTradedWith containsObject: core];
}





- (void)animateRejection {
    
    [UIView animateWithDuration: 0.1 animations:^{
        
        self.alpha = 0.8;
        
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration: 0.1 animations:^{
            
            self.alpha = 1.0;
            
        }];
        
    }];
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //UITouch *touch = [[event allTouches] anyObject];
    
    //CGPoint location = [touch locationInView: self];
    
    
    if (AllowInteraction) {
        
        
        PlaySelectedSound = FALSE;
        PlayUnselectedSound = FALSE;
        PlayRejectionSound = FALSE;
        
        
        if (IsSelected) [self setSelected: FALSE];
        else {
            [self setSelected: TRUE];
            [(GamePlayView*)[self superview] continueTutorialFromCore];
        }
        
        if (PlaySelectedSound) [HHC playSelectionSound];
        if (PlayUnselectedSound) [HHC playUnselectionSound];
        if (PlayRejectionSound) [HHC playRejectionSound];
        
        
        
        PlaySelectedSound = FALSE;
        PlayUnselectedSound = FALSE;
        PlayRejectionSound = FALSE;
        
    }
    
    
}










- (void)drawRect:(CGRect)rect {
    
    if (IsSelected) [CoreSelected drawInRect: rect];
    
    
    
    int divNumber = 8;
    
    int coreImageScale = SizeScale - (SizeScale / divNumber);
    
    int coreImageX = ((SizeScale / divNumber) / 2);
    int coreImageY = ((SizeScale / divNumber) / 2);
    
    
    [CoreImage drawInRect: CGRectMake(coreImageX, coreImageY, coreImageScale, coreImageScale)];
    
    
}






- (void)dealloc {
    
    MyRing = nil;
    
    [CoreImage release];
    [CoreSelected release];
    
    [CoresTradedWith removeAllObjects];
    [CoresTradedWith release];
    
    [EmbargoList removeAllObjects];
    [EmbargoList release];
    
    [super dealloc];
}



@end
