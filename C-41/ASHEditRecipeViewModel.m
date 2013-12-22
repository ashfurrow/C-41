//
//  ASHEditRecipeViewModel.m
//  C-41
//
//  Created by Ash Furrow on 12/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHEditRecipeViewModel.h"

// Model
#import "ASHRecipe.h"

@interface ASHEditRecipeViewModel ()

@property (nonatomic, strong) ASHRecipe *model;

@end

@implementation ASHEditRecipeViewModel

-(instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    if (self == nil) return nil;
    
    RAC(self, name) = RACObserve(self.model, name);
    
    return self;
}

#pragma mark - Public Methods

-(BOOL)shouldShowCancelButton {
    return self.inserting == YES;
}

-(NSInteger)numberOfSteps {
    return self.model.steps.count;
}

-(void)cancel {
    if (self.inserting) {
        [self.model.managedObjectContext deleteObject:self.model];
    }
}

-(void)willDismiss {
    [self.model.managedObjectContext save:nil];
}

@end
