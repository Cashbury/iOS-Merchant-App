//
//  CashierTxReceiptHistoryCell.h
//  Cashbery
//
//  Created by Rami Khawandi on 5/12/11.
//  Copyright (c) 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashierTxReceiptHistoryCell : UITableViewCell{
    

    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *customerNameLabel;
    IBOutlet UIImageView *statusImgView;
    IBOutlet UIButton *refundButton;
    IBOutlet UILabel *amountLabel;
    IBOutlet UILabel *tipsAmountLabel;
    IBOutlet UILabel *refundedLabel;
    IBOutlet UILabel *refundedByLabel;
}
@property (retain, nonatomic) IBOutlet UIImageView *cellBgImgView;

- (IBAction)refundButtonClicked:(id)sender;


@end
