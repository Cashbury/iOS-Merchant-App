//
//  LockScreenController.m
//  Cashbury
//
//  Created by jayanth S on 2/22/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#define PINCODE_KEY     @"CashburyPincode"
#define PINCODE_LOCK_CHECK    @"IsPincodeLocked"

#import "LockScreenController.h"

@implementation LockScreenController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [pincodeTextField release];
    pincodeTextField = nil;
    [lockButton release];
    lockButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [pincodeTextField release];
    [lockButton release];
    [super dealloc];
}
- (IBAction)clickLockButton:(id)sender {
    
    if ([[pincodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] >0) {
        
        UIButton *lButton               =   (UIButton*)sender;
        NSUserDefaults *userDefaults    =   [NSUserDefaults standardUserDefaults];
        BOOL isLocked                   =   [userDefaults boolForKey:PINCODE_LOCK_CHECK];
        if (isLocked) {
            // reproduce the pincode
            
            NSString *getPincode        =   [userDefaults valueForKey:PINCODE_KEY];
            if ([pincodeTextField.text isEqualToString:getPincode]) {
                
                // go to ringer view
                
            }else{
                UIAlertView *pincodeAlert  =   [[UIAlertView alloc] initWithTitle:@"Message" message:@"Incorrect pincode" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [pincodeAlert show];
                [pincodeAlert release];
            }
            
        }else{
            // not locked, enter new pincode
            [userDefaults setObject:pincodeTextField.text forKey:PINCODE_KEY];
            [userDefaults setBool:TRUE forKey:PINCODE_LOCK_CHECK];
            [userDefaults synchronize];
            
            [lButton setTitle:@"Unlock" forState:UIControlStateNormal];
        }
    }else{
        UIAlertView *pincodeAlert  =   [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter your pincode" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [pincodeAlert show];
        [pincodeAlert release];
    } 
}
@end
