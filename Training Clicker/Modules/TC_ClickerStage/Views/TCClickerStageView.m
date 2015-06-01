//
//  TCClickerStageView.m
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import "TCClickerStageView.h"
#import "TCClickerButton.h"


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants



////////////////////////////////////////////////////////////////////////////////
#pragma mark - C



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface TCClickerStageView ()


@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation TCClickerStageView


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
    [self setupBackgroundImage];
    [self configure];
    [self startObserving];
}

-(void)setupBackgroundImage
{
    self.backgroundColor = [UIColor colorWithRed:0.953f green:0.824f blue:0.616f alpha:1.00f];
    
    UIView *viewBehindStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, self.frame.size.width)];
    viewBehindStatusBar.backgroundColor = [UIColor blackColor];
    [self addSubview:viewBehindStatusBar];


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
#pragma mark - Runtime - Accessors - Lookups

- (NSUInteger)numberOfColumns
{
    return 2;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Accessors - Factory

- (CGRect)newClickerButtonFrameForButtonAtIndex:(NSUInteger)buttonIndex ofTotalNumberOfClickers:(NSUInteger)totalNumberOfClickers
{
    BOOL totalNumberOfClickersIsEven = totalNumberOfClickers % 2 == 0;
    

    CGFloat topPaddingForAdBanner = 60;
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height - topPaddingForAdBanner;
    CGFloat padding = 5;

    
    CGFloat x = (buttonIndex % 2 == 0) ? 0 : viewWidth / [self numberOfColumns];
    CGFloat h = ([self numberOfColumns] * viewHeight)/(totalNumberOfClickersIsEven ? totalNumberOfClickers : totalNumberOfClickers + 1);
    CGFloat y = h * floorf((float)buttonIndex / (float)[self numberOfColumns]);
    CGFloat w = (!totalNumberOfClickersIsEven && buttonIndex == totalNumberOfClickers - 1) ? viewWidth : (viewWidth / [self numberOfColumns]);
    CGRect frame = CGRectMake(x + 2*padding, y+topPaddingForAdBanner + padding, w - (4*padding), h - (4*padding));
    return frame;
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives

- (void)configure
{
    [self removeAllClickerButtons];
    [self initAndAddAsSubviewTheActiveClickerButtons];
}

- (void)removeAllClickerButtons
{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[TCClickerButton class]]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)initAndAddAsSubviewTheActiveClickerButtons
{
    NSArray *activeClickers = [TCApplicationController sharedApplicationController].applicationState.activeClickers;
    for (TCClicker *clicker in activeClickers) {
        TCClickerButton *button = [[TCClickerButton alloc] initWithClicker:clicker andBehaviorType:TCClickerButtonBehaviorTypeRealClicker];

        [self addSubview:button];
    }
}

- (void)layoutExistentActiveClickerButtons
{
    NSArray *activeClickers = [TCApplicationController sharedApplicationController].applicationState.activeClickers;
    NSUInteger numberOfActiveClickers = activeClickers.count;
    for (UIView *subview in self.subviews) {
        if (![subview isKindOfClass:[TCClickerButton class]]) {
            continue;
        }
        TCClickerButton *button = (TCClickerButton *)subview;
        NSUInteger i = [activeClickers indexOfObject:button.clicker];
        CGRect frame = [self newClickerButtonFrameForButtonAtIndex:i ofTotalNumberOfClickers:numberOfActiveClickers];
        button.frame = frame;
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives - Overrides

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutExistentActiveClickerButtons];
    
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation




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
