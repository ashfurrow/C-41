//
//  ASHEditRecipeViewModel.h
//  C-41
//
//  Created by Ash Furrow on 12/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

@class ASHRecipe;

@interface ASHEditRecipeViewModel : RVMViewModel

@property (nonatomic, readonly) ASHRecipe *model;
@property (nonatomic, assign, getter = isInserting) BOOL inserting;

@property (nonatomic, strong) NSString *name;

-(BOOL)shouldShowCancelButton;
-(NSInteger)numberOfSteps;
-(void)cancel;
-(void)willDismiss;

@end
