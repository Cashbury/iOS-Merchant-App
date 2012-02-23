//
//  CashierTxHistoryViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CashierTxHistoryViewController.h"
#import "UIButton+Helper.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZCashierSpendReceiptViewController.h"
#import "NSBundle+Helpers.h"
#import "CashierTxReceiptHistoryCell.h"

@interface CashierTxHistoryViewController (Private)
- (float) getDayReceiptsSum:(NSArray*)_receipts;
- (CWRingUpViewController *) parentController;
@end

@implementation CashierTxHistoryViewController

@synthesize lbl_title, view_menu, view_cover, img_menu_arrow, btn_ring_up, btn_receipts, btn_load_up;

#pragma mark Header View

+ (CashierTxHistoryHeaderView *) headerViewWithTitle:(NSString *)theTitle description:(NSString *)theDescription
{
    CashierTxHistoryHeaderView *_header = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CashierTxHistoryHeaderView"
                                                                                  class:[CashierTxHistoryHeaderView class]
                                                                                  owner:nil
                                                                                options:nil];
    
    _header.title.text = theTitle;
    _header.description.text = theDescription;
    
    return _header;
}

#pragma InitWith
- (id) initWithDaysArray:(NSMutableArray*)_days {
	if (self = [self initWithNibName:@"CashierTxHistoryView" bundle:nil]) {
		days_array = [_days retain];
		return self;
	}
	return nil;
}

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    
	[self.btn_ring_up setCustomStyle];
    [self.btn_load_up setCustomStyle];
	[self.btn_receipts setCustomStyle];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-receipts.png"]];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.btn_ring_up = nil;
    self.btn_receipts = nil;
    self.btn_load_up = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [days_array count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSString *_cellIdentifier = @"Cell";
    

    CashierTxReceiptHistoryCell *cell = (CashierTxReceiptHistoryCell *) [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CashierTxReceiptHistoryCell" class:[CashierTxReceiptHistoryCell class] owner:nil options:nil];
        
    }
    if (indexPath.row == 2) {

        cell.frame                  =   CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 90.0);
        cell.cellBgImgView.image    =   [UIImage imageNamed:@"records_cell_bg1"];
    
    }else{
        cell.frame                  =   CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 79.0);
        cell.cellBgImgView.image    =   [UIImage imageNamed:@"records_cell_bg"];
        
    }

    
    return cell;

}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary* section_day   =   (NSDictionary*)[days_array objectAtIndex:indexPath.section];
	NSArray* receipts           =   (NSArray*)[section_day objectForKey:@"receipts"];
    if ([receipts count] >0) {
        NSDictionary* receipt       =   (NSDictionary*)[receipts objectAtIndex:indexPath.row];
        
        KZCashierSpendReceiptViewController* rec = 
        [[KZCashierSpendReceiptViewController alloc] initWithBusiness:[KZUserInfo shared].cashier_business 
                                                               amount:[receipt objectForKey:@"spend_money"]
                                                      currency_symbol:[receipt objectForKey:@"currency_symbol"]
                                                        customer_name:[receipt objectForKey:@"customer_name"] 
                                                        customer_type:[receipt objectForKey:@"customer_type"] 
                                                   customer_image_url:[receipt objectForKey:@"customer_image_url"]
                                                       transaction_id:[receipt objectForKey:@"transaction_id"]];
        [self presentModalViewController:rec animated:YES];
        [rec release];
    }
}


#pragma mark -
#pragma mark Memory management
/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 90.0;
    }
    return 79.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 58;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSDictionary *sectionDay            =   (NSDictionary*)[days_array objectAtIndex:section];
    NSArray *receiptsArray              =   (NSArray*)[sectionDay objectForKey:@"receipts"];
    NSString *sumString                 =   [NSString stringWithFormat:@"%0.0lf %@", [self getDayReceiptsSum:receiptsArray], [KZUserInfo shared].currency_code];
    NSString *titleString               =   @"";
    NSDate* section_date                =   [sectionDay objectForKey:@"date"];
    NSDateFormatter* formatter          =   [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString                 =   [formatter stringFromDate:section_date];
    
    
    
    
    switch (section) {
        case 0:
            titleString         =   [NSString stringWithFormat:@"Today %@", dateString];
            break;
        case 1:
            titleString         =   [NSString stringWithFormat:@"Yesterday %@", dateString];
            break;
            
        default:{
            
            [formatter setDateFormat:@"EEEE"];
            titleString                     =   [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:section_date], dateString];
            
        }
            break;
    }

    
    return [CashierTxHistoryViewController headerViewWithTitle:titleString description:sumString];
}

- (void)dealloc {
	[days_array release];
    [super dealloc];
}




- (IBAction) openCloseMenu {
	CGRect current_position = self.view_menu.frame;
	if (is_menu_open) {	// then close
		current_position.origin.y -= 200;
	} else {	// then open
		current_position.origin.y += 200;
	}
	is_menu_open = !is_menu_open;
	[self.view_cover setHidden:NO];
	[self.view_cover setOpaque:NO];
	[UIView animateWithDuration:0.5 
					 animations:^(void){
						 if (is_menu_open) {
							 [self.view_cover setAlpha:0.8];
						 } else {
							 [self.view_cover setAlpha:0.0];
						 }
						 self.view_menu.frame = current_position;
					 } 
					 completion:^(BOOL finished){	
						 if (is_menu_open) {
							 [self.lbl_title setHighlighted:YES];
							 [self.img_menu_arrow setHighlighted:YES];
						 } else {
							 [self.lbl_title setHighlighted:NO];
							 [self.img_menu_arrow setHighlighted:NO];
						 }
					 }
	 ];
	
}





- (IBAction) showTransactionHistory {
	[self openCloseMenu];
}

- (CWRingUpViewController *) parentController
{
    if (IS_IOS_5_OR_NEWER)
    {
        return (CWRingUpViewController *) self.presentingViewController;
    }
    else
    {
        return (CWRingUpViewController *) self.parentViewController;
    }
}

- (IBAction) showRingUp
{
    CWRingUpViewController *_parent = [self parentController];
    
    if (_parent)
    {
        _parent.action = CWRingUpViewControllerActionCharge;
    }
    
    [self openCloseMenu];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) showLoadUp
{
    CWRingUpViewController *_parent = [self parentController];
    
    if (_parent)
    {
        _parent.action = CWRingUpViewControllerActionLoad;
    }
    
    [self openCloseMenu];
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction) goBackToSettings:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:NO];	
	[self dismissModalViewControllerAnimated:NO];
	NSArray* views = [KZApplication getAppDelegate].window.subviews;
	UIView* top_view = (UIView*)[views objectAtIndex:[views count]-1];
	[top_view removeFromSuperview];
	[UIView commitAnimations];
}

- (float) getDayReceiptsSum:(NSArray*)_receipts {
	float sum = 0.0;
	for (NSDictionary* receipt in _receipts) {
		///////////TODO
		sum += [((NSString*)[receipt objectForKey:@"spend_money"]) floatValue];
	}
	return sum;
}

@end

