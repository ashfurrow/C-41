//
//  ASHDetailViewModel.h
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

@class ASHTimerViewModel;

@interface ASHDetailViewModel : RVMViewModel

@property (nonatomic, readonly) NSString *photoName;
@property (nonatomic, readonly) NSString *photoDescription;
@property (nonatomic, readonly) NSString *photoFilmTypeString;

@property (nonatomic, readonly) NSInteger numberOfSteps;

-(NSString *)titleForStepAtIndex:(NSInteger)index;
-(NSString *)subtitleForStepAtIndex:(NSInteger)index;

-(ASHTimerViewModel *)timerViewModel;

@end
