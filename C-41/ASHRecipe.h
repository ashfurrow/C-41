//
//  ASHRecipe.h
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ASHStep;

enum ASHRecipeFilmType {
    ASHRecipeFilmTypeColourNegative = 0,
    ASHRecipeFilmTypeColourPositive,
    ASHRecipeFilmTypeBlackAndWhite
};

@interface ASHRecipe : NSManagedObject

@property (nonatomic) int32_t filmType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSOrderedSet *steps;
@end

@interface ASHRecipe (CoreDataGeneratedAccessors)

- (void)insertObject:(ASHStep *)value inStepsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStepsAtIndex:(NSUInteger)idx;
- (void)insertSteps:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStepsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStepsAtIndex:(NSUInteger)idx withObject:(ASHStep *)value;
- (void)replaceStepsAtIndexes:(NSIndexSet *)indexes withSteps:(NSArray *)values;
- (void)addStepsObject:(ASHStep *)value;
- (void)removeStepsObject:(ASHStep *)value;
- (void)addSteps:(NSOrderedSet *)values;
- (void)removeSteps:(NSOrderedSet *)values;
@end
