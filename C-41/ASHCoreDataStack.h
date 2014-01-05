//
//  ASHCoreDataStack.h
//  C-41
//
//  Created by Samuel E. Giddins on 12/22/13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASHCoreDataStack : NSObject

+(instancetype)defaultStack;
+(instancetype)inMemoryStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;
-(void)ensureInitialLoad;

@end
