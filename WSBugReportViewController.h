//
//  WSBugReportViewController.h
//  GameIdeaProto
//
//  Created by Mike Weinberg on 8/20/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSBugReportViewController : UIViewController {
    
    
    id MyNCOIC;
    
    
    int TextViewOriginalHeight;
    
    
    IBOutlet UIBarButtonItem* SendButton;
    
    IBOutlet UILabel* LevelText;
    IBOutlet UIStepper* LevelStepper;
    
    IBOutlet UITextView* BugRecreationField;
    
    IBOutlet UISegmentedControl* BugEncounteredIn;
    
    
}


- (void)setNCOIC:(id)myNCOIC;
- (void)setLevelCount:(int)levelCount;

- (IBAction)stepper:(id)sender;

- (IBAction)sendReport:(id)sender;
- (IBAction)cancelReport:(id)sender;


@end
