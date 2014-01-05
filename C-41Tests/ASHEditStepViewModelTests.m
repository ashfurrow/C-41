//
//  ASHEditStepViewModelTests.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "TestHelpers.h"

#import "ASHEditStepViewModel.h"

SpecBegin(ASHEditStepViewModel)

describe(@"ASHEditStepViewModel", ^{
    static ASHStep *step;
    
    beforeEach(^{
        NSManagedObjectContext *context = [[ASHCoreDataStack inMemoryStack] managedObjectContext];
        [context reset];
        
        ASHRecipe *recipe = setupRecipe(context);
        step = recipe.steps[0];
    });
    
    it (@"correctly forwards model properties", ^{
        ASHEditStepViewModel *viewModel = [[ASHEditStepViewModel alloc] initWithModel:step];
        
        expect(viewModel.stepName).to.equal(step.name);
        expect(viewModel.stepDescription).to.equal(step.blurb);
        expect(viewModel.temperatureCelcius).to.equal(step.temperatureC);
        expect(viewModel.duration).to.equal(step.duration);
        expect(viewModel.agitationDuration).to.equal(step.agitationDuration);
        expect(viewModel.agitationFrequency).to.equal(step.agitationFrequency);
        
        expect(viewModel.temperatureString).to.equal(@"39℃");
        expect(viewModel.durationString).to.equal(@"For 1:00");
        expect(viewModel.agitationDurationString).to.equal(@"Agitate for 0s");
        expect(viewModel.agitationFrequencyString).to.equal(@"Agitate every 0s");
    });
});

SpecEnd
