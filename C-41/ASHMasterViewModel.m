//
//  ASHMasterViewModel.m
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHMasterViewModel.h"

// Utilities
#import <libextobjc/extobjc.h>

// Models
#import "ASHRecipe.h"

@interface ASHMasterViewModel () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) RACSubject *updatedContentSignal;

-(ASHRecipe *)recipeAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ASHMasterViewModel

-(instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    if (self == nil) return nil;
    
    self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"ASHMasterViewModel updatedContentSignal"];
    
    return self;
}

#pragma mark - Public Methods

-(NSInteger)numberOfSections {
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

-(void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:object];
    
    NSError *error = nil;
    if ([context save:&error] == NO) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    ASHRecipe *recipe = [self recipeAtIndexPath:indexPath];
    return [recipe valueForKey:@keypath(recipe, name)];
}

-(NSString *)subtitleAtIndexPath:(NSIndexPath *)indexPath {
    ASHRecipe *recipe = [self recipeAtIndexPath:indexPath];
    return [recipe valueForKey:@keypath(recipe, blurb)];
}

#pragma mark - Private Methods

-(ASHRecipe *)recipeAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ASHRecipe" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"filmType" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [(RACSubject *)self.updatedContentSignal sendNext:nil];
}

@end
