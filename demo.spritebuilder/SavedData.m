//
//  SavedData.m
//  demo
//
//  Created by Kangkai Tang on 9/27/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "SavedData.h"


static int money;
static int level;
static NSString *plistPath;
static NSMutableArray *levelArray;

@implementation SavedData

+ (void)loadData {
    // Fetch NSDictionary containing possible saved state
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *unarchivedData = (NSDictionary *)[NSPropertyListSerialization
                                                    propertyListFromData:plistXML
                                                    mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                    format:&format
                                                    errorDescription:&errorDesc];
    
    // If NSDictionary exists, look to see if it holds a saved game state
    if (!unarchivedData)
    {
        NSLog(@"NSDictionary not exists, reload");
        [self createData];
        [self loadData];
    }
    else
    {
        // Load money
        NSNumber *totalMoney = [unarchivedData objectForKey:@"money"];
        money = [totalMoney intValue];
        
        // Load level
        NSNumber *gameLevel = [unarchivedData objectForKey:@"level"];
        level = [gameLevel intValue];
        
        // Load level array
        NSMutableArray *array = [unarchivedData objectForKey:@"levelarray"];
        levelArray = [array copy];
    }
}

// level
+ (int)level {return level;}

+ (void)setLevel: (int) gameLevel {
    level = gameLevel;
}

+ (void)saveLevel {
    NSMutableDictionary *dataToSave = [self getSavedDictionary];
    //update money
    NSNumber *levelNum = [NSNumber numberWithInt:level];
    [dataToSave setObject:levelNum forKey:@"level"];
    [self saveDictionary:dataToSave];
}



//level permission array
+ (NSMutableArray *)levelArray {return levelArray;}

+ (void)setLevelArray: (NSMutableArray *) array {
    levelArray = array;
}

+ (void)saveLevelArray {
    NSMutableDictionary *dataToSave = [self getSavedDictionary];
    //update money
    
    [dataToSave setObject:levelArray forKey:@"levelarray"];
    [self saveDictionary:dataToSave];
}


// money

+ (int)money {return money;}

+ (void)setMoney: (int) totalMoney {
    money = totalMoney;
}

+ (void)addMoney: (int) moneyToAdd {
    money += moneyToAdd;
}
+ (void)saveMoney {
    NSMutableDictionary *dataToSave = [self getSavedDictionary];
    //update money
    NSNumber *totalMoney = [NSNumber numberWithInt:money];
    [dataToSave setObject:totalMoney forKey:@"money"];
    [self saveDictionary:dataToSave];
}

/*
 * Basic Functions
 */
+ (void)createData {
    // Create a dictionary to store all your data
    NSMutableDictionary *dataToSave = [NSMutableDictionary dictionary];
    
    // Wrap primitives in NSNumber objects.
    NSNumber *gameLevel = [NSNumber numberWithInt:1];
    [dataToSave setObject:gameLevel forKey:@"level"];
    NSNumber *totalMoney = [NSNumber numberWithInt:1000];
    [dataToSave setObject:totalMoney forKey:@"money"];
    
    // level permission
    NSNumber *level1 = [NSNumber numberWithInt:1];
    NSNumber *level2 = [NSNumber numberWithInt:1];
    NSNumber *level3 = [NSNumber numberWithInt:0];
    NSNumber *level4 = [NSNumber numberWithInt:0];
    levelArray = [NSMutableArray arrayWithObjects:level1, level2, level3, level4, nil];
    [dataToSave setObject:levelArray forKey:@"levelarray"];
    
    
    [self saveDictionary:dataToSave];
}

+ (NSMutableDictionary *)getSavedDictionary {
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *savedDictionay = (NSDictionary *)[NSPropertyListSerialization
                                                    propertyListFromData:plistXML
                                                    mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                    format:NULL
                                                    errorDescription:NULL];
    
    //copy dictionary from saved data and transfer to a mutable dictionary
    NSMutableDictionary *dataToSave = [savedDictionay mutableCopy];
    return dataToSave;
}

+ (void)saveDictionary: (NSMutableDictionary *)dataToSave {
    NSString *errorDescription;
    NSData *serializedData = [NSPropertyListSerialization dataFromPropertyList:dataToSave
                                                                        format:NSPropertyListXMLFormat_v1_0
                                                              errorDescription:&errorDescription];
    if(serializedData)
    {
        // Write file
        NSError *error;
        BOOL didWrite = [serializedData writeToFile:plistPath options:NSDataWritingFileProtectionComplete error:&error];
        
        NSLog(@"Error while writing: %@", [error description]);
        
        if (didWrite)
            NSLog(@"File did write");
        else
            NSLog(@"File write failed");
    }
    else
    {
        NSLog(@"Error in creating state data dictionary: %@", errorDescription);
    }

}

+ (void)deleteSavedData {
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:plistPath error:&error])
    {
         NSLog(@"Error while deleting: %@", [error description]);
    }
}

+ (void)init {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"SavedData.plist"];
    
}

@end
