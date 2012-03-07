//
//  LockScreenController.h
//  Cashbury
//
//  Created by jayanth S on 2/22/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockScreenController : UIViewController<UITextFieldDelegate>{
 
    IBOutlet UITextField *firstDigitTxtField;
    IBOutlet UITextField *secondDigitTxtField;
    IBOutlet UITextField *thirdDigitTxtField;
    IBOutlet UITextField *fourthDigitTxtField;
    IBOutlet UILabel *messageLabel;
    
    NSString *pincodeString;
    NSInteger tag;
}

@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonClicked:(id)sender;
-(id)initWithTag:(NSInteger)viewTag;
@end
