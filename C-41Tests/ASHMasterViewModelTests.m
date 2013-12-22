//
//  ASHMasterViewModelTests.m
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "ASHMasterViewModel.h"

SpecBegin(ASHMasterViewModel)

describe(@"ASHMasterViewModel", ^{
    it(@"should return the number of sections returned by the NSFRC", ^{
        id mockFetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        [[[mockFetchedResultsController stub] andReturn:@[[NSObject new]]] sections];
        
        ASHMasterViewModel *viewModel = [[ASHMasterViewModel alloc] init];
        id mockViewModel = [OCMockObject partialMockForObject:viewModel];
        [[[mockViewModel stub] andReturn:mockFetchedResultsController] fetchedResultsController];
        
        NSInteger numberOfSections = [mockViewModel numberOfSections];
        expect(numberOfSections).to.equal(1);
    });
    
    it(@"should return the correct number of items in a section by the NSFRC", ^{
        NSUInteger numberOfItems = 42;
        
        id mockSectionInfo = [OCMockObject mockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
        [[[mockSectionInfo stub] andReturnValue:OCMOCK_VALUE(numberOfItems)] numberOfObjects];
        
        id mockFetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        [[[mockFetchedResultsController stub] andReturn:@[mockSectionInfo]] sections];
        
        ASHMasterViewModel *viewModel = [[ASHMasterViewModel alloc] init];
        id mockViewModel = [OCMockObject partialMockForObject:viewModel];
        [[[mockViewModel stub] andReturn:mockFetchedResultsController] fetchedResultsController];
        
        NSInteger numberOfItemsInSection = [mockViewModel numberOfItemsInSection:0];
        expect(numberOfItemsInSection).to.equal(numberOfItems);
    });
});

SpecEnd