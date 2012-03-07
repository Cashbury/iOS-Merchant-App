//
//  KZUserInfo.h
//  Cashbery
//
//  Created by Basayel Said on 7/20/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#define TAG_LOCK_FROM_RINGERVIEW    10
#define TAG_LOCK_STARTVIEW          20

#import <Foundation/Foundation.h>
#import "KZBusiness.h"

@interface KZUserInfo : NSObject {
	
}

@property (nonatomic, retain) NSString* auth_token;
@property (nonatomic, retain) NSString* user_id;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* facebook_username;
@property (nonatomic, retain) NSString* first_name;
@property (nonatomic, retain) NSString* last_name;
@property (nonatomic) BOOL is_logged_in;
@property (nonatomic, retain) KZBusiness* cashier_business;
@property (nonatomic, retain) NSString* current_profile;
@property (nonatomic, retain) NSString* currency_code;
@property (nonatomic, retain) NSString* flag_url;

@property (nonatomic, retain) NSString *facebookID;
@property (nonatomic, assign) NSString *pincode;
@property (nonatomic, retain) NSString *currency_symbol;

+ (KZUserInfo*) shared;

- (BOOL) isLoggedIn;

- (void) persistData;


- (BOOL) isCredentialsPersistsed;

- (void) clearPersistedData;

- (NSString*) getFullName;

-(BOOL)hasPincode;

// Returns the full first name and an abbreviated last name
- (NSString*) getShortName;

@end
