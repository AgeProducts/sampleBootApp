//
//  PopUpPurchaseViewController.m
//  LogCalc
//
//  Created by 堀 卓司 on 2014/08/18.
//  Copyright (c) 2014年 Age products. All rights reserved.
//
/*
  if (![demoPurchase requestProduct:productIdentifier])
            It does not work this decision !
            No actual harm. However, the message is strange!
 */

#import "PopUpPurchaseViewController.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "purchase.h"

@interface PopUpPurchaseViewController () <EBPurchaseDelegate, SKProductsRequestDelegate>
{
    EBPurchase* demoPurchase;
    BOOL        isPurchased;
    BOOL        restoreMyself;
    SKProductsRequest *productRequest;
    
    NSString *productIdentifier;
    NSString *price, *localizedTitle;
}
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton    *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton    *restoreButton;
@property (weak, nonatomic) IBOutlet UILabel     *statusLabel;
@end

@implementation PopUpPurchaseViewController

@synthesize delegate;

- (void)buttonState:(BOOL)show
{
    if (show)
    {
        _purchaseButton.enabled = YES;
        _restoreButton.enabled = YES;
        _purchaseButton.alpha = 1.0;
        _restoreButton.alpha = 1.0;
    } else {
        _purchaseButton.enabled = NO;
        _restoreButton.enabled = NO;
        _purchaseButton.alpha = 0.25;
        _restoreButton.alpha = 0.25;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = @"";
    productIdentifier =   PERCHASE_ID;
    [self buttonState:NO];
    
    if (![self canAccessNetwork]) {
         dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Purchases Stopped", @"purchaseView")
                                                                           message:NSLocalizedString(@"Network is not reachable. On the check, please try again.", @"purchaseView")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
        _statusLabel.text = NSLocalizedString(@"ERROR: Network is NotReachable.", @"purchaseView");
        _statusLabel.textColor = [UIColor redColor];
        return;
    }
    
    NSSet *set = [NSSet setWithObjects:productIdentifier, nil];
    productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productRequest.delegate = self;
    [SVProgressHUD show];
    [productRequest start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    productRequest.delegate = nil;
    [SVProgressHUD dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadAtClose:)])
        [self.delegate reloadAtClose:self];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [SVProgressHUD dismiss];
    productRequest.delegate = nil;

    if (response == nil) {
        NSLog(@"no response");
        _statusLabel.text = NSLocalizedString(@"ERROR: No response.", @"purchaseView");
        _statusLabel.textColor = [UIColor redColor];
        return;
    }
    if ([response.invalidProductIdentifiers count] > 0) {
        NSLog(@"ERROR: PRODACTION_ID invalid. count:%ld", (unsigned long)[response.invalidProductIdentifiers count]);
        _statusLabel.text = NSLocalizedString(@"ERROR: invalid PRODACTION_ID.", @"purchaseView");
        _statusLabel.textColor = [UIColor redColor];
        return;
    }
    
    for (SKProduct *product in response.products) {
        NSNumberFormatter *numberFmt = [[NSNumberFormatter alloc] init];
        [numberFmt setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFmt setLocale:product.priceLocale];
        price = [numberFmt stringFromNumber:product.price];
        localizedTitle = product.localizedTitle;
        
        self.nameLabel.text = product.localizedDescription;
        /*NSLog(@"   id:%@",[product productIdentifier]);
        NSLog(@"title:%@",product.localizedTitle);
        NSLog(@" desc:%@",product.localizedDescription);
        NSLog(@"price:%@",price); */
    }
    [self purchasePriProcess];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    _statusLabel.text = NSLocalizedString(@"ERROR: Price request error.", @"purchaseView");
    _statusLabel.textColor = [UIColor redColor];
    NSLog(@"price request error");
    [SVProgressHUD dismiss];
    productRequest.delegate = nil;
    [self purchasePriProcess];
}

- (void)purchasePriProcess
{
    demoPurchase = [[EBPurchase alloc] init];
    demoPurchase.delegate = self;
    isPurchased = NO;
    restoreMyself = NO;
    
    NSString *purchasedString = [[purchase sharedInstance] checkPurchaseItem];
    if (purchasedString==nil)
        purchasedString = DEFAULT_PurchaseString;
        
    if ([purchasedString isEqualToString:DEFAULT_PurchaseString]) {
        _statusLabel.text = [NSString stringWithFormat:@"%@ : %@",localizedTitle, price];
        
        if (![demoPurchase requestProduct:productIdentifier])            // It does not work this decision !
        {
             dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow Purchases", @"purchaseView")
                                                                               message:NSLocalizedString(@"Before purchasing process, you will need to enable the setting of iOS.", @"purchaseView")
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            });
            _statusLabel.text = NSLocalizedString(@"ERROR: Purchasing is not permitted.", @"purchaseView");
            _statusLabel.textColor = [UIColor redColor];
        } else {
            [self buttonState:YES];
        }
    } else {
        _statusLabel.text =
            [NSString stringWithFormat:NSLocalizedString(@"Purchase in %@ already(%@).", @"purchaseView"),purchasedString, price];
    }
}


