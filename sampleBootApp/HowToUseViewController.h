//
//  HowToUseViewController.h
//  CrossRate
//
//  Created by 堀 卓司 on 2014/08/05.
//  Copyright (c) 2014年 Age products. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowToUseViewController :UIViewController <UIPageViewControllerDataSource, UINavigationControllerDelegate >
@property  (nonatomic, strong) NSString *segueID;
@end
