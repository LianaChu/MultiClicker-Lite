//
//  TCClickerButton.h
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCClicker;

typedef NS_ENUM(NSUInteger, TCClickerButtonBehaviorType)
{
    TCClickerButtonBehaviorTypeNone,
    TCClickerButtonBehaviorTypeRealClicker,
    TCClickerButtonBehaviorTypeToggleButton
};

@interface TCClickerButton : UIButton

- (id)initWithClicker:(TCClicker *)clicker andBehaviorType:(TCClickerButtonBehaviorType)behaviorType;

@property (nonatomic, strong, readonly) TCClicker *clicker;

- (void)setIsToggledOn:(BOOL)isToggledOn;

@end
