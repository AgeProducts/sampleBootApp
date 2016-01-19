//
//  SecondViewController.m
//  sampleBootApp
//
//  Created by 堀 卓司 on 2015/12/20.
//  Copyright © 2015年 Age Products. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "mailViewController.h"
#import "HowToUseViewController.h"
#import "PopUpPurchaseViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *bootMsgSwitch;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.bootMsgSwitch.on = [APP_DELEGATE checkInitialMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)purchaseAction:(id)sender
{
    PopUpPurchaseViewController *aPopUpViewController =
    [[PopUpPurchaseViewController alloc] initWithNibName:@"PopUpPurchaseViewController" bundle:nil];
    aPopUpViewController.delegate = self;
    [self presentPopupViewController:aPopUpViewController animationType:MJPopupViewAnimationFade];
}

- (void)closeButtonClicked:(PopUpPurchaseViewController *)aPopUpPurchaseViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void)reloadAtClose:(PopUpPurchaseViewController *)aPopUpPurchaseViewController
{
    // eg. [self.tableView reloadData];
}

- (IBAction)mailButtonAct:(id)sender
{
    [self performSegueWithIdentifier:@"SetupAuthorMail" sender:self];
}

- (IBAction)reviewButtonAct:(id)sender
{
    NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
    NSString *templateReviewURLiOS8 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
    
    NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", APP_ID]];
    reviewURL = [templateReviewURLiOS8 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", APP_ID]];
    NSURL* url= [NSURL URLWithString:reviewURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)howToUseButtonAct:(id)sender
{
    [self performSegueWithIdentifier:@"HowToUse" sender:self];
}

- (IBAction)bootMsgSwitchAvt:(id)sender
{
    [APP_DELEGATE setInitialMessage:self.bootMsgSwitch.on];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = [segue identifier];
    
    if ([segueID isEqualToString:@"SetupAuthorMail"]) {
        NSString *mailAppMsg3 =  NSLocalizedString(@"Opinion", @"SetupViewCTRL");
        NSString *mailAppMsg4 =  NSLocalizedString(@"For Apps, I will send the opinion.", @"SetupViewCTRL");
        
        mailViewController *aMailViewController = [segue destinationViewController];
        aMailViewController.mailToAddr =  AUTHOR_MAILADDER;
        aMailViewController.mailSubject = mailAppMsg3;
        aMailViewController.mailMessage = mailAppMsg4;
    }
    if ([segueID isEqualToString:@"HowToUse"]) {
        HowToUseViewController *HowToUseViewController = [segue destinationViewController];
        if ([segueID isEqualToString:@"HowToUse"]) {
            HowToUseViewController.hidesBottomBarWhenPushed = YES;
            HowToUseViewController.segueID = segueID;
        }
    }
    
}

@end
