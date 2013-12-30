//
//  ASHAppDelegate.m
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHAppDelegate.h"

#import "ASHCoreDataStack.h"

// View Controllers
#import "ASHMasterViewController.h"

// Models
#import "ASHRecipe.h"
#import "ASHStep.h"

// View Models
#import "ASHMasterViewModel.h"

@implementation ASHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Setup window
    self.window.tintColor = [UIColor colorWithHexString:@"9E4B10"];

    // Setup view controllers
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    ASHMasterViewController *controller = (ASHMasterViewController *)navigationController.topViewController;
    
    ASHMasterViewModel *viewModel = [[ASHMasterViewModel alloc] initWithModel:[ASHCoreDataStack defaultStack].managedObjectContext];
    controller.viewModel = viewModel;
    
    // Setup model
    [self ensureInitialLoad];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[ASHCoreDataStack defaultStack] saveContext];
}

#pragma mark - Private Methods

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
            delta3200Recipe.blurb = NSLocalizedString(@"Black and white process for Ilford's high-ISO film.", @"Initial setup subtitle");
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
            delta400Recipe.blurb = NSLocalizedString(@"Black and white process for Ilford's general-purpose film.", @"Initial setup subtitle");
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
            delta100Recipe.name = NSLocalizedString(@"Ilford Delta 400", @"Initial setup title");
            delta100Recipe.blurb = NSLocalizedString(@"Black and white process for Ilford's low-ISO film.", @"Initial setup subtitle");
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
