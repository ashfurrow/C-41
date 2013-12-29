//
//  ASHDetailViewModel.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

// View Models
#import "ASHTimerViewModel.h"
#import "ASHDetailViewModel.h"

#import "ASHRecipe.h"
#import "ASHStep.h"

@interface ASHDetailViewModel ()

@property (nonatomic, strong) ASHRecipe *model;

// Private Access
@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, strong) NSString *recipeDescription;
@property (nonatomic, assign) int32_t photoFilmType;

@property (nonatomic, assign) NSInteger numberOfSteps;
@property (nonatomic, assign) BOOL canStartTimer;

@end

@implementation ASHDetailViewModel

-(instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    if (self == nil) return nil;
    
    RAC(self, recipeName) = RACObserve(self.model, name);
    RAC(self, recipeDescription) = RACObserve(self.model, blurb);
    RAC(self, recipeFilmTypeString) = [RACObserve(self.model, filmType) map:^id(NSNumber *filmTypeNumber) {
        int32_t filmType = [filmTypeNumber intValue];
        
        if (filmType == ASHRecipeFilmTypeBlackAndWhite) {
            return NSLocalizedString(@"Black and White", @"Info film type cell");
        } else if (filmType == ASHRecipeFilmTypeColourNegative) {
            return NSLocalizedString(@"Colour Negative", @"Info film type cell");
        } else {
            return NSLocalizedString(@"Colour Positive", @"Info film type cell");
        }
    }];
    RAC(self, numberOfSteps) = [RACObserve(self.model, steps) map:^id(NSOrderedSet *value) {
        return @([value count]);
    }];
    RAC(self, canStartTimer) = [RACObserve(self.model, steps) map:^id(NSOrderedSet *value) {
        return @([value count] > 0);
    }];
    
    return self;
}

#pragma mark - Private Methods

-(ASHStep *)stepAtIndex:(NSInteger)index {
    return [self.model.steps objectAtIndex:index];
}

#pragma mark - Public Methods

-(NSString *)titleForStepAtIndex:(NSInteger)index {
    return [[self stepAtIndex:index] name];
}

-(NSString *)subtitleForStepAtIndex:(NSInteger)index {
    int32_t duration = [[self stepAtIndex:index] duration];
    NSInteger minutes = duration / 60;
    NSInteger seconds = duration % 60;
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

-(ASHTimerViewModel *)timerViewModel {
    ASHTimerViewModel *timerViewModel = [[ASHTimerViewModel alloc] initWithModel:self.model];
    return timerViewModel;
}

@end
