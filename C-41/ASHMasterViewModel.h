//
//  ASHMasterViewModel.h
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

@class ASHEditRecipeViewModel, ASHDetailViewModel;

@interface ASHMasterViewModel : RVMViewModel

@property (nonatomic, readonly) RACSignal *updatedContentSignal;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly, nonatomic) NSManagedObjectContext *model;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(NSString *)titleForSection:(NSInteger)section;
-(NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;
-(NSString *)subtitleAtIndexPath:(NSIndexPath *)indexPath;

-(ASHEditRecipeViewModel *)editViewModelForIndexPath:(NSIndexPath *)indexPath;
-(ASHEditRecipeViewModel *)editViewModelForNewRecipe;
-(ASHDetailViewModel *)detailViewModelForIndexPath:(NSIndexPath *)indexPath;

-(void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
