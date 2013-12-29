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
@property (nonatomic, readonly) NSString *recipeDescription;
@property (nonatomic, readonly) NSString *timeRemainingString;

@property (nonatomic, readonly, getter = isRunning) BOOL running;

-(void)resume;
-(void)pause;

@end
