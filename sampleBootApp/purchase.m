//
//  purchase.m
//  RssReader
//
//  Created by 堀 卓司 on 2015/10/24.
//  Copyright © 2015年 Age Products. All rights reserved.
//
#import "purchase.h"

@interface purchase()
@end

@implementation purchase
+ (purchase *)sharedInstance
{
    static purchase *sSharedInstance;
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        sSharedInstance = [[purchase alloc] init];
    });
    return sSharedInstance;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
       // [self initSettings];
    }
    return self;
}

/* Purchase Item */
#define UD_PurchaseItem_KEY     @"UD_PurchaseItem_KEY"
- (NSString *)checkPurchaseItem
{
    NSString *UD_Value = [APP_DELEGATE.userDefaults objectForKey:UD_PurchaseItem_KEY];
    
    if (UD_Value==nil || [UD_Value isEqualToString:DEFAULT_PurchaseString])
        return nil;
    return UD_Value;
}

- (void)setPurchaseItem
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = locale;
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'";
    
    [APP_DELEGATE.userDefaults setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:UD_PurchaseItem_KEY];
    [APP_DELEGATE.userDefaults synchronize];

    return;
}

- (void)resetPurchaseItem
{
    [APP_DELEGATE.userDefaults setObject:DEFAULT_PurchaseString forKey:UD_PurchaseItem_KEY];
    [APP_DELEGATE.userDefaults synchronize];
    
    return;
}

- (void)removePurchaseItem
{
    [APP_DELEGATE.userDefaults removeObjectForKey:UD_PurchaseItem_KEY];
    [APP_DELEGATE.userDefaults synchronize];

    return;
}


@end
