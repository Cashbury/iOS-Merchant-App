//
//  LoginViewController.h
//  Cashbury
//
//  Created by Ahmed Magdy on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FacebookWrapper.h"
#import "FBLoginBtn.h"
#import "KZURLRequest.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZUtils.h"
#import "CWRingUpViewController.h"

@class Facebook;

@interface LoginViewController : UIViewController <
FaceBookWrapperSessionDelegate,
KZURLRequestDelegate,UITextFieldDelegate>{

	IBOutlet FBLoginBtn *fbButton;
    IBOutlet UITextField *emailIDTextfield;
    IBOutlet UITextField *passwordTextfield;
    IBOutlet UIButton *goButton;
}
- (IBAction)clickGoButton:(id)sender;

- (IBAction) hideKeyboard;
- (IBAction) forgot_password;
- (IBAction) signup;
- (IBAction) facebook_connect;

@property (nonatomic, retain) IBOutlet UITextField *emailIDTextfield;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextfield;

@property (nonatomic, retain) IBOutlet FBLoginBtn *fbButton;

- (void) loginWithEmail:(NSString*)_email andPassword:(NSString*)_password andUsername:(NSString*)_username andFirstName:(NSString*)_first_name andLastName:(NSString*)_last_name andShowLoading:(BOOL)_show_loading;

@end
