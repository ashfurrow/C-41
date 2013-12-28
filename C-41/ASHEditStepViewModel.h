//
//  ASHEditStepViewModel.h
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

extern int32_t ASHEditStepViewModelDefaultTemperature;
extern int32_t ASHEditStepViewModelDefaultAgitationDuration;
extern int32_t ASHEditStepViewModelDefaultAgitationFrequency;

@interface ASHEditStepViewModel : RVMViewModel

@property (nonatomic, strong) NSString *stepName;
@property (nonatomic, strong) NSString *stepDescription;
@property (nonatomic, assign) int32_t temperatureCelcius;
@property (nonatomic, assign) int32_t duration;
@property (nonatomic, assign) int32_t agitationDuration;
@property (nonatomic, assign) int32_t agitationFrequency;

@property (nonatomic, strong) NSString *temperatureString;
@property (nonatomic, strong) NSString *durationString;
@property (nonatomic, strong) NSString *agitationDurationString;
@property (nonatomic, strong) NSString *agitationFrequencyString;

@end
