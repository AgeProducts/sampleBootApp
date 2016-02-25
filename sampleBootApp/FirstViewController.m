//
//  FirstViewController.m
//  sampleBootApp
//
//  Created by 堀 卓司 on 2015/12/20.
//  Copyright © 2015年 Age Products. All rights reserved.
//

#import "FirstViewController.h"
#import "HowToUseViewController.h"
#import "purchase.h"
// #import "CustomCell2.h"

@import GoogleMobileAds;

@interface FirstViewController () <GADBannerViewDelegate, UITableViewDelegate>
{
   BOOL    bannerIsVisible;
   float   bannerHeight;
   float   bannerWidth;
   CGRect  bannerRect;
   
   CGRect  tableRect;
   CGRect  portraitRect;
   CGRect  landscapeRect;
   
   CGFloat tabbarHeight;
   CGFloat toolbarHeight;
   NSTimer *timer_;
   
   CGFloat framewidth;
}
@property UITableView    *xTableView;
@property NSMutableArray *dataSource;
@property GADBannerView  *bannerView;
@end

@implementation FirstViewController

static NSString * const TableViewCustomCellIdentifier = @"CustomCell";
static NSString * const CellIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
   UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
   view.backgroundColor = [UIColor darkGrayColor];
   tableRect = view.frame;
   
   CGRect rotatedFrame = tableRect;
   landscapeRect = rotatedFrame;
   landscapeRect.size.width = rotatedFrame.size.height;
   landscapeRect.size.height = rotatedFrame.size.width;
   
   self.xTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
   
   //self.xTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
   self.xTableView.dataSource = self;
   self.xTableView.delegate = self;
   [view addSubview:self.xTableView];
   self.view = view;
   self.view.backgroundColor = [UIColor whiteColor];
   
   [self.xTableView registerNib:[UINib nibWithNibName:TableViewCustomCellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
   self.xTableView.backgroundColor = [UIColor whiteColor];
   
   // ad banner
   NSLog(@"> Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);

#ifdef IS_TAB_BAR
   self.tabBarController.tabBar.hidden = NO;
   tabbarHeight =  self.navigationController.tabBarController.tabBar.frame.size.height;
#else
   self.tabBarController.tabBar.hidden = YES;
   tabbarHeight =  0;
#endif
#ifdef IS_TOOL_BAR
   self.navigationController.toolbarHidden = NO;
   toolbarHeight =  self.navigationController.toolbar.frame.size.height;
#else
   self.navigationController.toolbarHidden = YES;
   toolbarHeight =  0;
#endif

   self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
   bannerHeight = self.bannerView.frame.size.height;
   bannerWidth = self.bannerView.frame.size.width;
   bannerRect = CGRectMake((tableRect.size.width-bannerWidth)/2, tableRect.size.height-tabbarHeight-toolbarHeight, bannerWidth, bannerHeight);
      
   portraitRect = CGRectMake(tableRect.origin.x, tableRect.origin.y, tableRect.size.width, tableRect.size.height-tabbarHeight-toolbarHeight);
      
   NSString *purchaseString = [[purchase sharedInstance] checkPurchaseItem];
   if (purchaseString==nil || [purchaseString isEqualToString:DEFAULT_PurchaseString])
   {
      self.bannerView.adUnitID = MY_AD_UNIT_ID;
      self.bannerView.rootViewController = self;
      self.bannerView.delegate = self;
      [self.view addSubview:self.bannerView];
      
      [self.bannerView loadRequest:[GADRequest request]];
      bannerIsVisible = NO;
   }
   [self initStart];
   [self makeTable];
}


#ifdef AD_TEST_TIMER
- (void)startAdDebugTimer
{
   if (![timer_ isValid]) {
      timer_ = [NSTimer scheduledTimerWithTimeInterval:AD_TIMER_INTERVAL
                                                target:self
                                              selector:@selector(adViewTest)
                                              userInfo:nil
                                               repeats:YES];
   }
}

- (void)stopAdDebugTimer
{
   if ([timer_ isValid]) {
      [timer_ invalidate];
   }
}

- (void)adViewTest
{
   int r = rand();
   if (r%2)
      [self adViewDidReceiveAd:nil];
   else
      [self adView:nil didFailToReceiveAdWithError:nil];
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
   //  self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
   [super viewWillAppear:animated];
   dispatch_async(dispatch_get_main_queue(), ^{
      NSString *purchaseString = [[purchase sharedInstance] checkPurchaseItem];
      if (purchaseString!=nil && [purchaseString isEqualToString:DEFAULT_PurchaseString]==NO && self.bannerView!=nil)
      {
         [self adView:nil didFailToReceiveAdWithError:nil];
         self.bannerView.delegate = nil;
      } else {
         self.bannerView.delegate = self;
#ifdef AD_TEST_TIMER
         [self startAdDebugTimer];
#endif
      }
   });
}

- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
   [super viewWillDisappear:animated];
   [self adView:nil didFailToReceiveAdWithError:nil];
   self.bannerView.delegate = nil;
#ifdef AD_TEST_TIMER
   [self stopAdDebugTimer];
#endif
}

/*- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
   // dummy
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{   
   if ([self orientationPortrait]) {
      dispatch_async(dispatch_get_main_queue(), ^{
         NSString *purchaseString = [[purchase sharedInstance] checkPurchaseItem];
         if (purchaseString!=nil && [purchaseString isEqualToString:DEFAULT_PurchaseString]==NO && self.bannerView!=nil)
         {
            [self adView:nil didFailToReceiveAdWithError:nil];
            self.bannerView.delegate = nil;
         } else {
            self.bannerView.delegate = self;
#ifdef AD_TEST_TIMER
            [self startAdDebugTimer];
#endif
         }
      });
   } else {
         [self adView:nil didFailToReceiveAdWithError:nil];
         self.bannerView.delegate = nil;
#ifdef AD_TEST_TIMER
         [self stopAdDebugTimer];
#endif
   }
   [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}*/

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
   if ([self orientationPortrait]) {
      NSString *purchaseString = [[purchase sharedInstance] checkPurchaseItem];
      if (purchaseString!=nil && [purchaseString isEqualToString:DEFAULT_PurchaseString]==NO && self.bannerView!=nil)
      {
         [self adView:nil didFailToReceiveAdWithError:nil];
         self.bannerView.delegate = nil;
      } else {
         self.bannerView.delegate = self;
#ifdef AD_TEST_TIMER
         [self startAdDebugTimer];
#endif
      }
   } else {
      [self adView:nil didFailToReceiveAdWithError:nil];
      self.bannerView.delegate = nil;
#ifdef AD_TEST_TIMER
      [self stopAdDebugTimer];
#endif
   }
   [self.xTableView reloadData];
}

