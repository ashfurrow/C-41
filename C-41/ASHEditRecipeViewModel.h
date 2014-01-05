//
//  ASHEditRecipeViewModel.h
//  C-41
//
//  Created by Ash Furrow on 12/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

@class ASHRecipe, ASHEditStepViewModel;

@interface ASHEditRecipeViewModel : RVMViewModel

@property (nonatomic, readonly) ASHRecipe *model;
@property (nonatomic, assign, getter = isInserting) BOOL inserting;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, assign) int32_t filmType;

-(void)cancel;
-(void)willDismiss;
-(void)addStep;
-(void)removeStepAtIndex:(NSInteger)index;
-(void)moveStepFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

-(BOOL)shouldShowCancelButton;

-(NSInteger)numberOfSteps;
-(int32_t)filmTypeForSection:(NSInteger)section;
-(NSInteger)sectionForFilmTpe:(int32_t)filmType;
-(NSString *)titleForFilmTyle:(int32_t)filmType;
-(NSString *)stepTitleAtIndex:(NSInteger)index;
-(ASHEditStepViewModel *)editStepViewModelAtIndex:(NSInteger)index;

@end
