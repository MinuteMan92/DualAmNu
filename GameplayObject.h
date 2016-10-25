//
//  GameplayObject.h
//  GameIdeaProto
//
//  Created by Mike Weinberg on 6/30/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


#import "HHC.h"






@interface GP_Ring : UIView {
    
    
    BOOL TutorialMode;
    
    
    BOOL Birthed;
    
    GameplayObjectColor MyObjColor;
    
    UIView* MyCore;
    
    UIImage* RingImage;
    
}

+ (GP_Ring*)ringWithColor:(GameplayObjectColor)objColor birthed:(BOOL)birthed;


- (void)setTutorialMode:(BOOL)mode;


- (void)setGPObjectColor:(GameplayObjectColor)color;
- (GameplayObjectColor)GPObjectColor;


- (void)moveToCore:(UIView*)core animate:(BOOL)animate;


- (void)setBirth:(BOOL)isBirthed animate:(BOOL)animate;
- (BOOL)isBirthed;



@end








@interface GP_Core : UIView {
    
    BOOL IsDominant;
    
    
    BOOL IsSelected;
    
    BOOL PlaySelectedSound;
    BOOL PlayUnselectedSound;
    BOOL PlayRejectionSound;
    
    BOOL AllowInteraction;
    
    int SizeScale;
    
    GameplayObjectColor MyObjColor;
    
    GP_Ring* MyRing;
    
    UIImage* CoreImage;
    UIImage* CoreSelected;
    
    
    NSMutableArray* CoresTradedWith;
    
    NSMutableArray* EmbargoList;
    
    
}


+ (GP_Core*)coreWithColor:(GameplayObjectColor)objColor;


- (void)allowInteraction:(BOOL)allow;


- (BOOL)hasCorrectRing;


- (void)animateMatch;


- (void)setSizeScale:(int)scale;
- (int)sizeScale;


- (void)setSelected:(BOOL)selected;
- (BOOL)isSelected;


- (void)setGPObjectColor:(GameplayObjectColor)color;
- (GameplayObjectColor)GPObjectColor;


- (void)setRingObject:(GP_Ring*)myRing fromCore:(GP_Core*)core;
- (GP_Ring*)ring;


- (void)addEmbargo:(GP_Core*)enemy;
- (BOOL)Query_EmbargoWithCore:(GP_Core*)core;



- (BOOL)Query_TradedWithCore:(GP_Core*)core;



@end