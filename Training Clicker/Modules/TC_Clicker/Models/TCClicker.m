//
//  TCClicker.m
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import "TCClicker.h"
#import <AVFoundation/AVFoundation.h>


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants



////////////////////////////////////////////////////////////////////////////////
#pragma mark - C

NSString *NSStringFromTCClickerType(TCClickerType clickerType)
{
    switch (clickerType) {
        case TCClickerTypePurple:

            return @"TCClickerTypePurple";
            break;

        case TCClickerTypeGray:
            return @"TCClickerTypeGray";
            break;
            
        case TCClickerTypeBlue:
            return @"TCClickerTypeBlue";
            break;
            
        case TCClickerTypeRed:
            return @"TCClickerTypeRed";
            break;

        default:
            return @"Unknown";
            break;
    }
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface TCClicker ()

@property (nonatomic, readwrite) TCClickerType clickerType;
@property (nonatomic, strong, readwrite) NSString *clickUpImageFilename;
@property (nonatomic, strong, readwrite) NSString *clickDownImageFilename;
@property (nonatomic, strong, readwrite) NSString *clickDownSoundFilename;
@property (nonatomic, strong, readwrite) NSString *clickUpSoundFilename;

@property (nonatomic, strong) AVAudioPlayer *clickDownSoundAudioPlayer;
@property (nonatomic, strong) AVAudioPlayer *clickUpSoundAudioPlayer;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation TCClicker


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle - Imperatives - Entrypoints

- (id)initWithClickerType:(TCClickerType)clickerType
{
    self = [super init];
    if (self) {
        self.clickerType = clickerType;
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
    self.clickUpImageFilename = [self newClickUpImageFilename];
    self.clickDownImageFilename = [self newClickDownImageFilename];
    self.clickDownSoundFilename = [self newClickDownSoundFilename];
    self.clickUpSoundFilename = [self newClickUpSoundFilename];

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
#pragma mark - Runtime - Accessors - Overrides

- (BOOL)isEqual:(TCClicker *)object
{
    return self.clickerType == object.clickerType;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Clicker %@", NSStringFromTCClickerType(self.clickerType)];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Accessors - Setup transforms

- (NSString *)newClickUpImageFilename
{
    switch (self.clickerType) {
        case TCClickerTypeGray:
        {
            return @"GrayUp";
            break;
        }
        
        case TCClickerTypePurple:
        default:
        {
            return @"PurpleUp";
            break;
        }
        
        case TCClickerTypeBlue:
        {
            return @"BlueUp";
            break;
        }
       
        case TCClickerTypeRed:
        {
            return @"RedUp";
            break;
        }
    }
    
    return nil;
}

- (NSString *)newClickDownImageFilename
{
    switch (self.clickerType) {
        case TCClickerTypeGray:
        {
            return @"GrayDown";
            break;
        }
            
        case TCClickerTypePurple:
        default: 
        {
            return @"PurpleDown";
            break;
        }
            
        case TCClickerTypeBlue:
        {
            return @"BlueDown";
            break;
        }
            
        case TCClickerTypeRed:
        {
            return @"RedDown";
            break;
        }
    }
    
    return nil;
}

- (NSString *)newClickDownSoundFilename
{
    switch (self.clickerType) {
        case TCClickerTypeGray:
        {
            return @"graydownwav";
            break;
        }
            
        case TCClickerTypePurple:
        default:
        {
            return @"purpledownwav";
            break;
        }
            
        case TCClickerTypeBlue:
        {
            return @"bluedownwav";
            break;
        }
            
        case TCClickerTypeRed:
   
        {
            return @"reddownwav";
            break;
        }

    }
    
    return nil;
}

- (NSString *)newClickUpSoundFilename
{
    switch (self.clickerType) {
        case TCClickerTypeGray:
        {
            return @"grayupwav";
            break;
        }
            
        case TCClickerTypePurple:
        default:
        {
            return @"purpleupwav";
            break;
        }
            
        case TCClickerTypeBlue:
        {
            return @"blueupwav";
            break;
        }
            
        case TCClickerTypeRed:
        {
            return @"redupwav";
            break;
        }
    }
    
    return nil;
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives - Sound effects

- (void)playClickDownSound
{
    if (!self.clickDownSoundAudioPlayer) {
        NSError *error = nil;
        NSURL *URL = [[NSBundle mainBundle] URLForResource:self.clickDownSoundFilename withExtension:@"wav"];
        self.clickDownSoundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
        if (error) {
            NSLog(@"There was an error initializing the click down audio player. %@", error);
        }
    }
    [self.clickDownSoundAudioPlayer play];
}

- (void)playClickUpSound
{
    if (!self.clickUpSoundAudioPlayer) {
        NSError *error = nil;
        NSURL *URL = [[NSBundle mainBundle] URLForResource:self.clickUpSoundFilename withExtension:@"wav"];
        self.clickUpSoundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
        if (error) {
            NSLog(@"There was an error initializing the click up audio player. %@", error);
        }
    }
    [self.clickUpSoundAudioPlayer play];
}



- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.clickDownImageFilename = [decoder decodeObjectForKey:@"clickDownFileName"];
    self.clickDownSoundFilename = [decoder decodeObjectForKey:@"clickDownSoundFileName"];
    self.clickUpImageFilename = [decoder decodeObjectForKey:@"clickUpImageFileName"];
    self.clickUpSoundFilename = [decoder decodeObjectForKey:@"clickUpSoundFileName"];
    self.clickerType = [[decoder decodeObjectForKey:@"clickerType"] unsignedIntegerValue];
    return self;
}



- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.clickDownImageFilename forKey:@"clickDownFileName"];
    [encoder encodeObject:self.clickDownSoundFilename forKey:@"clickDownSoundFileName"];
    [encoder encodeObject:self.clickUpImageFilename forKey:@"clickUpImageFileName"];
    [encoder encodeObject:self.clickUpSoundFilename forKey:@"clickUpSoundFileName"];
    [encoder encodeObject:@(self.clickerType) forKey:@"clickerType"];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation


@end
