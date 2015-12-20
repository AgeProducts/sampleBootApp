//
//  mailViewController.h
//  UkiyoeWatch
//
//  Created by 堀 卓司 on 2014/06/10.
//  Copyright (c) 2014年 Age products. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface mailViewController : UIViewController  <MFMailComposeViewControllerDelegate>
@property (nonatomic) NSString  *mailToAddr;
@property (nonatomic) NSString  *mailSubject;
@property (nonatomic) NSString  *mailMessage;
@end