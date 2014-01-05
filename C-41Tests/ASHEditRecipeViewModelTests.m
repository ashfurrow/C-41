//
//  ASHEditRecipeViewModelTests.m
//  C-41
//
//  Created by Ash Furrow on 12/27/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "CoreDataHelpers.h"

#import "ASHEditRecipeViewModel.h"

SpecBegin(ASHEditRecipeViewModel)

describe(@"ASHEditRecipeViewModel", ^{
    static ASHRecipe *recipe;
    
    beforeEach(^{
        NSManagedObjectContext *context = [[ASHCoreDataStack defaultStack] managedObjectContext];
        [context reset];
        
        recipe = setupRecipe(context);
    });
    
    it (@"it correctly gathers properties from the model", ^{
        ASHEditRecipeViewModel *viewModel = [[ASHEditRecipeViewModel alloc] initWithModel:recipe];
        
        expect(viewModel.name).to.equal(recipe.name);
        expect(viewModel.blurb).to.equal(recipe.blurb);
        expect(viewModel.filmType).to.equal(recipe.filmType);
    });
    
    it (@"cancel deletes the model iff inserting", ^{
        ASHEditRecipeViewModel *viewModel = [[ASHEditRecipeViewModel alloc] initWithModel:recipe];
        
        [viewModel cancel];
        
        expect([[recipe.managedObjectContext deletedObjects] containsObject:recipe]).to.beFalsy();
        
        viewModel.inserting = YES;
        
        [viewModel cancel];
        
        expect([[recipe.managedObjectContext deletedObjects] containsObject:recipe]).to.beTruthy();
    });
    
    it (@"willDismiss saves the model's context", ^{
        __block BOOL saved = NO;
        ASHEditRecipeViewModel *viewModel = [[ASHEditRecipeViewModel alloc] initWithModel:recipe];
        
        id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:recipe.managedObjectContext queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            saved = YES;
        }];
        
        [viewModel willDismiss];
        
        expect(saved).to.beTruthy();
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    });
    
    it (@"shouldShowCancelButton appears iff inserting",^{
        ASHEditRecipeViewModel *viewModel = [[ASHEditRecipeViewModel alloc] initWithModel:recipe];
        
        expect(viewModel.shouldShowCancelButton).to.beFalsy();
        
        viewModel.inserting = YES;
        
        expect(viewModel.shouldShowCancelButton).to.beTruthy();
    });
    
    pending (@"returns the correct properties of steps and film type", ^{
        
    });
    
    pending (@"returns a correctly instantiated edit step view model", ^{
        
    });
});

SpecEnd
