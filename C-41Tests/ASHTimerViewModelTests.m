//
//  ASHTimerViewModeltests.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "TestHelpers.h"

#import "ASHTimerViewModel.h"

@interface ASHTimerViewModel ()

-(void)clockTick:(NSTimer *)timer;

@property (nonatomic, assign) NSInteger currentStepIndex;
@property (nonatomic, assign) CFTimeInterval currentStepTimeRemaining;

@property (nonatomic, weak) NSTimer *timer;

@end

SpecBegin(ASHTimerViewModel)

describe(@"ASHTimerViewModel", ^{
    static ASHRecipe *recipe;
    
    beforeEach(^{
        NSManagedObjectContext *context = [[ASHCoreDataStack inMemoryStack] managedObjectContext];
        [context reset];
        
        recipe = setupRecipe(context);
    });

    it(@"should map recipeName correctly", ^{
        ASHTimerViewModel *viewModel = [[ASHTimerViewModel alloc] initWithModel:recipe];
        
        expect(viewModel.currentStepIndex).to.equal(0);
        expect(viewModel.currentStepTimeRemaining).to.equal([(ASHStep *)[[recipe steps] objectAtIndex:0] duration]);
        expect(viewModel.recipeName).to.equal(recipe.name);
        expect(viewModel.currentStepString).to.equal(@"Prewash – 39℃");
        expect(viewModel.nextStepString).to.equal(@"Developer");
        expect(viewModel.timeRemainingString).to.equal(@"1:00");
        expect(viewModel.complete).to.beFalsy();
        expect(viewModel.running).to.beFalsy();
    });
    
    it(@"perform math correctly", ^{
        ASHTimerViewModel *viewModel = [[ASHTimerViewModel alloc] initWithModel:recipe];
        
        expect(viewModel.timer).to.beNil();
        [viewModel resume];
        expect(viewModel.timer).notTo.beNil();
        [viewModel pause];
        expect(viewModel.timer).to.beNil();
        
        viewModel.currentStepTimeRemaining = 60;
        viewModel.currentStepIndex = 0;
        [viewModel clockTick:viewModel.timer];
        
        expect(viewModel.currentStepTimeRemaining).to.equal(60 - 1);
        
        viewModel.currentStepTimeRemaining = 0;
        [viewModel clockTick:viewModel.timer];
        expect(viewModel.currentStepIndex).to.equal(1);
        expect(viewModel.currentStepTimeRemaining).to.equal([(ASHStep *)(recipe.steps[1]) duration]);
    });
});

SpecEnd
