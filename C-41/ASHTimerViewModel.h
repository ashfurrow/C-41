//
//  ASHTimerViewModel.h
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

@interface ASHTimerViewModel : RVMViewModel

@property (nonatomic, readonly) NSString *recipeName;
@property (nonatomic, readonly) NSString *currentStepString;
@property (nonatomic, readonly) NSString *nextStepString;
@property (nonatomic, readonly) NSString *timeRemainingString;

@property (nonatomic, readonly, getter = isRunning) BOOL running;
@property (nonatomic, readonly, getter = isComplete) BOOL complete;

-(void)resume;
-(void)pause;

@end
