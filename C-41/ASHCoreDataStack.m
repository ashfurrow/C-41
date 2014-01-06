//
//  ASHCoreDataStack.m
//  C-41
//
//  Created by Samuel E. Giddins on 12/22/13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHCoreDataStack.h"

// Models
#import "ASHRecipe.h"
#import "ASHStep.h"

@interface ASHCoreDataStack ()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation ASHCoreDataStack

+(instancetype)defaultStack {
    static ASHCoreDataStack *stack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [[self alloc] init];
    });
    return stack;
}

+(instancetype)inMemoryStack {
    static ASHCoreDataStack *stack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [[self alloc] init];
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[stack managedObjectModel]];
        NSError *error;
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
        stack.persistentStoreCoordinator = persistentStoreCoordinator;
    });
    
    return stack;
}

-(void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"C_41" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return self.managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"C_41.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Public Methods

-(void)ensureInitialLoad {
    NSString *initialLoadKey = @"Initial Load";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL hasInitialLoad = [userDefaults boolForKey:initialLoadKey];
    if (hasInitialLoad == NO) {
        [userDefaults setBool:YES forKey:initialLoadKey];
        
        {
            ASHRecipe *c41Recipe = [NSEntityDescription insertNewObjectForEntityForName:@"ASHRecipe" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            c41Recipe.name = NSLocalizedString(@"C-41 Colour Process", @"Initial setup title");
            c41Recipe.blurb = NSLocalizedString(@"Standard C-41 colour negative film recipe.", @"Initial setup subtitle");
            c41Recipe.filmType = ASHRecipeFilmTypeColourNegative;
            
            ASHStep *prewashStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            prewashStep.recipe = c41Recipe;
            prewashStep.name = NSLocalizedString(@"Prewash", @"C-41 Prewash step name");
            prewashStep.blurb = NSLocalizedString(@"Water", @"C-41 prewas step description");
            prewashStep.temperatureC = 39;
            prewashStep.duration = 60;
            
            ASHStep *developerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            developerStep.recipe = c41Recipe;
            developerStep.name = NSLocalizedString(@"Developer", @"C-41 developer step name");
            developerStep.temperatureC = 39;
            developerStep.agitationDuration = 10;
            developerStep.agitationFrequency = 60;
            developerStep.duration = 210;
            
            ASHStep *blixStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            blixStep.recipe = c41Recipe;
            blixStep.name = NSLocalizedString(@"Blix", @"C-41 blix step name");
            blixStep.temperatureC = 39;
            blixStep.agitationDuration = 10;
            blixStep.agitationFrequency = 60;
            blixStep.duration = 390;
            
            ASHStep *washStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            washStep.recipe = c41Recipe;
            washStep.name = NSLocalizedString(@"Wash", @"C-41 wash step name");
            washStep.blurb = NSLocalizedString(@"Water", @"C-41 was step description");
            washStep.temperatureC = 23;
            washStep.agitationDuration = 0;
            washStep.agitationFrequency = 0;
            washStep.duration = 180;
            
            ASHStep *stabilizerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            stabilizerStep.recipe = c41Recipe;
            stabilizerStep.name = NSLocalizedString(@"Stabilizer", @"C-41 stabilizer step name");
            stabilizerStep.temperatureC = 23;
            stabilizerStep.agitationDuration = 15;
            stabilizerStep.agitationFrequency = 60;
            stabilizerStep.duration = 60;
            
            c41Recipe.steps = [NSOrderedSet orderedSetWithArray:@[prewashStep, developerStep, blixStep, washStep, stabilizerStep]];
        }
        
        
        {
            ASHRecipe *e6Recipe = [NSEntityDescription insertNewObjectForEntityForName:@"ASHRecipe" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            e6Recipe.name = NSLocalizedString(@"E-6 Colour Process", @"Initial setup title");
            e6Recipe.blurb = NSLocalizedString(@"Standard E-6 colour positive film recipe.", @"Initial setup subtitle");
            e6Recipe.filmType = ASHRecipeFilmTypeColourPositive;
            
            ASHStep *prewashStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            prewashStep.recipe = e6Recipe;
            prewashStep.name = NSLocalizedString(@"Prewash", @"E-6 Prewash step name");
            prewashStep.blurb = NSLocalizedString(@"Water", @"E-6 prewas step description");
            prewashStep.temperatureC = 38;
            prewashStep.duration = 60;
            
            ASHStep *firstDeveloperStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            firstDeveloperStep.recipe = e6Recipe;
            firstDeveloperStep.name = NSLocalizedString(@"First Developer", @"E-6 developer step name");
            firstDeveloperStep.temperatureC = 38;
            firstDeveloperStep.agitationDuration = 5;
            firstDeveloperStep.agitationFrequency = 15;
            firstDeveloperStep.duration = 360;
            
            ASHStep *firstWashStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            firstWashStep.recipe = e6Recipe;
            firstWashStep.name = NSLocalizedString(@"Wash", @"E-6 wash step name");
            firstWashStep.blurb = NSLocalizedString(@"Water", @"E-6 was step description");
            firstWashStep.temperatureC = 38;
            firstWashStep.agitationDuration = 0;
            firstWashStep.agitationFrequency = 0;
            firstWashStep.duration = 150;
            
            ASHStep *colourDeveloperStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            colourDeveloperStep.recipe = e6Recipe;
            colourDeveloperStep.name = NSLocalizedString(@"Colour Developer", @"E-6 developer step name");
            colourDeveloperStep.temperatureC = 38;
            colourDeveloperStep.agitationDuration = 5;
            colourDeveloperStep.agitationFrequency = 15;
            colourDeveloperStep.duration = 360;
            
            ASHStep *secondWashStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            secondWashStep.recipe = e6Recipe;
            secondWashStep.name = NSLocalizedString(@"Wash", @"E-6 wash step name");
            secondWashStep.blurb = NSLocalizedString(@"Water", @"E-6 was step description");
            secondWashStep.temperatureC = 38;
            secondWashStep.agitationDuration = 0;
            secondWashStep.agitationFrequency = 0;
            secondWashStep.duration = 150;
            
            ASHStep *blixStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            blixStep.recipe = e6Recipe;
            blixStep.name = NSLocalizedString(@"Blix", @"E-6 blix step name");
            blixStep.temperatureC = 38;
            blixStep.agitationDuration = 5;
            blixStep.agitationFrequency = 15;
            blixStep.duration = 360;
            
            ASHStep *finalWashStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            finalWashStep.recipe = e6Recipe;
            finalWashStep.name = NSLocalizedString(@"Wash", @"E-6 wash step name");
            finalWashStep.blurb = NSLocalizedString(@"Water", @"E-6 was step description");
            finalWashStep.temperatureC = 38;
            finalWashStep.agitationDuration = 0;
            finalWashStep.agitationFrequency = 0;
            finalWashStep.duration = 240;
            
            e6Recipe.steps = [NSOrderedSet orderedSetWithArray:@[prewashStep, firstDeveloperStep, firstWashStep, colourDeveloperStep, secondWashStep, blixStep, finalWashStep]];
        }
        
        {
            ASHRecipe *delta3200Recipe = [NSEntityDescription insertNewObjectForEntityForName:@"ASHRecipe" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            delta3200Recipe.name = NSLocalizedString(@"Ilford Delta 3200", @"Initial setup title");
            delta3200Recipe.blurb = NSLocalizedString(@"Black and white process for Ilford’s high-ISO film.", @"Initial setup subtitle");
            delta3200Recipe.filmType = ASHRecipeFilmTypeBlackAndWhite;
            
            ASHStep *developerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            developerStep.recipe = delta3200Recipe;
            developerStep.name = NSLocalizedString(@"Developer", @"Delta 3200 developer step name");
            developerStep.blurb = NSLocalizedString(@"Ilfosol", @"Delta 3200 developer step description");
            developerStep.temperatureC = 23;
            developerStep.agitationDuration = 10;
            developerStep.agitationFrequency = 60;
            developerStep.duration = 600;
            
            ASHStep *stopBathStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            stopBathStep.recipe = delta3200Recipe;
            stopBathStep.name = NSLocalizedString(@"Stop Bath", @"Delta 3200 stop bath step name");
            stopBathStep.blurb = NSLocalizedString(@"Ilfostop", @"Delta 3200 stop bath step description");
            stopBathStep.temperatureC = 23;
            stopBathStep.agitationDuration = 10;
            stopBathStep.agitationFrequency = 0;
            stopBathStep.duration = 10;
            
            ASHStep *fixerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            fixerStep.recipe = delta3200Recipe;
            fixerStep.name = NSLocalizedString(@"Fixer", @"Delta 3200 fixer step name");
            fixerStep.blurb = NSLocalizedString(@"Ilford Rapid Fixer", @"Delta 3200 fixer step name");
            fixerStep.temperatureC = 23;
            fixerStep.agitationDuration = 10;
            fixerStep.agitationFrequency = 60;
            fixerStep.duration = 180;
            
            ASHStep *washStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            washStep.recipe = delta3200Recipe;
            washStep.name = NSLocalizedString(@"Wash", @"Delta 3200 wash step name");
            washStep.blurb = NSLocalizedString(@"Water", @"Delta 3200 was step description");
            washStep.temperatureC = 23;
            washStep.agitationDuration = 0;
            washStep.agitationFrequency = 0;
            washStep.duration = 300;
            
            delta3200Recipe.steps = [NSOrderedSet orderedSetWithArray:@[developerStep, stopBathStep, fixerStep, washStep]];
        }
        
        {
            ASHRecipe *delta400Recipe = [NSEntityDescription insertNewObjectForEntityForName:@"ASHRecipe" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            delta400Recipe.name = NSLocalizedString(@"Ilford Delta 400", @"Initial setup title");
            delta400Recipe.blurb = NSLocalizedString(@"Black and white process for Ilford’s general-purpose film.", @"Initial setup subtitle");
            delta400Recipe.filmType = ASHRecipeFilmTypeBlackAndWhite;
            
            ASHStep *developerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            developerStep.recipe = delta400Recipe;
            developerStep.name = NSLocalizedString(@"Developer", @"Delta 400 developer step name");
            developerStep.blurb = NSLocalizedString(@"Ilfosol", @"Delta 400 developer step description");
            developerStep.temperatureC = 20;
            developerStep.agitationDuration = 10;
            developerStep.agitationFrequency = 60;
            developerStep.duration = 540;
            
            ASHStep *stopBathStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            stopBathStep.recipe = delta400Recipe;
            stopBathStep.name = NSLocalizedString(@"Stop Bath", @"Delta 400 stop bath step name");
            stopBathStep.blurb = NSLocalizedString(@"Ilfostop", @"Delta 400 stop bath step description");
            stopBathStep.temperatureC = 20;
            stopBathStep.agitationDuration = 10;
            stopBathStep.agitationFrequency = 0;
            stopBathStep.duration = 10;
            
            ASHStep *fixerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            fixerStep.recipe = delta400Recipe;
            fixerStep.name = NSLocalizedString(@"Fixer", @"Delta 400 fixer step name");
            fixerStep.blurb = NSLocalizedString(@"Ilford Rapid Fixer", @"Delta 400 fixer step name");
            fixerStep.temperatureC = 20;
            fixerStep.agitationDuration = 10;
            fixerStep.agitationFrequency = 60;
            fixerStep.duration = 180;
            
            ASHStep *washStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            washStep.recipe = delta400Recipe;
            washStep.name = NSLocalizedString(@"Wash", @"Delta 400 wash step name");
            washStep.blurb = NSLocalizedString(@"Water", @"Delta 400 was step description");
            washStep.temperatureC = 20;
            washStep.agitationDuration = 0;
            washStep.agitationFrequency = 0;
            washStep.duration = 300;
            
            delta400Recipe.steps = [NSOrderedSet orderedSetWithArray:@[developerStep, stopBathStep, fixerStep, washStep]];
        }
        
        {
            ASHRecipe *delta100Recipe = [NSEntityDescription insertNewObjectForEntityForName:@"ASHRecipe" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            delta100Recipe.name = NSLocalizedString(@"Ilford Delta 100", @"Initial setup title");
            delta100Recipe.blurb = NSLocalizedString(@"Black and white process for Ilford’s low-ISO film.", @"Initial setup subtitle");
            delta100Recipe.filmType = ASHRecipeFilmTypeBlackAndWhite;
            
            ASHStep *developerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            developerStep.recipe = delta100Recipe;
            developerStep.name = NSLocalizedString(@"Developer", @"Delta 100 developer step name");
            developerStep.blurb = NSLocalizedString(@"Ilfosol", @"Delta 100 developer step description");
            developerStep.temperatureC = 20;
            developerStep.agitationDuration = 10;
            developerStep.agitationFrequency = 60;
            developerStep.duration = 360;
            
            ASHStep *stopBathStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            stopBathStep.recipe = delta100Recipe;
            stopBathStep.name = NSLocalizedString(@"Stop Bath", @"Delta 100 stop bath step name");
            stopBathStep.blurb = NSLocalizedString(@"Ilfostop", @"Delta 100 stop bath step description");
            stopBathStep.temperatureC = 20;
            stopBathStep.agitationDuration = 10;
            stopBathStep.agitationFrequency = 0;
            stopBathStep.duration = 10;
            
            ASHStep *fixerStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            fixerStep.recipe = delta100Recipe;
            fixerStep.name = NSLocalizedString(@"Fixer", @"Delta 100 fixer step name");
            fixerStep.blurb = NSLocalizedString(@"Ilford Rapid Fixer", @"Delta 100 fixer step name");
            fixerStep.temperatureC = 20;
            fixerStep.agitationDuration = 10;
            fixerStep.agitationFrequency = 60;
            fixerStep.duration = 180;
            
            ASHStep *washStep = [NSEntityDescription insertNewObjectForEntityForName:@"ASHStep" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
            washStep.recipe = delta100Recipe;
            washStep.name = NSLocalizedString(@"Wash", @"Delta 100 wash step name");
            washStep.blurb = NSLocalizedString(@"Water", @"Delta 100 was step description");
            washStep.temperatureC = 20;
            washStep.agitationDuration = 0;
            washStep.agitationFrequency = 0;
            washStep.duration = 300;
            
            delta100Recipe.steps = [NSOrderedSet orderedSetWithArray:@[developerStep, stopBathStep, fixerStep, washStep]];
        }
        
        [[ASHCoreDataStack defaultStack] saveContext];
    }
}

@end
