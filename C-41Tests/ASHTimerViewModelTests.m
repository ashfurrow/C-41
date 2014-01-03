//
//  ASHTimerViewModeltests.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "ASHTimerViewModel.h"
#import "CoreDataHelpers.h"

SpecBegin(ASHTimerViewModel)

describe(@"ASHTimerViewModel", ^{
    static ASHRecipe *recipe;
    
    beforeEach(^{
        NSManagedObjectContext *context = [[ASHCoreDataStack defaultStack] managedObjectContext];
        [context reset];
        
        recipe = setupRecipe(context);
    });

    pending(@"should map recipeName correctly", ^{
        ASHTimerViewModel *viewModel = [[ASHTimerViewModel alloc] initWithModel:recipe];
        
    });
});

SpecEnd