- (IBAction)purchaseAct:(id)sender
{
    [self buttonState:NO];
    
    if (![self canAccessNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Purchases Stopped", @"purchaseView")
                                                                           message:NSLocalizedString(@"Network is not reachable. On the check, please try again.", @"purchaseView")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
        _statusLabel.text = NSLocalizedString(@"ERROR: Network is NotReachable.", @"purchaseView");
        _statusLabel.textColor = [UIColor redColor];
        return;
    }
    
    if (demoPurchase.validProduct != nil)
    {
        // Then, call the purchase method.
        if (![demoPurchase purchaseProduct:demoPurchase.validProduct])           // It does not work this decision !
        {
              dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow Purchases", @"purchaseView")
                                                                               message:NSLocalizedString(@"Before purchasing process, you will need to enable the setting of iOS.", @"purchaseView")
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            });
            _statusLabel.text = NSLocalizedString(@"ERROR: Purchasing is not permitted.", @"purchaseView");
            _statusLabel.textColor = [UIColor redColor];
        } else {
            [SVProgressHUD show];
        }
    }
}

- (IBAction)restoreAct:(id)sender
{
    [self buttonState:NO];

    if (![self canAccessNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Restore Stopped", @"purchaseView")
                                                                           message:NSLocalizedString(@"Network is not reachable. On the check, please try again.", @"purchaseView")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
        _statusLabel.text = NSLocalizedString(@"ERROR: Network is NotReachable.", @"purchaseView");
        _statusLabel.textColor = [UIColor redColor];
        return;
    }
    
    if (demoPurchase.validProduct != nil)
    {
        // Call restore method.
        if (![demoPurchase restorePurchase])                      // It does not work this decision !
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow Purchases", @"purchaseView")
                                                                               message:NSLocalizedString(@"Before restoring process, you will need to enable the setting of iOS.", @"purchaseView")
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            });
            _statusLabel.text = NSLocalizedString(@"ERROR: Purchasing is not permitted.", @"purchaseView");
            _statusLabel.textColor = [UIColor redColor];
        } else {
            [SVProgressHUD show];
        }
    }
}

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    if (productPrice != nil)
    {
       // [self buttonState:YES];
    } else {
       // [self buttonState:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Not Available", @"purchaseView")
                                                                           message:NSLocalizedString(@"This In-App Purchase item is not available in the App Store at this time. Please try again.", @"purchaseView")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

-(void) successfulPurchase:(EBPurchase*)ebp restored:(bool)isRestore identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    // NSLog(@"ViewController successfulPurchase. %@ %@",isRestore?@"restore":@"purchase",productId);
    {
        if ([productId isEqualToString:PERCHASE_ID]==NO)
        {
            NSLog(@"error perchase ID:%@",productId);
            return;
        }
        
        [[purchase sharedInstance]    setPurchaseItem];
        restoreMyself = YES;
        [self buttonState:NO];
        _statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Purchase in %@ already.", @"purchaseView"),[[purchase sharedInstance]  checkPurchaseItem]];
         [SVProgressHUD dismiss];
    }

    if (!isPurchased)
    {
        isPurchased = YES;

        NSString *alertMessage, *thanksMessage;
        if (isRestore) {
            // This was a Restore request.
            if (restoreMyself==YES)
            {
                thanksMessage = NSLocalizedString(@"Thank You!", @"purchaseView");
                alertMessage = NSLocalizedString(@"Your restore process was finished correctly.", @"purchaseView");
            } else {
                thanksMessage = NSLocalizedString(@"You Sorry!", @"purchaseView");
                alertMessage = NSLocalizedString(@"A prior purchase transaction could not be found. To purchased the product, tap the Buy button.", @"purchaseView");
            }
 
        } else {
            // This was a Purchase request.
            thanksMessage = NSLocalizedString(@"Thank You!", @"purchaseView");
            alertMessage = NSLocalizedString(@"Your purchase process was finished correctly.", @"purchaseView");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:thanksMessage
                                                                           message:alertMessage
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Purchase Stopped", @"purchaseView")
                                                                       message:NSLocalizedString(@"Either you cancelled a purchase request or reported a transaction error. Please try again.", @"purchaseView")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
    _statusLabel.text = NSLocalizedString(@"ERROR: Cancelled purchase request.", @"purchaseView");
    _statusLabel.textColor = [UIColor redColor];
    [SVProgressHUD dismiss];
}

-(void) incompleteRestore:(EBPurchase*)ebp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Restore Issue", @"purchaseView")
                                                                       message:NSLocalizedString(@"A prior purchase transaction could not be found. To purchased the product, tap the Buy button.", @"purchaseView")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
    _statusLabel.text = NSLocalizedString(@"ERROR: A prior purchase transaction could not be found.", @"purchaseView");
    _statusLabel.textColor = [UIColor redColor];
    [SVProgressHUD dismiss];
}

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Restore Stopped", @"purchaseView")
                                                                       message:NSLocalizedString(@"Either you cancelled the request or your prior purchase could not be restored. Please try again.", @"purchaseView")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"purchaseView")
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
    _statusLabel.text = NSLocalizedString(@"ERROR: Can not be restored.", @"purchaseView");
    _statusLabel.textColor = [UIColor redColor];
    [SVProgressHUD dismiss];
}

-(void) paymentQueueRemovedTransactions
{
    // NSLog(@"paymentQueueRemovedTransactions >> Complete");
    [SVProgressHUD dismiss];    
}

- (BOOL)canAccessNetwork
{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            // NSLog(@"NotReachable");
            return NO;
            break;
        case ReachableViaWWAN:
            // NSLog(@"ReachableViaWWAN");
            break;
        case ReachableViaWiFi:
            // NSLog(@"ReachableViaWiFi");
            break;
        default:
            // NSLog(@"Unknown status");
            return NO;
            break;
    }
    return YES;
}

@end
