//
//  ASHEditStepViewModel.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHEditStepViewModel.h"

// Model
#import "ASHStep.h"

@interface ASHEditStepViewModel ()

@property (nonatomic, strong) ASHStep *model;

@end

static int32_t ASHEditStepViewModelDefaultTemperature = 23;
static int32_t ASHEditStepViewModelDefaultAgitationDuration = 5;
static int32_t ASHEditStepViewModelDefaultAgitationFrequency = 60;

static int32_t ASHEditStepViewModelTemperatureIncrement = 1;

@implementation ASHEditStepViewModel

-(instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    if (self == nil) return nil;
    
    RACChannelTo(self, stepName) = RACChannelTo(self.model, name);
    RACChannelTo(self, stepDescription) = RACChannelTo(self.model, blurb);
    RACChannelTo(self, temperatureCelcius, @(ASHEditStepViewModelDefaultTemperature)) = RACChannelTo(self.model, temperatureC, @(ASHEditStepViewModelDefaultTemperature));
    RACChannelTo(self, agitationDuration, @(ASHEditStepViewModelDefaultAgitationDuration)) = RACChannelTo(self.model, agitationDuration, @(ASHEditStepViewModelDefaultAgitationDuration));
    RACChannelTo(self, agitationFrequency, @(ASHEditStepViewModelDefaultAgitationFrequency)) = RACChannelTo(self.model, agitationFrequency, @(ASHEditStepViewModelDefaultAgitationFrequency));
    
    RAC(self, temperatureString) = [RACObserve(self, temperatureCelcius) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%d℃", value.integerValue];
    }];
    RAC(self, agitationDurationString) = [RACObserve(self, agitationDuration) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:NSLocalizedString(@"Agitate for %d seconds", @""), value.integerValue];
    }];
    RAC(self, agitationFrequencyString) = [RACObserve(self, agitationFrequency) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:NSLocalizedString(@"Agitate every %d seconds", @""), value.integerValue];
    }];
    
    return self;
}

#pragma mark - Private Methods

-(void)ensureTemperatureBounds {
    if (self.temperatureCelcius < 0) {
        self.temperatureCelcius = 0;
    } else if (self.temperatureCelcius > 100) {
        self.temperatureCelcius = 100;
    }
}

#pragma mark - Public Methods

-(void)increaseTemperature {
    self.temperatureCelcius += ASHEditStepViewModelTemperatureIncrement;
    [self ensureTemperatureBounds];
}

-(void)decreaseTemperature {
    self.temperatureCelcius -= ASHEditStepViewModelTemperatureIncrement;
    [self ensureTemperatureBounds];
}

@end
