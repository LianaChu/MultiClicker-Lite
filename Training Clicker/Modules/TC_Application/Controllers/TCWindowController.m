//
//  TCWindowController.m
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import "TCWindowController.h"
#import "TCRootViewController.h"


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants



////////////////////////////////////////////////////////////////////////////////
#pragma mark - C



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface TCWindowController ()

@property (nonatomic, strong) TCRootViewController *rootViewController;
@property (nonatomic, strong) UIWindow *window;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation TCWindowController


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
    [self setupRootView];
    [self setupWindow];
    [self startObserving];
}

- (void)setupRootView
{
    TCRootViewController *rootViewController = [[TCRootViewController alloc] init];
    self.rootViewController = rootViewController;
}

- (void)setupWindow
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    window.rootViewController = self.rootViewController;
    self.window = window;
    
    [window makeKeyAndVisible];
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
#pragma mark - Runtime - Accessors



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation


@end
