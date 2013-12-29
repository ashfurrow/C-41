//
//  ASHTimerViewModel.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHTimerViewModel.h"

// Models
#import "ASHRecipe.h"
#import "ASHStep.h"

@interface ASHTimerViewModel ()

// Private Access
@property (nonatomic, strong) ASHRecipe *model;

@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, strong) NSString *recipeDescription;
@property (nonatomic, strong) NSString *timeRemainingString;

@property (nonatomic, assign, getter = isRunning) BOOL running;
@property (nonatomic, assign) NSInteger currentStepIndex;
@property (nonatomic, assign) CFTimeInterval currentStepTimeRemaining;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ASHTimerViewModel

-(instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    if (self == nil) return nil;
    
    self.currentStepIndex = 0;
    self.currentStepTimeRemaining = [(ASHStep *)[[self.model steps] objectAtIndex:0] duration];
    
    RAC(self, recipeName) = RACObserve(self.model, name);
    RAC(self, recipeDescription) = RACObserve(self.model, blurb);
    RAC(self, timeRemainingString) = [RACObserve(self, currentStepTimeRemaining) map:^id(NSNumber *value) {
        NSInteger duration = [value integerValue];
        NSInteger minutes = duration / 60;
        NSInteger seconds = duration % 60;
        return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    }];
    
    RAC(self, running) = [RACObserve(self, timer) map:^id(id value) {
        return @(value != nil);
    }];
    
    return self;
}

#pragma mark - Public Methods

-(void)pause {
    [self.timer invalidate], self.timer = nil;
}

-(void)resume {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clockTick:) userInfo:nil repeats:YES];
    }
}

#pragma mark - Private Methods

-(void)clockTick:(NSTimer *)timer {
    self.currentStepTimeRemaining--;
    
    if (self.currentStepTimeRemaining < 0) {
        self.currentStepIndex++;
    }
    
    if (self.currentStepIndex >= self.model.steps.count) {
        //TODO: completion signal
        [self pause];
    }
}

@end
