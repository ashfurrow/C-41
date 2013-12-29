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

@interface ASHTimerViewModel ()

// Private Access
@property (nonatomic, strong) ASHRecipe *model;
@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, assign, getter = isRunning) BOOL running;

@end

@implementation ASHTimerViewModel

-(instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    if (self == nil) return nil;
    
    RAC(self, recipeName) = RACObserve(self.model, name);
    
    return self;
}

-(void)pause {
    self.running = NO;
}

-(void)resume {
    self.running = YES;
}

@end
