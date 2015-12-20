//
//  AppDelegate.m
//  sampleBootApp
//
//  Created by 堀 卓司 on 2015/12/20.
//  Copyright © 2015年 Age Products. All rights reserved.
//

#import "AppDelegate.h"
#import "purchase.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initSettings];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    /* If necessary, the background transition notification */
    [self saveDefault];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    /* If necessary, the foreground transition notification */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    /* If necessary, the Terminate notification */
    [self saveDefault];
}

- (void)initSettings
{
    self.isLoadedStatus = [self isLoadedOnceUserDefaults];

    switch (self.isLoadedStatus) {
        case kLoadeFirst: {
            /* The initial treatment of post-installation */
            [[purchase sharedInstance] resetPurchaseItem];
            [self setInitialMessage:YES];
        } break;
        
        case kLoadedPrevios: {
            /* Migration processing */
            if ([[purchase sharedInstance] checkPurchaseItem]==nil)
                [[purchase sharedInstance] resetPurchaseItem];
            [self setInitialMessage:YES];
        } break;
        
        case kLoaded: {
            /* Normal startup */
            if ([[purchase sharedInstance] checkPurchaseItem]==nil)
                [[purchase sharedInstance] resetPurchaseItem];
        } break;
        
        default:
            break;
    }
    [self loadDefault];
    [self setLoadedOnceUserDefaults];
}

- (loadInitType)isLoadedOnceUserDefaults
{
    if (self.userDefaults==nil)
        self.userDefaults =  [NSUserDefaults standardUserDefaults];
    
    if ([self.userDefaults boolForKey:UD_LOADED_ONCE]==YES)
        return kLoaded;
    if ([self.userDefaults boolForKey:UD_LOADED_ONCE_PREVIOS]==YES)
        return kLoadedPrevios;
    return kLoadeFirst;
}

- (void)setLoadedOnceUserDefaults
{
    if ([self.userDefaults boolForKey:UD_LOADED_ONCE_PREVIOS]==YES)
    {
        [self.userDefaults removeObjectForKey:UD_LOADED_ONCE_PREVIOS];
    }
    [self.userDefaults setBool:YES forKey:UD_LOADED_ONCE];
    [self.userDefaults synchronize];
}

- (void)loadDefault
{
    /* Starting common processing */
    self.aplName = [[[NSBundle mainBundle] localizedInfoDictionary]  objectForKey:@"CFBundleDisplayName"];
    self.aplVersionNo = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.aplBuildNo = [[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleVersion"];
}

- (void)saveDefault
{
    /* Common processing at background transition. eg. save cache. */
}

/* Initial Message */
#define UD_InitialMessage_KEY   @"UD_InitialMessage_KEY"
- (BOOL)checkInitialMessage
{
    return [self.userDefaults boolForKey:UD_InitialMessage_KEY];
}

- (void)setInitialMessage:(BOOL)settting
{
    [self.userDefaults setBool:settting forKey:UD_InitialMessage_KEY];
}

@end
