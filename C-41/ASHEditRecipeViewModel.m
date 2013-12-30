//
//  ASHEditRecipeViewModel.m
//  C-41
//
//  Created by Ash Furrow on 12/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

// View Models
#import "ASHEditRecipeViewModel.h"
#import "ASHEditStepViewModel.h"

// Models
#import "ASHRecipe.h"
#import "ASHStep.h"

@interface ASHEditRecipeViewModel ()

@property (nonatomic, strong) ASHRecipe *model;

@end

@implementation ASHEditRecipeViewModel

-(instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    if (self == nil) return nil;
    
    RACChannelTo(self, name) = RACChannelTo(self.model, name);
    RACChannelTo(self, blurb) = RACChannelTo(self.model, blurb);
    RACChannelTo(self, filmType, @(ASHRecipeFilmTypeColourNegative)) = RACChannelTo(self.model, filmType, @(ASHRecipeFilmTypeColourNegative));
    
    return self;
}

#pragma mark - Public Methods

-(BOOL)shouldShowCancelButton {
    return self.inserting == YES;
}

-(NSInteger)numberOfSteps {
    return self.model.steps.count;
}

-(void)cancel {
    if (self.inserting) {
        [self.model.managedObjectContext deleteObject:self.model];
    }
}

-(void)willDismiss {
    [self.model.managedObjectContext save:nil];
}

-(NSInteger)sectionForFilmTpe:(int32_t)filmType {
    return filmType;
}

-(int32_t)filmTypeForSection:(NSInteger)section {
    return section;
}

-(NSString *)titleForFilmTyle:(int32_t)filmType {
    if (filmType == ASHRecipeFilmTypeBlackAndWhite) {
        return NSLocalizedString(@"Black and White", @"Film type cell title");
    } else if (filmType == ASHRecipeFilmTypeColourNegative) {
        return NSLocalizedString(@"Colour Negative", @"Film type cell title");
    } else if (filmType == ASHRecipeFilmTypeColourPositive) {
        return NSLocalizedString(@"Colour Positive", @"Film type cell title");
    }
    
    return nil;
}

-(BOOL)isFilmTypeOfModel:(int32_t)filmType {
    return self.model.filmType == filmType;
}

-(void)addStep {
    ASHStep *step = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:self.model.managedObjectContext];
    step.name = NSLocalizedString(@"New Step", @"Default step name");
    step.temperatureC = ASHEditStepViewModelDefaultTemperature;
    step.agitationDuration = ASHEditStepViewModelDefaultAgitationDuration;
    step.agitationFrequency = ASHEditStepViewModelDefaultAgitationFrequency;
    
    NSMutableOrderedSet *stepsMutableOrderedSet = [self.model.steps mutableCopy];
    [stepsMutableOrderedSet addObject:step];
    
    self.model.steps = [stepsMutableOrderedSet copy];
}

-(void)removeStepAtIndex:(NSInteger)index {
    NSMutableOrderedSet *stepsMutableOrderedSet = [self.model.steps mutableCopy];
    
    NSAssert(index < stepsMutableOrderedSet.count && index >= 0, @"Index must be within bounds of mutable set.");
    [stepsMutableOrderedSet removeObjectAtIndex:index];
    
    self.model.steps = [stepsMutableOrderedSet copy];
}

-(void)moveStepFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    ASHStep *step = [self.model.steps objectAtIndex:fromIndex];
    
    NSMutableOrderedSet *mutableSteps = [self.model.steps mutableCopy];
    [mutableSteps removeObjectAtIndex:fromIndex];
    [mutableSteps insertObject:step atIndex:toIndex];
    
    self.model.steps = [mutableSteps copy];
}

-(NSString *)stepTitleAtIndex:(NSInteger)index {
    return [[self stepAtIndex:index] name];
}

-(ASHStep *)stepAtIndex:(NSInteger)index {
    return [self.model.steps objectAtIndex:index];
}

-(ASHEditStepViewModel *)editStepViewModelAtIndex:(NSInteger)index {
    ASHStep *step = [self stepAtIndex:index];
    
    ASHEditStepViewModel *viewModel = [[ASHEditStepViewModel alloc] initWithModel:step];
    return viewModel;
}

@end
