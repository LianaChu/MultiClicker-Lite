//
//  TCRootViewController.m
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import "TCRootViewController.h"
#import "TCClickerStageView.h"
#import "TCClickerPickerView.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants



////////////////////////////////////////////////////////////////////////////////
#pragma mark - C



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface TCRootViewController ()

@property (nonatomic, strong) TCClickerStageView *clickerStageView;
@property (nonatomic, strong) TCClickerPickerView *clickerPickerView;
@property (nonatomic) BOOL bannerIsVisible;
@property (nonatomic, strong) ADBannerView *adBannerView;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation TCRootViewController


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle - Imperatives - Entrypoints

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)dealloc
{
    [self teardown];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle - Imperatives - Setup

- (void)setup
{
    [self setupViews];
    [self startObserving];
}

- (void)setupViews
{
    [self setupClickerStageView];
    [self setupClickerPickerView];
    
    [self layoutViews];
}


- (void)setupClickerStageView
{
    TCClickerStageView *view = [[TCClickerStageView alloc] init];
    [self.view addSubview:view];
    self.clickerStageView = view;
}

- (void)setupClickerPickerView
{
    TCClickerPickerView *view = [[TCClickerPickerView alloc] init];
    [self.view addSubview:view];
    self.clickerPickerView = view;
}

- (void)startObserving
{
    
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle - Imperatives - Teardown

- (void)teardown
{
    [self stopObserving];
}

- (void)stopObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Accessors - Factories

- (CGRect)newClickerStageViewFrame
{
    CGRect frame = CGRectMake(0, 00, self.view.frame.size.width, self.view.frame.size.height - [TCClickerPickerView viewHeight]);
    
    return frame;
    NSLog(@"newClickerStageViewFrame has been set.");
}

- (CGRect)newClickerPickerViewFrame
{
    CGFloat h = [TCClickerPickerView viewHeight];
    CGFloat y = self.view.frame.size.height - h;
    CGRect frame = CGRectMake(0, y, self.view.frame.size.width, h);
    
    return frame;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives - Configuration

- (void)layoutViews
{
    self.clickerStageView.frame = [self newClickerStageViewFrame];
    self.clickerPickerView.frame = [self newClickerPickerViewFrame];
}

-(void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.adBannerView = adView;
    self.adBannerView.delegate = self;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad Banner did load ad.");
    [self.view addSubview:self.adBannerView];      [UIView animateWithDuration:0.5 animations:^{
        self.adBannerView.alpha = 1.0;
    }];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Unable to show ads. Error: %@", [error localizedDescription]);
    [UIView animateWithDuration:0.5 animations:^{
        self.adBannerView.alpha = 0.0;
    }];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation


@end
