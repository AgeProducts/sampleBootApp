//
//  AppDelegate.h
//  sampleBootApp
//
//  Created by 堀 卓司 on 2015/12/20.
//  Copyright © 2015年 Age Products. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

/* initBoot Status */
typedef enum {
    kLoaded,                // Ordinary boot
    kLoadedPrevios,         // migration
    kLoadeFirst             // entirely new
} loadInitType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (assign) loadInitType   isLoadedStatus;
@property (strong, nonatomic) NSString *aplName;
@property (strong, nonatomic) NSString *aplVersionNo;
@property (strong, nonatomic) NSString *aplBuildNo;
@property bool                isEnableRotation;

- (BOOL)checkInitialMessage;
- (void)setInitialMessage:(BOOL)settting;
@end

