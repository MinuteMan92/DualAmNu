//
//  WSBugReportViewController.m
//  GameIdeaProto
//
//  Created by Mike Weinberg on 8/20/13.
//  Copyright (c) 2013 Mike Weinberg. All rights reserved.
//

#import "WSBugReportViewController.h"

#import "GameNCOIC.h"




@implementation WSBugReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    BugRecreationField.layer.cornerRadius = 10.0f;
}




- (void)setNCOIC:(id)myNCOIC {
    MyNCOIC = myNCOIC;
}


- (void)setLevelCount:(int)levelCount {
    LevelStepper.maximumValue = levelCount;
}





- (IBAction)stepper:(id)sender {
    LevelText.text = [NSString stringWithFormat: @"%i", (int)LevelStepper.value];
}






- (IBAction)sendReport:(id)sender {
    
    
    NSString* title = SendButton.title;
    
    
    if ([title isEqualToString: @"Send"]) {
    
    
    
        NSString* senderName = @"Keeler App Bug Reporter";
        NSString* senderEmail = [NSString stringWithFormat: @"Level: %@", [LevelText text]];        // Instead of an email, send the level number
    
        NSString* reportApp = [HHC appDisplayNameWithVersion: TRUE];
        NSString* reportingDevice = [[UIDevice currentDevice] model];
    
        NSString* stepsToRecreate = [NSString stringWithFormat: @"Bug occured during: %@.\n%@", [BugEncounteredIn titleForSegmentAtIndex: [BugEncounteredIn selectedSegmentIndex]], [BugRecreationField text]];          // "Bug occured during" Automatically included in user message
    
    
    
    
    
        
        NSString* BugReportRequestURL = [NSString stringWithFormat: @"http://www.weinbergsoftware.com/ProcessForm.php?type=bug&sender=app&name=%@&email=%@&app=%@&device=%@&message=%@", senderName, senderEmail, reportApp, reportingDevice, stepsToRecreate];
        BugReportRequestURL = [BugReportRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
        NSString* BugReportResult = [NSString stringWithContentsOfURL: [NSURL URLWithString: BugReportRequestURL] encoding: NSASCIIStringEncoding error:nil];
    
        if ([BugReportResult isEqualToString: @"true"]) {
        
            [(GameNCOIC*)MyNCOIC dismissBugReport];
        
        }
        else {
        
            [[[UIAlertView alloc] initWithTitle: @"Bug Report Failed" message: @"Unable to connect to weinbergsoftware.com" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
        
        }
        
    }
    else if ([title isEqualToString: @"Done Editing"]) {
        
        
        SendButton.title = @"Send";
        
        [LevelText resignFirstResponder];
        [BugRecreationField resignFirstResponder];
        
        
        [UIView animateWithDuration: 0.25 animations:^{
            BugRecreationField.frame = CGRectMake(BugRecreationField.frame.origin.x, TextViewOriginalHeight, BugRecreationField.frame.size.width, BugRecreationField.frame.size.height);
        }];
        
    }
}


- (IBAction)cancelReport:(id)sender {
    
    [(GameNCOIC*)MyNCOIC dismissBugReport];
    
}






- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    TextViewOriginalHeight = textView.frame.origin.y;
    
    if (![[[UIDevice currentDevice] model] hasPrefix: @"iPad"]) {
        SendButton.title = @"Done Editing";
        
        [UIView animateWithDuration: 0.25 animations:^{
            BugRecreationField.frame = CGRectMake(BugRecreationField.frame.origin.x, TextViewOriginalHeight - 170, BugRecreationField.frame.size.width, BugRecreationField.frame.size.height);
        }];
        
    }
    
    return TRUE;
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
