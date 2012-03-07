//
//  LoginViewController.m
//  Cashbury
//
//  Created by Ahmed Magdy on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define ANIMATE_DISTANCE    -30
#import "LoginViewController.h"
#import "FBConnect.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZUtils.h"
#import "FacebookWrapper.h"
#import "ForgotPasswordViewController.h"
#import "SignupViewController.h"
#import "KZCardsAtPlacesViewController.h"
#import "LockScreenController.h"


@implementation LoginViewController

@class KZUtils;

@synthesize fbButton;
@synthesize emailIDTextfield,passwordTextfield;



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

#pragma mark CHANGE GO BUTTON STATE
-(void)changeGoButtonState:(BOOL)isActive{
    if (isActive) {
        [goButton setImage:[UIImage imageNamed:@"go_active"] forState:UIControlStateNormal];
    }else{
        [goButton setImage:[UIImage imageNamed:@"go_inactive"] forState:UIControlStateNormal];
    }
}

#pragma mark ANIMATE VIEW

-(void)callForUIAnimationOfView:(NSInteger)getDist{
    
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
            
            self.view.frame     =   CGRectMake(self.view.frame.origin.x, getDist, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
    
}
-(void)animateView:(UITextField*)currenttxtField resignResonder:(BOOL)shouldResign{
    
    if ([currenttxtField isEqual:emailIDTextfield]) {// email textfield
        if (shouldResign){
            [passwordTextfield becomeFirstResponder];
            if (self.view.frame.origin.y == 0) {
                [self callForUIAnimationOfView:ANIMATE_DISTANCE];
            }
        }else{
            //animate only if self.view.frame.origin.y is 0
            
            if (self.view.frame.origin.y == ANIMATE_DISTANCE) {
                [self callForUIAnimationOfView:0];
            }
        }  
        
    }else{// password textfield
        if (shouldResign) {
            [emailIDTextfield becomeFirstResponder];
            if (self.view.frame.origin.y == ANIMATE_DISTANCE) {
                [self callForUIAnimationOfView:0.0];
            }
        }else{
            //animate only if self.view.frame.origin.y is -20
            if (self.view.frame.origin.y == 0) {
                [self callForUIAnimationOfView:ANIMATE_DISTANCE];
            } 
        }
    }
}

#pragma mark TEXTFIELD DELEGATES

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	//[self hideKeyboard];
    
    [self animateView:textField resignResonder:TRUE];
	return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self animateView:textField resignResonder:FALSE];
    
    return  TRUE;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string length]>0) {
        if ([textField isEqual:emailIDTextfield]) {
            if ([[passwordTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                //active
                [self changeGoButtonState:TRUE];
            }else{
                //inactive
                [self changeGoButtonState:FALSE];
            }
  
        }else{
            if ([[emailIDTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                //active
                [self changeGoButtonState:TRUE];
            }else{
                //inactive
                [self changeGoButtonState:FALSE];
            }
        }
    }else{
        
        if(range.length == 1 && range.location == 0)
            [self changeGoButtonState:FALSE];
        else
            [self changeGoButtonState:TRUE];
    }
    return true;
}

#pragma mark INPUT VALID
- (BOOL) isInputValid {
	BOOL output = YES;
	NSMutableString *error_msg = [[NSMutableString alloc] initWithString:@"Error:"];
	if (![KZUtils isEmailValid:emailIDTextfield.text]) {
		[error_msg appendString:@"\nThe Email address is invalid"];
		output = NO;
	}
	if (![KZUtils isPasswordValid:passwordTextfield.text]) {
		[error_msg appendString:@"\nThe password is invalid; it should be at least 6 characters."];
		output = NO;
	}
	if (output == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:error_msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	return output;
}


#pragma mark GO BUTTON CLICKED
- (IBAction)clickGoButton:(id)sender {
    
    [self hideKeyboard];
    self.view.frame =   CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, self.view.frame.size.height);

	if (![self isInputValid]) return; 
    
    [self loginWithEmail:emailIDTextfield.text andPassword:passwordTextfield.text andUsername:@"" andFirstName:@"" andLastName:@"" andShowLoading:TRUE];
}

- (IBAction) hideKeyboard {
	[emailIDTextfield resignFirstResponder];
	[passwordTextfield resignFirstResponder];
}

#pragma mark FORGOT PASSWORD
- (IBAction) forgot_password {
	[self hideKeyboard];
	ForgotPasswordViewController *forgot_pass = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordView" bundle:nil];
	[self presentModalViewController:forgot_pass animated:YES];
}

#pragma mark SIGN UP
- (IBAction) signup {
	[self hideKeyboard];
	SignupViewController *signup = [[SignupViewController alloc] initWithNibName:@"SignupView" bundle:nil];
	[self presentModalViewController:signup animated:YES];
}


/* to delete */
- (IBAction) facebook_connect{
	FacebookWrapper *shared = [FacebookWrapper shared];
	[FacebookWrapper setSessionDelegate:self];
	[self hideKeyboard];
	[shared login];
}



#pragma mark VIEW CYCLES
/**
 * Set initial view
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    emailIDTextfield.delegate   =   self;
    passwordTextfield.delegate  =   self;
    
    /* delete */
    emailIDTextfield.text       =   @"h1@gotmazuma.com";
    passwordTextfield.text      =   @"Ca$hier";
    self.navigationController.navigationBarHidden = YES;
	//[fbButton updateImage];
	
}


- (void)dealloc {
	[fbButton release];
    [emailIDTextfield release];
    [passwordTextfield release];
    [goButton release];
	[super dealloc];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
*/
/**
 * Called when the request logout has succeeded.
 */
/* to delete */
- (void)didLogout {
	if ([[KZUserInfo shared] isLoggedIn]) {
		[KZUserInfo shared].user_id = nil;
		[KZUserInfo shared].auth_token = nil;
	}
	//if (!fbButton.isLoggedIn) {
	fbButton.isLoggedIn         = NO;
	//[fbButton updateImage];
	//}
}



/* to delete */
- (void) didNotLogin {
	[KZApplication hideLoading];
	[[FacebookWrapper shared] logout];
	NSLog(@"Could not Login");
	
}

/* to delete */
- (void) fbDidLogin {
	[KZApplication showLoadingScreen:nil];
	NSLog(@"Logged in to Facebook");
	fbButton.isLoggedIn         = YES;
	//[fbButton updateImage];
}


- (void) didLoginWithUid:(NSString*)_uid andUsername:(NSString*)_username andFirstName:(NSString*)_first_name andLastName:(NSString*)_last_name {
	[KZUserInfo shared].first_name = _first_name;
	[KZUserInfo shared].last_name = _last_name;
    [KZUserInfo shared].facebookID = _uid;
	NSString *email = [NSString stringWithFormat:@"%@@facebook.com.fake", _uid];
	NSString *password = [KZUtils md5ForString:[NSString stringWithFormat:@"fb%@bf", _uid]];
	[self loginWithEmail:email andPassword:password andUsername:_username andFirstName:_first_name andLastName:_last_name andShowLoading:YES];
}

#pragma mark LOGIN REQUEST

- (void) loginWithEmail:(NSString*)_email andPassword:(NSString*)_password andUsername:(NSString*)_username andFirstName:(NSString*)_first_name andLastName:(NSString*)_last_name andShowLoading:(BOOL)_show_loading {	
	NSString *url_str = [NSString stringWithFormat:@"%@/users/sign_in.xml", API_URL];
	NSString *params = [NSString stringWithFormat:@"email=%@&password=%@&username=%@&first_name=%@&last_name=%@", _email, _password, _username, _first_name, _last_name];
    
    
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	NSString *message;
	if (_show_loading) {
		message = @"Signing In";
	} else {
		message = nil;
	}
	[[[KZURLRequest alloc] initRequestWithString:url_str andParams:params delegate:self headers:_headers andLoadingMessage:message] autorelease];
	[_headers release];
	[KZUserInfo shared].email = _email;
	[KZUserInfo shared].password = _password;
	[KZUserInfo shared].first_name = _first_name;
	[KZUserInfo shared].last_name = _last_name;
	[KZUserInfo shared].is_logged_in = YES;
	[[KZUserInfo shared] persistData];
}

////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
}

//------------------------------------------
// KZURLRequestDelegate methods
//------------------------------------------
#pragma mark KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	[[KZUserInfo shared] clearPersistedData];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:[theError debugDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	/**
	 Response:
	 <?xml version="1.0" encoding="UTF-8"?>
	 <user>
		<id type="integer">5</id>
		<first-name>Full Name</first-name>
		<last-name>Full Name</last-name>
		<email>user@domain.com</email>
		<authentication-token>Al9OAveJ62IqUuF1U_nN</authentication-token>
	 </user>
	 */
  //  if (theRequest == login_request)
  //  {
    
    NSString *tempString    =   [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    NSLog(@"string %@",tempString);
	
	CXMLDocument *_document     =   [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	CXMLElement *_error_node    =   (CXMLElement*)[_document nodeForXPath:@"//error" error:nil];
	if (_error_node != nil) { 
		[[KZUserInfo shared] clearPersistedData];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:[_error_node stringValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	} else {
        CXMLElement *_node = (CXMLElement*)[_document nodeForXPath:@"//user" error:nil];
        
        // Escape the image URL
        NSString *_imageURLString = [[_node stringFromChildNamed:@"brand-image-url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[KZUserInfo shared].user_id = [_node stringFromChildNamed:@"id"];
		[KZUserInfo shared].currency_code = [_node stringFromChildNamed:@"currency-code"];
		[KZUserInfo shared].flag_url = [_node stringFromChildNamed:@"flag-url"];
		[KZUserInfo shared].cashier_business = [KZBusiness getBusinessWithIdentifier:[_node stringFromChildNamed:@"business-id"] 
																			 andName:[_node stringFromChildNamed:@"brand-name"] 
																		 andImageURL:[NSURL URLWithString:_imageURLString]];
		
		[KZUserInfo shared].first_name = [_node stringFromChildNamed:@"first-name"];
		[KZUserInfo shared].last_name = [_node stringFromChildNamed:@"last-name"];
		[KZUserInfo shared].auth_token = [_node stringFromChildNamed:@"authentication-token"];
		if ([[KZUserInfo shared] isLoggedIn]) {
            
            /*
            CWRingUpViewController *ringerController    =   [[CWRingUpViewController alloc] initWithBusinessId:[KZUserInfo shared].cashier_business.identifier];
            [[KZApplication getAppDelegate].navigationController pushViewController:ringerController animated:NO];
            //[ringerController release];*/
            
            if ([[KZUserInfo shared] hasPincode]) {
                LockScreenController *lockController            =   [[LockScreenController alloc] initWithTag:TAG_LOCK_STARTVIEW];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].window cache:NO];
                [[KZApplication getAppDelegate].window addSubview:lockController.view];
                [UIView commitAnimations];
            }else{
                CWRingUpViewController  *ringerController      =    [[CWRingUpViewController alloc] initWithBusinessId:[KZUserInfo shared].cashier_business.identifier];
                CGRect fRect                    =   ringerController.view.frame;
                fRect.origin.y                  +=  20;
                ringerController.view.frame     =   fRect;
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].window cache:NO];
                [[KZApplication getAppDelegate].window addSubview:ringerController.view];
                [UIView commitAnimations];
                [KZApplication getAppDelegate].ringup_vc = ringerController;
                [ringerController release];

            }
            				
		}
	}	
}


- (void)viewDidUnload {
    [emailIDTextfield release];
    emailIDTextfield = nil;
    [passwordTextfield release];
    passwordTextfield = nil;
    [goButton release];
    goButton = nil;
    [super viewDidUnload];
}
@end
