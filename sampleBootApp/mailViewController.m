//
//  mailViewController.m
//  UkiyoeWatch
//
//  Created by 堀 卓司 on 2014/06/10.
//  Copyright (c) 2014年 Age products. All rights reserved.
//
#import <Foundation/NSString.h>
#import "mailViewController.h"
#import "AppDelegate.h"

@implementation mailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self sendToMailEvent];
}

- (void)sendToMailEvent
{    
    if ([MFMailComposeViewController canSendMail] == NO) {
        NSLog(@"%s can't send mail", __PRETTY_FUNCTION__);
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    // [[mailViewController navigationBar] setTintColor:[UIColor whiteColor]];
    mailViewController.mailComposeDelegate = self;
    
    if (self.mailToAddr!=nil && ![self.mailToAddr isEqualToString:@""])
    {
        NSArray *toRecipients = [NSArray arrayWithObject:self.mailToAddr];
        [mailViewController setToRecipients:toRecipients];
    }
    
    NSString *subj = [NSString stringWithFormat:@"%@ %@",self.mailSubject,APP_DELEGATE.aplName];
    [mailViewController setSubject:subj];
    
    NSString *msg = [NSString stringWithFormat:@"%@\nname:%@ version:%@ build:%@",
                     self.mailMessage, APP_DELEGATE.aplName, APP_DELEGATE.aplVersionNo, APP_DELEGATE.aplBuildNo];
    [mailViewController setMessageBody:msg isHTML:NO];
    
    [self presentViewController:mailViewController animated:YES completion:nil];
}

// アプリ内メーラーのデリゲートメソッド
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            // キャンセル
            break;
        case MFMailComposeResultSaved:
            // 保存 (ここでアラート表示するなど何らかの処理を行う)
            
            break;
        case MFMailComposeResultSent:
            // 送信成功 (ここでアラート表示するなど何らかの処理を行う)
            
            break;
        case MFMailComposeResultFailed:
            // 送信失敗 (ここでアラート表示するなど何らかの処理を行う)
            
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
