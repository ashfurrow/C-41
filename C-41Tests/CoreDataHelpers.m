//
//  CoreDataHelpers.c
//  C-41
//
//  Created by Ash Furrow on 1/2/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "CoreDataHelpers.h"

ASHRecipe *setupRecipe (NSManagedObjectContext *context) {
    
    ASHRecipe *c41Recipe = [NSEntityDescription insertNewObjectForEntityForName:@"ASHRecipe" inManagedObjectContext:context];
    c41Recipe.name = NSLocalizedString(@"C-41 Colour Process", @"Initial setup title");
    c41Recipe.blurb = NSLocalizedString(@"Standard C-41 colour negative film recipe.", @"Initial setup subtitle");
    c41Recipe.filmType = ASHRecipeFilmTypeColourNegative;
    
    ASHStep *prewashStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:context];
    prewashStep.recipe = c41Recipe;
    prewashStep.name = NSLocalizedString(@"Prewash", @"C-41 Prewash step name");
    prewashStep.blurb = NSLocalizedString(@"Water", @"C-41 prewas step description");
    prewashStep.temperatureC = 39;
    prewashStep.duration = 60;
    
    ASHStep *developerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:context];
    developerStep.recipe = c41Recipe;
    developerStep.name = NSLocalizedString(@"Developer", @"C-41 developer step name");
    developerStep.temperatureC = 39;
    developerStep.agitationDuration = 10;
    developerStep.agitationFrequency = 60;
    developerStep.duration = 210;
    
    ASHStep *blixStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:context];
    blixStep.recipe = c41Recipe;
    blixStep.name = NSLocalizedString(@"Blix", @"C-41 blix step name");
    blixStep.temperatureC = 39;
    blixStep.agitationDuration = 10;
    blixStep.agitationFrequency = 60;
    blixStep.duration = 390;
    
    ASHStep *washStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:context];
    washStep.recipe = c41Recipe;
    washStep.name = NSLocalizedString(@"Wash", @"C-41 wash step name");
    washStep.blurb = NSLocalizedString(@"Water", @"C-41 was step description");
    washStep.temperatureC = 23;
    washStep.agitationDuration = 0;
    washStep.agitationFrequency = 0;
    washStep.duration = 180;
    
    ASHStep *stabilizerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:context];
    stabilizerStep.recipe = c41Recipe;
    stabilizerStep.name = NSLocalizedString(@"Stabilizer", @"C-41 stabilizer step name");
    stabilizerStep.temperatureC = 23;
    stabilizerStep.agitationDuration = 15;
    stabilizerStep.agitationFrequency = 60;
    stabilizerStep.duration = 60;
    
    c41Recipe.steps = [NSOrderedSet orderedSetWithArray:@[prewashStep, developerStep, blixStep, washStep, stabilizerStep]];
    
    return c41Recipe;
}
