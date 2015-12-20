//
//  APPChildViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "HTUChildViewController.h"

@interface HTUChildViewController () <UIWebViewDelegate>
@property UIWebView *webView;
@end

@implementation HTUChildViewController

static float const constStatuNaviHeight = 20+44;
static float const constToolBarHeight = 34;
static float const constFrameDist = 5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.webView.delegate = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    float orgWidth = [UIScreen mainScreen].bounds.size.width;
    float orgHeight = [UIScreen mainScreen].bounds.size.height;
    float Width = orgWidth;
    float Height = orgHeight;
    
    Width = Width-constFrameDist*2;
    Height = (Height-constStatuNaviHeight-constToolBarHeight-constFrameDist*3)/2;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    self.webView.frame =
        CGRectMake(constFrameDist, constStatuNaviHeight+constFrameDist,
               Width, orgHeight-constStatuNaviHeight-constToolBarHeight-constFrameDist*4);
    scrollView.frame = CGRectMake(0, 0, 0, 0);

   
    NSString *HowToUseMSG;
    NSURL *url;
    
    if (self.setnumber==0)
    {
        switch (self.index) {
            case 0: {
                HowToUseMSG =  NSLocalizedString(@"p01InitMessage", @"HTUChildView");
                url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:HowToUseMSG ofType:@"htm"]];
            }   break;
            case 1: {
                url = [NSURL URLWithString:MY_VIDEO_URL];
            }   break;
            default: {
            }   break;
        }
    } else if (self.setnumber==1) {
        switch (self.index) {
            case 0: {
                HowToUseMSG =  NSLocalizedString(@"p11Manual", @"HTUChildView");
                url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:HowToUseMSG ofType:@"htm"]];
            }   break;
            case 1: {
                HowToUseMSG =  NSLocalizedString(@"p02InitMovie", @"HTUChildView");
                url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:HowToUseMSG ofType:@"mov"]];
            }   break;
            case 2: {
                HowToUseMSG =  NSLocalizedString(@"p17Acknowledgments", @"HTUChildView");
                url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:HowToUseMSG ofType:@"htm"]];
            } break;
                
            /*
            case 2: {
                HowToUseMSG =  NSLocalizedString(@"p13Manual", @"HTUChildView");
            }   break;
            case 3: {
                HowToUseMSG =  NSLocalizedString(@"p14Manual", @"HTUChildView");
            }   break;
            case 4: {
                HowToUseMSG =  NSLocalizedString(@"p15Manual", @"HTUChildView");
            } break;
            case 5: {
                HowToUseMSG =  NSLocalizedString(@"p16Manual", @"HTUChildView");
            }   break;
            */
                
            default: {
            }   break;
        }
    } else {
        return;
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
    
    [scrollView flashScrollIndicators];
    [self.view addSubview:scrollView];
}

-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
