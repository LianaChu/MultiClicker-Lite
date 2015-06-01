//
//  TCClickerPickerView.m
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import "TCClickerPickerView.h"
#import "TCClicker.h"
#import "TCApplicationController.h"
#import "TCClickerPickerClickerControlsView.h"


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants



////////////////////////////////////////////////////////////////////////////////
#pragma mark - C



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface TCClickerPickerView ()



@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation TCClickerPickerView


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
    [self setupClickerControlsViews];
    [self setupBackgroundImage];

    [self startObserving];
}

- (void)setupClickerControlsViews
{
    CGFloat topPadding = 10;
    CGFloat controlsViewWidth = [self singularControlsViewWidth];
    NSArray *allClickers = [TCApplicationController sharedApplicationController].applicationState.allClickers;
    int i = 0;
    for (TCClicker *clicker in allClickers) {
        TCClickerPickerClickerControlsView *view = [[TCClickerPickerClickerControlsView alloc] initWithClicker:clicker];
        view.frame = CGRectMake(i * controlsViewWidth, topPadding, controlsViewWidth, [[self class] viewHeight] - topPadding);
        [self addSubview:view];
        i++;
    }
}

-(void)setupBackgroundImage
{
    self.backgroundColor = [UIColor colorWithRed:1.000f green:0.866f blue:0.647f alpha:1.00f];
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

- (CGFloat)singularControlsViewWidth
{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat x = screenWidth/4;
    return x;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives - Overrides

- (void)drawRect:(CGRect)rect
{
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    size_t numLocations = 2;
    CGFloat locations[2] = { 0.4, 0.8 };
    CGFloat components[8] =
    {
        232.0/255.0, 198.0/255.0, 143.0/255.0, 1.0,
        
        192.0/255.0, 158.0/255.0, 103.0/255.0, 1.0
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    {
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, numLocations);
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            {
                CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
            }
            CGContextRestoreGState(context);
        }
        CGGradientRelease(gradient);
    }
    CGColorSpaceRelease(colorSpace);
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class

+ (CGFloat)viewHeight
{
    return 80; 
}

@end
