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

int32_t ASHEditStepViewModelDefaultTemperature = 23;
int32_t ASHEditStepViewModelDefaultDuration = 180;
int32_t ASHEditStepViewModelDefaultAgitationDuration = 5;
int32_t ASHEditStepViewModelDefaultAgitationFrequency = 60;

@implementation ASHEditStepViewModel

-(instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    if (self == nil) return nil;
    
    RACChannelTo(self, stepName) = RACChannelTo(self.model, name);
    RACChannelTo(self, stepDescription) = RACChannelTo(self.model, blurb);
    RACChannelTo(self, temperatureCelcius, @(ASHEditStepViewModelDefaultTemperature)) = RACChannelTo(self.model, temperatureC, @(ASHEditStepViewModelDefaultTemperature));
    RACChannelTo(self, duration, @(ASHEditStepViewModelDefaultDuration)) = RACChannelTo(self.model, duration, @(ASHEditStepViewModelDefaultDuration));
    RACChannelTo(self, agitationDuration, @(ASHEditStepViewModelDefaultAgitationDuration)) = RACChannelTo(self.model, agitationDuration, @(ASHEditStepViewModelDefaultAgitationDuration));
    RACChannelTo(self, agitationFrequency, @(ASHEditStepViewModelDefaultAgitationFrequency)) = RACChannelTo(self.model, agitationFrequency, @(ASHEditStepViewModelDefaultAgitationFrequency));
    
    RAC(self, temperatureString) = [RACObserve(self, temperatureCelcius) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%d℃", value.integerValue];
    }];
    RAC(self, durationString) = [RACObserve(self, duration) map:^id(NSNumber *value) {
        NSInteger minutes = value.integerValue / 60;
        NSInteger seconds = value.integerValue % 60;
        
        return [NSString stringWithFormat:@"For %d:%02d", minutes, seconds];
    }];
    RAC(self, agitationDurationString) = [RACObserve(self, agitationDuration) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:NSLocalizedString(@"Agitate for %ds", @""), value.integerValue];
    }];
    RAC(self, agitationFrequencyString) = [RACObserve(self, agitationFrequency) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:NSLocalizedString(@"Agitate every %ds", @""), value.integerValue];
    }];
    
    return self;
}

@end
