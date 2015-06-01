//
//  TCClicker.h
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TCClickerTypePurple,
    TCClickerTypeGray,
    TCClickerTypeBlue,
    TCClickerTypeRed,
    TCClickerTypeCount
} TCClickerType;

NSString *NSStringFromTCClickerType(TCClickerType clickerType);

@interface TCClicker : NSObject <NSCoding>

- (id)initWithClickerType:(TCClickerType)clickerType;

@property (nonatomic, readonly) TCClickerType clickerType;
@property (nonatomic, strong, readonly) NSString *clickUpImageFilename;
@property (nonatomic, strong, readonly) NSString *clickDownImageFilename;
@property (nonatomic, strong, readonly) NSString *clickDownSoundFilename;
@property (nonatomic, strong, readonly) NSString *clickUpSoundFilename;
@property (nonatomic, strong, readonly) NSString *iconImageFilename;

- (void)playClickDownSound;
- (void)playClickUpSound;

@end
