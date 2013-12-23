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
        
        ASHRecipe *c41Recipe = [NSEntityDescription insertNewObjectForEntityForName:@"ASHRecipe" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
        c41Recipe.name = NSLocalizedString(@"C-41 Colour Process", @"Initial setup title");
        c41Recipe.blurb = NSLocalizedString(@"Standard C-41 colour negative film recipe.", @"Initial setup subtitle");
        c41Recipe.filmType = ASHRecipeFilmTypeColourNegative;
        
        ASHRecipe *delta3200Recipe = [NSEntityDescription insertNewObjectForEntityForName:@"ASHRecipe" inManagedObjectContext:[ASHCoreDataStack defaultStack].managedObjectContext];
        delta3200Recipe.name = NSLocalizedString(@"Ilford Delta 3200", @"Initial setup title");
        delta3200Recipe.blurb = NSLocalizedString(@"Black and white process for Ilford's high-ISO film.", @"Initial setup subtitle");
        delta3200Recipe.filmType = ASHRecipeFilmTypeBlackAndWhite;
        
        [[ASHCoreDataStack defaultStack] saveContext];
    }
}

@end
