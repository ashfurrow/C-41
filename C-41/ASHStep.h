//
//  ASHStep.h
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ASHStep : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t agitationDuration;
@property (nonatomic) int32_t agitationFrequency;
@property (nonatomic) int32_t temperatureC;
@property (nonatomic) int32_t duration;
@property (nonatomic, retain) NSString *blurb;
@property (nonatomic, retain) NSManagedObject *recipe;

@end
