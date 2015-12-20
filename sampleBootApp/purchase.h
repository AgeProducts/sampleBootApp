//
//  purchase.h
//  RssReader
//
//  Created by 堀 卓司 on 2015/10/24.
//  Copyright © 2015年 Age Products. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface purchase : NSObject
+ (purchase *)sharedInstance;
- (NSString *)checkPurchaseItem;
- (void)setPurchaseItem;
- (void)resetPurchaseItem;
- (void)removePurchaseItem;
@end



