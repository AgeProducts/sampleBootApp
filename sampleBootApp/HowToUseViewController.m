//
//  HowToUseViewController.m
//  CrossRate
//
//  Created by 堀 卓司 on 2014/08/05.
//  Copyright (c) 2014年 Age products. All rights reserved.
//

#define SCREEN_NUMBER_SET0 2
#define SCREEN_NUMBER_SET1 3

#import "HowToUseViewController.h"
#import "HTUChildViewController.h"

@interface HowToUseViewController ()
    
@property (nonatomic, strong) UIPageControl *pageControl;
@property (assign) NSInteger screen_count;
@property (assign) NSInteger screen_set;

@end

@implementation HowToUseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    UIPageViewController *pageController;

    [super viewDidLoad];
    
    float Width = [UIScreen mainScreen].bounds.size.width;
    float Height = [UIScreen mainScreen].bounds.size.height;
    
    if ([self.segueID isEqualToString:@"HowToUseInitMSG"])
    {
        self.screen_set = 0;
        self.screen_count = SCREEN_NUMBER_SET0;
    } else {
        self.screen_set = 1;
        self.screen_count = SCREEN_NUMBER_SET1;
    }
    
    pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                          options:nil];
    pageController.dataSource = self;
    pageController.view.frame = CGRectMake(0.0f, 0.0f, Width, Height);
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.backgroundColor = [UIColor blueColor];
    
    HTUChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (HTUChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    HTUChildViewController *childViewController =
            [[self storyboard] instantiateViewControllerWithIdentifier:@"HTUChildViewController"];
    childViewController.index = index;
    childViewController.setnumber = self.screen_set;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                    viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(HTUChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                        viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(HTUChildViewController *)viewController index];
    index++;
    if (index == self.screen_count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.screen_count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
