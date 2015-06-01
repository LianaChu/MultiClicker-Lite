//
//  TCApplicationState.m
//  Training Clicker
//
//  Copyright (c) 2014 Liana Chu. All rights reserved.
//

#import "TCApplicationState.h"



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

NSString *const TCApplication_notification_clickerWasActivated = @"TCApplication_notification_clickerWasActivated";
NSString *const TCApplication_notification_clickerWasDeactivated = @"TCApplication_notification_clickerWasDeactivated";

NSString *const TCApplication_notification_userInfo_clicker = @"TCApplication_notification_userInfo_clicker";


////////////////////////////////////////////////////////////////////////////////
#pragma mark - C



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface TCApplicationState ()

@property (nonatomic, strong) NSMutableArray *mutableAllClickers;
@property (nonatomic, strong) NSMutableArray *mutableActiveClickers;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation TCApplicationState


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

    
    self.mutableAllClickers = [self newMutableAllClickers];
    self.mutableActiveClickers = [self newMutableActiveClickers];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSData *data = [defaults objectForKey:@"keyForArrayOfActiveClickers"];
    NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.mutableActiveClickers = [[NSMutableArray alloc] initWithArray:oldSavedArray];
    [self activeClickers];

    if (self.mutableActiveClickers.count == 0) {
        [self setupDefaultActiveClickers];
    }

    [self startObserving];
}

- (void)setupDefaultActiveClickers
{
    [self _activateClickerOfType:TCClickerTypePurple andFireNotification:YES];
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
#pragma mark - Runtime - Accessors - All clickers

- (NSArray *)allClickers
{
    return [self.mutableAllClickers copy];
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Accessors - Active clickers

- (NSArray *)activeClickers
{
    return [self.mutableActiveClickers copy];
}

- (BOOL)isClickerActive:(TCClicker *)clicker
{
    return [self.mutableActiveClickers containsObject:clicker];
}

- (NSUInteger)numberOfActiveClickers
{
    return self.mutableActiveClickers.count;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Accessors - Lookups

- (TCClicker *)clickerWithType:(TCClickerType)clickerType
{
    for (TCClicker *clicker in self.mutableAllClickers) {
        if (clicker.clickerType == clickerType) {
            return clicker;
        }
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Accessors - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\nAll clickers: %@\nActive clickers: %@", self.class, self.allClickers, self.activeClickers];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Imperatives

- (BOOL)activateClicker:(TCClicker *)clicker
{
    return [self _activateClicker:clicker andFireNotification:YES];
}

- (BOOL)_activateClicker:(TCClicker *)clicker andFireNotification:(BOOL)fireNotification
{
    if ([self isClickerActive:clicker]) {
        NSLog(@"Warning: Asked to %@%@ but it's already active.", NSStringFromSelector(_cmd), clicker);
        
        return NO;
    }
    [self.mutableActiveClickers addObject:clicker];
    if (fireNotification) {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            NSDictionary *userInfo = @
            {
                TCApplication_notification_userInfo_clicker: clicker
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:TCApplication_notification_clickerWasActivated object:nil userInfo:userInfo];
        });
    }
    
    [self saveArrayOfActiveClickers];

    return YES;
}

- (BOOL)deactivateClicker:(TCClicker *)clicker
{
    if (![self isClickerActive:clicker]) {
        NSLog(@"Warning: Asked to %@%@ but it's not yet active.", NSStringFromSelector(_cmd), clicker);
        
        return NO;
    }
    [self.mutableActiveClickers removeObject:clicker];
    

    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSDictionary *userInfo = @
        {
        TCApplication_notification_userInfo_clicker: clicker
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:TCApplication_notification_clickerWasDeactivated object:nil userInfo:userInfo];
    });
    
    [self saveArrayOfActiveClickers];
    
    return YES;
}

- (BOOL)_activateClickerOfType:(TCClickerType)clickerType andFireNotification:(BOOL)fireNotification
{
    TCClicker *clicker = [self clickerWithType:clickerType];
    if (!clicker) {
        NSLog(@"Warning: Asked to %@%@ but no such clicker exists.", NSStringFromSelector(_cmd), clicker);
        
        return NO;
    }
    return [self _activateClicker:clicker andFireNotification:fireNotification];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Accessors - Factories

- (NSMutableArray *)newMutableAllClickers
{
    NSMutableArray *array = [NSMutableArray new];
    for (TCClickerType clickerType = 0 ; clickerType < TCClickerTypeCount ; clickerType++) {
        TCClicker *clicker = [[TCClicker alloc] initWithClickerType:clickerType];
        [array addObject:clicker];
    }
    
    return array;
}

- (NSMutableArray *)newMutableActiveClickers
{
    return [NSMutableArray new];
}

-(void)saveArrayOfActiveClickers
{
    NSArray *immutableArrayOfActiveClickers = [self.mutableActiveClickers copy];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:immutableArrayOfActiveClickers] forKey:@"keyForArrayOfActiveClickers"];
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Runtime - Delegation


@end
