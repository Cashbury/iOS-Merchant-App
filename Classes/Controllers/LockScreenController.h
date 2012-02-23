//
//  LockScreenController.h
//  Cashbury
//
//  Created by jayanth S on 2/22/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockScreenController : UIViewController{
    IBOutlet UITextField *pincodeTextField;
    
    IBOutlet UIButton *lockButton;
}
- (IBAction)clickLockButton:(id)sender;

@end
