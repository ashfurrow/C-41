//
//  ASHDetailViewModelTests.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "TestHelpers.h"

#import "ASHDetailViewModel.h"
#import "ASHTimerViewModel.h"


SpecBegin(ASHDetailViewModel)

describe(@"ASHDetailViewModel", ^{
    static ASHRecipe *recipe;
    
    beforeEach(^{
        NSManagedObjectContext *context = [[ASHCoreDataStack inMemoryStack] managedObjectContext];
        [context reset];
        
        recipe = setupRecipe(context);
    });
    
    it (@"should have the correctly mapped properties", ^{
        ASHDetailViewModel *viewModel = [[ASHDetailViewModel alloc] initWithModel:recipe];
        
        expect(viewModel.recipeName).to.equal(recipe.name);
        expect(viewModel.recipeDescription).to.equal(recipe.blurb);
        expect(viewModel.recipeFilmTypeString).to.equal(@"Colour Negative");
    });
    
    it (@"should return the correct title/subtitle for steps", ^{
        ASHDetailViewModel *viewModel = [[ASHDetailViewModel alloc] initWithModel:recipe];
        
        NSString *durationString = @"1:00";
        
        expect([viewModel titleForStepAtIndex:0]).to.equal([recipe.steps[0] name]);
        expect([viewModel subtitleForStepAtIndex:0]).to.equal(durationString);
    });
    
    it (@"should return a correctly instantiated timer view model", ^{
        ASHDetailViewModel *viewModel = [[ASHDetailViewModel alloc] initWithModel:recipe];
        
        ASHTimerViewModel *timerViewModel = [viewModel timerViewModel];
        
        expect(timerViewModel.model).to.equal(viewModel.model);
    });
});

SpecEnd
