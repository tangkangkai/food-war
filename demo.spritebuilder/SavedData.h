//
//  SavedData.h
//  demo
//
//  Created by Kangkai Tang on 9/27/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedData : NSObject


// Boolean list to see if level is locked

// Level chosen
@property int level;


// Boolean list to see if soldier is locked

// List of soldier lineups

// Total money
+ (int) money;
+ (void)reduceMoney;
+ (void)deleteSavedData;

+ (void) newData;
+ (void) loadData;

@end
