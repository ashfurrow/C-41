//
//  ASHDetailViewModelTests.m
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
#import "CoreDataHelpers.h"

#import "ASHDetailViewModel.h"


SpecBegin(ASHDetailViewModel)

describe(@"ASHDetailViewModel", ^{
    static ASHRecipe *recipe;
    
    beforeEach(^{
        [[[ASHCoreDataStack defaultStack] managedObjectContext] reset];
        
        recipe = setupRecipe([[ASHCoreDataStack defaultStack] managedObjectContext]);
    });
    
    pending (@"should have the correctly mapped properties", ^{
        
    });
    
    pending (@"should return the correct title/subtitle for steps", ^{
        
    });
    
    pending (@"should return a correctly instantiated timer view model", ^{
        
    });
});

SpecEnd