-(void)viewDidLayoutSubviews
{
   [super viewDidLayoutSubviews];
   
   if ([self orientationPortrait])
   {
      self.xTableView.frame = portraitRect;
    } else {
      self.xTableView.frame = landscapeRect;
   }
   
   [self.view layoutIfNeeded];
}

- (BOOL)orientationPortrait
{
   BOOL portrait = NO;
   UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
   switch (orientation) {
      case UIInterfaceOrientationPortrait:
         portrait = YES;
         break;
      default:
         break;
   }
   return portrait;
}


- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
   // NSLog(@"adViewWillLeaveApplication");
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
   // NSLog(@"adViewWillDismissScreen");
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
   // NSLog(@"adViewDidReceiveAd");
   if (bannerIsVisible == NO) {
      bannerIsVisible = YES;
      [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
      [UIView setAnimationDuration:0.3];
      if ([self orientationPortrait]) {
         self.xTableView.frame = CGRectMake(tableRect.origin.x, tableRect.origin.y, tableRect.size.width, tableRect.size.height-bannerHeight);
         self.bannerView.alpha = 1.0f;
         self.bannerView.frame = CGRectMake(bannerRect.origin.x, bannerRect.origin.y-bannerHeight, bannerWidth, bannerHeight);
      } else {
         self.bannerView.alpha = 0.0f;
         self.xTableView.frame = landscapeRect;
      }
      [UIView commitAnimations];
   }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
   // NSLog(@"didFailToReceiveAdWithError");
   if (bannerIsVisible==YES) {
      bannerIsVisible = NO;
      [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
      [UIView setAnimationDuration:0.3];
      if ([self orientationPortrait]) {
         self.xTableView.frame = tableRect;
         self.bannerView.alpha = 0.0f;
         self.bannerView.frame = bannerRect;
      } else {
         self.bannerView.alpha = 0.0f;
         self.xTableView.frame = landscapeRect;
      }
      [UIView commitAnimations];
   }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
   UITableViewCell *cell = [self.xTableView dequeueReusableCellWithIdentifier:CellIdentifier];
   cell.textLabel.text = self.dataSource[indexPath.row];
   return cell;
   
}

- (void)makeTable
{
   NSString *poem =NSLocalizedString(@"POEM",@"ViewController");     // "Kenji Miyazawa" is a famous agricultural poet in Japan.
   self.dataSource = [NSMutableArray new];
   for (NSString *string in [poem componentsSeparatedByString:@"\n"])
      [self.dataSource addObject:string];
}

- (void)initStart
{
   dispatch_async(dispatch_get_main_queue(), ^{
      
      if ([APP_DELEGATE checkInitialMessage]==YES)
      {
         NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Thank you for downloading the \"%@\".\nDo you read the description of the initial setting?",@"ViewController"),APP_DELEGATE.aplName];
         UIAlertController *alertController =
         [UIAlertController alertControllerWithTitle:nil
                                             message:msg
                                      preferredStyle:UIAlertControllerStyleAlert];
         
         [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Read the description.", @"ViewController")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                              [self performSegueWithIdentifier:@"HowToUseInitMSG" sender:self];
                                                           }]];
         
         [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Read later.", @"ViewController")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                              /* NOP */
                                                           }]];
         
         [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"After, hide this message.", @"ViewController")
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                              [APP_DELEGATE setInitialMessage:NO];
                                                           }]];
         
         [self presentViewController:alertController animated:YES completion:nil];
      }
   });

   APP_DELEGATE.isEnableRotation = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   NSString *segueID = [segue identifier];
   
   if ([segueID isEqualToString:@"HowToUseInitMSG"]) {
      HowToUseViewController *howToUseViewController = [segue destinationViewController];
      howToUseViewController.hidesBottomBarWhenPushed = YES;
      howToUseViewController.segueID = segueID;
   }
   /*if ([[segue identifier] isEqualToString:@"showDetail"]) {
      NSIndexPath *indexPath = [self.xTableView indexPathForSelectedRow];
      DetailTableViewController *controller = (DetailTableViewController *)[[segue destinationViewController] topViewController];
      controller.segue = [segue identifier];
   }*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self performSegueWithIdentifier:@"showDetail" sender:self];
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
