//
//  PopUpPurchaseViewController.h
//  LogCalc
//
//  Created by 堀 卓司 on 2014/08/18.
//  Copyright (c) 2014年 Age products. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"
#import "EBPurchase.h"

@protocol SetupViewController;

@interface PopUpPurchaseViewController : UIViewController
@property (assign, nonatomic) id <SetupViewController> delegate;
@end

@protocol SetupViewController <NSObject>

@optional
- (void)closeButtonClicked:(PopUpPurchaseViewController *)aPopUpPurchaseViewController;
- (void)reloadAtClose:(PopUpPurchaseViewController *)aPopUpPurchaseViewController;
@end

