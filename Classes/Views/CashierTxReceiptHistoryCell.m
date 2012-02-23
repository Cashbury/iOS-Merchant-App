//
//  CashierTxReceiptHistoryCell.m
//  Cashbery
//
//  Created by Rami Khawandi on 5/12/11.
//  Copyright (c) 2011 Cashbury. All rights reserved.
//

#import "CashierTxReceiptHistoryCell.h"

@implementation CashierTxReceiptHistoryCell
@synthesize cellBgImgView;



- (void)dealloc {
    [timeLabel release];
    [customerNameLabel release];
    [statusImgView release];
    [refundButton release];
    [amountLabel release];
    [tipsAmountLabel release];
    [refundedLabel release];
    [refundedByLabel release];
    [cellBgImgView release];
    [super dealloc];
}
- (IBAction)refundButtonClicked:(id)sender {
}
@end
