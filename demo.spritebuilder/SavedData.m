//
//  SavedData.m
//  demo
//
//  Created by Kangkai Tang on 9/27/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "SavedData.h"


static int money;
static NSString *plistPath;

@implementation SavedData

+ (void)newData {
    // Create a dictionary to store all your data
    NSMutableDictionary *dataToSave = [NSMutableDictionary dictionary];
    // Wrap primitives in NSValue or NSNumber objects.  Here are some examples:
    NSNumber *totalMoney = [NSNumber numberWithInt:1000];
    [dataToSave setObject:totalMoney forKey:@"totalMoney"];
    [self saveDictionary:dataToSave];
}

+ (void)saveMoney {
    NSMutableDictionary *dataToSave = [self getSavedDictionary];
    //update money
    NSNumber *totalMoney = [NSNumber numberWithInt:money];
    [dataToSave setObject:totalMoney forKey:@"totalMoney"];
    [self saveDictionary:dataToSave];
}

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
        [self newData];
        [self loadData];
    }
    else
    {
        // Load money
        NSNumber *totalMoney = [unarchivedData objectForKey:@"totalMoney"];
        money = [totalMoney intValue];
    }
}

+(int)money {return money;}

+(void)reduceMoney {
    money -= 10;
    [self saveMoney];
}

/*
 * Basic Functions
 */

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
