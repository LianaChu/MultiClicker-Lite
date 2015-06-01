//
//  TCApplicationState.h
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCClicker.h"

extern NSString *const TCApplication_notification_clickerWasActivated;
extern NSString *const TCApplication_notification_clickerWasDeactivated;

extern NSString *const TCApplication_notification_userInfo_clicker;

@interface TCApplicationState : NSObject

- (NSArray *)allClickers;

- (BOOL)activateClicker:(TCClicker *)clicker;
- (BOOL)deactivateClicker:(TCClicker *)clicker;

- (BOOL)isClickerActive:(TCClicker *)clicker;
- (NSArray *)activeClickers;
- (NSUInteger)numberOfActiveClickers;

@end
