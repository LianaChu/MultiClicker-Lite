//
//  TCApplicationController.h
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCApplicationState.h"

@interface TCApplicationController : UIResponder

@property (nonatomic, strong, readonly) TCApplicationState *applicationState;

+ (TCApplicationController *)sharedApplicationController;

@end
