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

#import "ASHRecipe.h"
#import "ASHStep.h"

#import "ASHEditRecipeViewModel.h"
#import "CoreDataHelpers.h"

SpecBegin(ASHEditRecipeViewModel)

describe(@"ASHEditRecipeViewModel", ^{
    static ASHRecipe *recipe;
    
    beforeEach (^{
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
    
    pending (@"cancel deletes the model iff inserting", ^{
        
    });
    
    pending (@"willDismiss saves the model's context", ^{
        
    });
    
    pending (@"shouldShowCancelButton appears iff inserting",^{
        
    });
    
    pending (@"returns the correct properties of steps and film type", ^{
        
    });
    
    pending (@"returns a correctly instantiated edit step view model", ^{
        
    });
});

SpecEnd
