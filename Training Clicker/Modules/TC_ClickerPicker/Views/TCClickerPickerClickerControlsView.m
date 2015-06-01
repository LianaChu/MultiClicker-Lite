//
//  TCClickerPickerClickerControlsView.m
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import "TCClickerPickerClickerControlsView.h"
#import "TCClicker.h"
#import "TCClickerButton.h"


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants



////////////////////////////////////////////////////////////////////////////////
#pragma mark - C



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface TCClickerPickerClickerControlsView ()

@property (nonatomic, strong) TCClicker *clicker;

@property (nonatomic, strong) TCClickerButton *addRemoveButton;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation TCClickerPickerClickerControlsView


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle - Imperatives - Entrypoints

- (id)initWithClicker:(TCClicker *)clicker
{
    self = [super init];
    if (self) {
        self.clicker = clicker;
        
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
    [self setupAddRemoveButton];
    
    [self configure];
}

- (void)setupAddRemoveButton
{
    TCClickerButton *button = [[TCClickerButton alloc] initWithClicker:self.clicker andBehaviorType:TCClickerButtonBehaviorTypeToggleButton];
    [button addTarget:self action:@selector(addRemoveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0.0, 30.0, 0.0)];
    
    self.addRemoveButton = button;
    [self addSubview:button];
}

- (void)startObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickerWasActivated:) name:TCApplication_notification_clickerWasActivated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickerWasDeactivated:) name:TCApplication_notification_clickerWasDeactivated object:nil];
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

- (CGFloat)addRemoveButtonHeight
{
    return 70;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives - Overrides

- (void)layoutSubviews
{
    CGFloat addRemoveButtonHeight = [self addRemoveButtonHeight];
    self.addRemoveButton.frame = CGRectMake(0, 0, self.frame.size.width, addRemoveButtonHeight);
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives - Configuration

- (void)configure
{
    BOOL isActive = [[TCApplicationController sharedApplicationController].applicationState isClickerActive:self.clicker];
    if (isActive) {
        if ([TCApplicationController sharedApplicationController].applicationState.numberOfActiveClickers > 1) {
            [self.addRemoveButton setTitle:@"-" forState:UIControlStateNormal]; 
            self.addRemoveButton.enabled = YES;
        } else {
            [self.addRemoveButton setTitle:@"" forState:UIControlStateNormal];
            self.addRemoveButton.enabled = NO;
        }
    } else {
        [self.addRemoveButton setTitle:@"+" forState:UIControlStateNormal];
        self.addRemoveButton.enabled = YES;
    }
    [self.addRemoveButton setIsToggledOn:isActive];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation - Interactions

- (void)addRemoveButtonTapped
{
    if ([[TCApplicationController sharedApplicationController].applicationState isClickerActive:self.clicker]) {
        [[TCApplicationController sharedApplicationController].applicationState deactivateClicker:self.clicker];
    } else {
        [[TCApplicationController sharedApplicationController].applicationState activateClicker:self.clicker];
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation - Notifications

- (void)clickerWasActivated:(NSNotification *)note
{
    [self configure];
}

- (void)clickerWasDeactivated:(NSNotification *)note
{
    [self configure];
}

@end
