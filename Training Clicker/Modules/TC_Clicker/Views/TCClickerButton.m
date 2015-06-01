//
//  TCClickerButton.m
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import "TCClickerButton.h"
#import "TCClicker.h"
#import <QuartzCore/QuartzCore.h>


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants



////////////////////////////////////////////////////////////////////////////////
#pragma mark - C



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface TCClickerButton ()

@property (nonatomic, strong, readwrite) TCClicker *clicker;
@property (nonatomic) NSUInteger behaviorType;
@property (nonatomic) BOOL __isToggledOn;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation TCClickerButton


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle - Imperatives - Entrypoints

- (id)initWithClicker:(TCClicker *)clicker andBehaviorType:(TCClickerButtonBehaviorType)behaviorType
{
    self = [super init];
    if (self) {
        self.clicker = clicker;
        self.behaviorType = behaviorType;
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
    [[self imageView] setContentMode: UIViewContentModeScaleAspectFit];

    UIImage *normalImage = [UIImage imageNamed:self.clicker.clickUpImageFilename];
    [self setImage:normalImage forState:UIControlStateNormal];
    if (self.behaviorType == TCClickerButtonBehaviorTypeRealClicker) {
        UIImage *highlightedImage = [UIImage imageNamed:self.clicker.clickDownImageFilename];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
    } else {
        self.adjustsImageWhenHighlighted = YES;
    }
    
    [self addTarget:self action:@selector(touchedDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchedUp) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchedUp) forControlEvents:UIControlEventTouchUpOutside];
    
    [self startObserving];
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
#pragma mark - Runtime - Imperatives - Local State

- (void)setIsToggledOn:(BOOL)isToggledOn
{
    self.__isToggledOn = isToggledOn;
    [self setNeedsDisplay];
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives - Drawing - Overrides

- (void)drawRect:(CGRect)rect
{
    if (self.behaviorType == TCClickerButtonBehaviorTypeToggleButton) {
        if (self.__isToggledOn) {
            [self __drawDotInRect:rect];
        }
    }
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives - Drawing - Local

- (void)__drawDotInRect:(CGRect)rect
{
    CGFloat side = 5;  //4
    CGFloat bottomMargin = 15;   //2
    CGRect frameOfDot = CGRectMake(rect.size.width/2 - side/2, rect.size.height - side - bottomMargin, side, side);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5, [UIColor colorWithRed:0.2 green:0.2 blue:0.9 alpha:1].CGColor);
        
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.2 green:0.2 blue:1 alpha:1].CGColor);
        CGContextFillEllipseInRect(context, frameOfDot);
    }
    CGContextRestoreGState(context);
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation - Interactions

- (void)touchedDown
{
    if (self.behaviorType == TCClickerButtonBehaviorTypeRealClicker) {
        [self.clicker playClickDownSound];
    }
}

- (void)touchedUp
{
    if (self.behaviorType == TCClickerButtonBehaviorTypeRealClicker) {
        [self.clicker playClickUpSound];
    }
}

@end
