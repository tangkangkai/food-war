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

// List of soldier levels
+ (NSMutableDictionary *)soldierLevel;
+ (void)saveSoldierLevel;
+ (void)setSoldierLevel: (NSMutableDictionary *) soldierLevelDict;

// List of soldier lineups
+ (NSMutableDictionary *)lineupDictonary;
+ (void)saveLineupDict;
+ (void)setLineUp: (NSMutableDictionary *) lineupDict;


// Total money
+ (int) money;
+ (void)setMoney: (int) totalMoney;
+ (void)addMoney: (int)moneyToAdd;
+ (void)saveMoney;

//level
+ (int) level;
+ (void)setLevel: (int) gameLevel;
+ (void)saveLevel;

//level available array
//+ (NSMutableArray *)levelArray;

+ (void)saveDictionary: (NSMutableDictionary *)dataToSave;
+ (void)deleteSavedData;

+ (void) loadData;

@end
