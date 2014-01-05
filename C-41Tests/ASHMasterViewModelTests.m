//
//  ASHMasterViewModelTests.m
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "TestHelpers.h"

#import "ASHMasterViewModel.h"

// Private Implementation

@interface ASHMasterViewModel () <NSFetchedResultsControllerDelegate>

-(NSManagedObject *)recipeAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - Private Helpers

static id partialMockForViewModel() {
    ASHMasterViewModel *viewModel = [[ASHMasterViewModel alloc] init];
    id mockViewModel = [OCMockObject partialMockForObject:viewModel];
    return mockViewModel;
}

#pragma mark - Tests

SpecBegin(ASHMasterViewModel)

describe(@"ASHMasterViewModel", ^{
    it (@"should return the number of sections returned by the NSFRC", ^{
        id mockFetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        [[[mockFetchedResultsController stub] andReturn:@[[NSObject new]]] sections];
        
        id mockViewModel = partialMockForViewModel();
        [[[mockViewModel stub] andReturn:mockFetchedResultsController] fetchedResultsController];
        
        NSInteger numberOfSections = [mockViewModel numberOfSections];
        expect(numberOfSections).to.equal(1);
    });
    
    it (@"should return the correct number of items in a section by the NSFRC", ^{
        NSUInteger numberOfItems = 42;
        
        id mockSectionInfo = [OCMockObject mockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
        [[[mockSectionInfo stub] andReturnValue:OCMOCK_VALUE(numberOfItems)] numberOfObjects];
        
        id mockFetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        [[[mockFetchedResultsController stub] andReturn:@[mockSectionInfo]] sections];
        
        id mockViewModel = partialMockForViewModel();
        [[[mockViewModel stub] andReturn:mockFetchedResultsController] fetchedResultsController];
        
        NSInteger numberOfItemsInSection = [mockViewModel numberOfItemsInSection:0];
        expect(numberOfItemsInSection).to.equal(numberOfItems);
    });
    
    it (@"shold delete a managed object", ^{
        id mockObject = [OCMockObject mockForClass:[NSManagedObject class]];
        
        id mockManagedObjectContext = [OCMockObject mockForClass:[NSManagedObjectContext class]];
        [[mockManagedObjectContext expect] deleteObject:mockObject];
        [[[mockManagedObjectContext stub] andReturnValue:@(YES)] save:[OCMArg anyObjectRef]];
        
        id mockFetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        [[[mockFetchedResultsController stub] andReturn:mockObject] objectAtIndexPath:OCMOCK_ANY];
        [[[mockFetchedResultsController stub] andReturn:mockManagedObjectContext] managedObjectContext];
        
        id mockViewModel = partialMockForViewModel();
        [[[mockViewModel stub] andReturn:mockFetchedResultsController] fetchedResultsController];
        
        [mockViewModel deleteObjectAtIndexPath:nil];
        
        [mockManagedObjectContext verify];
    });
    
    it (@"should send next on updatedContentSignal when NSFRC delegate method is called", ^{
        id mockSubject = [OCMockObject mockForClass:[RACSubject class]];
        [[mockSubject expect] sendNext:[OCMArg isNil]];
        
        id mockViewModel = partialMockForViewModel();
        [[[mockViewModel stub] andReturn:mockSubject] updatedContentSignal];
        
        [mockViewModel controllerDidChangeContent:nil];
        
        [mockSubject verify];
    });
    
    it (@"should have an updatedContentSignal when initialized", ^{
        ASHMasterViewModel *viewModel = [[ASHMasterViewModel alloc] init];
        expect(viewModel.updatedContentSignal).toNot.beNil();
    });
    
    it (@"should use the model as its MOC", ^{
        id moc = [NSObject new];
        ASHMasterViewModel *viewModel = [[ASHMasterViewModel alloc] initWithModel:moc];
        expect(moc).to.equal(viewModel.model);
    });
    
    it (@"should return the object at an index path", ^{
        id mockObject = [OCMockObject mockForClass:[NSManagedObject class]];
        
        id mockFetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        [[[mockFetchedResultsController stub] andReturn:mockObject] objectAtIndexPath:OCMOCK_ANY];
        
        id mockViewModel = partialMockForViewModel();
        [[[mockViewModel stub] andReturn:mockFetchedResultsController] fetchedResultsController];
        
        id objectAtIndexPath = [mockViewModel recipeAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        expect(objectAtIndexPath).to.equal(mockObject);
    });
    
    it (@"should return the title of the object at that index path", ^{
        NSString *title = @"Title";
        
        id mockObject = [OCMockObject mockForClass:[NSManagedObject class]];
        [[[mockObject expect] andReturn:title] valueForKey:[OCMArg checkWithSelector:@selector(isEqualToString:) onObject:@"name"]];
        
        id mockViewModel = partialMockForViewModel();
        [[[mockViewModel stub] andReturn:mockObject] recipeAtIndexPath:OCMOCK_ANY];
        
        NSString *returnedTitle = [mockViewModel titleAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        expect(title).to.equal(returnedTitle);
        [mockObject verify];
    });
    
    it (@"should return the subtitle of the object at that index path", ^{
        NSString *subtitle = @"blurb";
        
        id mockObject = [OCMockObject mockForClass:[NSManagedObject class]];
        [[[mockObject expect] andReturn:subtitle] valueForKey:[OCMArg checkWithSelector:@selector(isEqualToString:) onObject:@"blurb"]];
        
        id mockViewModel = partialMockForViewModel();
        [[[mockViewModel stub] andReturn:mockObject] recipeAtIndexPath:OCMOCK_ANY];
        
        NSString *returnedSubTitle = [mockViewModel subtitleAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        expect(subtitle).to.equal(returnedSubTitle);
        [mockObject verify];
    });
    
    it (@"should perform a fetch when the view model becomes active", ^{
        id mockFetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        [[mockFetchedResultsController expect] performFetch:nil];
        
        id mockViewModel = partialMockForViewModel();
        [mockViewModel setFetchedResultsController:mockFetchedResultsController];
        
        [mockViewModel setActive:YES];
        
        [mockFetchedResultsController verify];
        [mockFetchedResultsController stopMocking];
    });
});

SpecEnd
