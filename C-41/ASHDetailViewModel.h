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

@property (nonatomic, readonly) NSString *recipeName;
@property (nonatomic, readonly) NSString *recipeDescription;
@property (nonatomic, readonly) NSString *recipeFilmTypeString;

@property (nonatomic, readonly) NSInteger numberOfSteps;
@property (nonatomic, readonly) BOOL canStartTimer;

-(NSString *)titleForStepAtIndex:(NSInteger)index;
-(NSString *)subtitleForStepAtIndex:(NSInteger)index;

-(ASHTimerViewModel *)timerViewModel;

@end
