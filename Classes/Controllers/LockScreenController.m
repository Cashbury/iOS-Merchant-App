//
//  LockScreenController.m
//  Cashbury
//
//  Created by jayanth S on 2/22/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//



#import "LockScreenController.h"
#import "KZUserInfo.h"
#import "KZApplication.h"
#import "CWRingUpViewController.h"

@implementation LockScreenController
@synthesize cancelButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTag:(NSInteger)viewTag{
    self    =   [super init];
    if (self) {
        tag     =   viewTag;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark ---Clear All Fields
-(void)clearAllFields{
    
    firstDigitTxtField.text     =   @"";
    secondDigitTxtField.text    =   @"";
    thirdDigitTxtField.text     =   @"";
    fourthDigitTxtField.text    =   @"";
    
    [firstDigitTxtField becomeFirstResponder];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (tag == TAG_LOCK_FROM_RINGERVIEW) {
        self.cancelButton.hidden    =   FALSE;
    }else
        self.cancelButton.hidden    =   TRUE;
    firstDigitTxtField.delegate     =   self;
    secondDigitTxtField.delegate    =   self;
    thirdDigitTxtField.delegate     =   self;
    fourthDigitTxtField.delegate    =   self;
    pincodeString                   =   @"";
    messageLabel.text               =   @"Enter your PIN Code";
    [self clearAllFields];
}

- (void)viewDidUnload
{
   
    [firstDigitTxtField release];
    firstDigitTxtField = nil;
    [secondDigitTxtField release];
    secondDigitTxtField = nil;
    [thirdDigitTxtField release];
    thirdDigitTxtField = nil;
    [fourthDigitTxtField release];
    fourthDigitTxtField = nil;
  
    [messageLabel release];
    messageLabel = nil;
    [self setCancelButton:nil];
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
 
    [firstDigitTxtField release];
    [secondDigitTxtField release];
    [thirdDigitTxtField release];
    [fourthDigitTxtField release];
    [messageLabel release];
    [cancelButton release];
    [super dealloc];
}

-(void)createRingerView{
    CWRingUpViewController  *ringerController      =    [[CWRingUpViewController alloc] initWithBusinessId:[KZUserInfo shared].cashier_business.identifier];
    CGRect fRect                    =   ringerController.view.frame;
    fRect.origin.y                  +=  20;
    ringerController.view.frame     =   fRect;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].window cache:NO];
    [[KZApplication getAppDelegate].window addSubview:ringerController.view];
    [self.view removeFromSuperview];
    [UIView commitAnimations];
    [KZApplication getAppDelegate].ringup_vc = ringerController;
    [ringerController release];
}





-(void)goToRingerView{
    
    if ([KZApplication getAppDelegate].ringup_vc == nil) {
        [self createRingerView];
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].window cache:NO];
        [self.view removeFromSuperview];
        [UIView commitAnimations];
    }
    
    
}

#pragma mark --- CheckPincode
-(void)checkPincode{
    KZUserInfo *userInfo    =   [KZUserInfo shared];
    NSString *getString     =   firstDigitTxtField.text;
    getString               =   [getString stringByAppendingString:secondDigitTxtField.text];
    getString               =   [getString stringByAppendingFormat:thirdDigitTxtField.text];
    getString               =   [getString stringByAppendingFormat:fourthDigitTxtField.text];
    
    if ([getString length] == 4) {
        
        if (tag == TAG_LOCK_FROM_RINGERVIEW) {
            if ([pincodeString length] > 0) {
                
                if ([pincodeString isEqualToString:getString]) {// confirm pincode
                    
                    //save to user info
                    userInfo.pincode    =   getString;
                    [userInfo persistData];
                    [self goToRingerView];
                }else{//wrong pincode
                    [self clearAllFields];
                    UIAlertView *wrongPincodeAlert  =   [[UIAlertView alloc]initWithTitle:@"Cashbury" message:@"Your PIN Codes don't match." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [wrongPincodeAlert show];
                    [wrongPincodeAlert release];
                    
                }
                
            }else{
                pincodeString       =   [getString copy];
                messageLabel.text   =   @"Confirm your PIN Code";
                [self clearAllFields];
            }
        }else{
            
            if ([userInfo.pincode isEqualToString:getString]) {
                // correct pin, go to ringer view
                [self goToRingerView];
                
            }else{//wrong pin
                
                [self clearAllFields];
                UIAlertView *wrongPincodeAlert  =   [[UIAlertView alloc]initWithTitle:@"Cashbury" message:@"Your PIN Codes don't match." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [wrongPincodeAlert show];
                [wrongPincodeAlert release];
                
            }
        }
    }
}


#pragma mark --- TextField Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    textField.text  =   string;
    if ([string length] > 0) {
        if ([textField isEqual:firstDigitTxtField]) {
            [secondDigitTxtField becomeFirstResponder];
            
        }else if([textField isEqual:secondDigitTxtField]) {
            
            [thirdDigitTxtField becomeFirstResponder];
            
        }else if([textField isEqual:thirdDigitTxtField]) {
            
            [fourthDigitTxtField becomeFirstResponder];
            
        }else if([textField isEqual:fourthDigitTxtField]) {
            
            //check for password
            [textField resignFirstResponder];
            [self checkPincode];
            
            
        }
    }
    
    return FALSE;
    
}




- (IBAction)cancelButtonClicked:(id)sender {
    
    [self goToRingerView];
}
@end
