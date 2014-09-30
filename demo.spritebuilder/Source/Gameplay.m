//
//  Gameplay.m
//  manmove
//
//  Created by dqlkx on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Soldier.h"
#import "SavedData.h"
#import "Scrollback.h"

#define BURGER 1;
#define COKE 2;
#define FRIES 3;


@implementation Gameplay{
    CCPhysicsNode *_physicsWorld;
    CCNode *_burgerman;
    CCNode *_cokeman;
    CCNode *_friesman;
    
    Soldier *man;           //save the final man
    Scrollback *scroll;
    NSString *selected_soldier;
    CCNode *_scrollview;
}

- (id)init{
    self = [super init];
    if (!self) return(nil);
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.zOrder = 10000;
    [self addChild:_physicsWorld];
    selected_soldier = NULL;
    man = NULL;
    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Received a touch");
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    Soldier* newSolider = [[Soldier alloc] init];
    
    
    if (CGRectContainsPoint(_burgerman.boundingBox,touchLocation)) {
        selected_soldier = @"burgerMan";
    } else if(CGRectContainsPoint(_cokeman.boundingBox,touchLocation)) {
        selected_soldier = @"cokeMan";
    } else if(CGRectContainsPoint(_friesman.boundingBox,touchLocation)) {
        selected_soldier = @"friesMan";
    }
    
    if (selected_soldier != NULL){
        [newSolider loadSolider:selected_soldier group:@"noGroup"
                    collisionType:@"noCollision" startPos:touchLocation];
        man = newSolider;
        // TODO possible memory leak
        [self addChild: [newSolider soldier]];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    scroll=[_scrollview children][0];
    if( man == NULL ){
        return;
    }
    CCLOG(@"Touch Moved");
    CGPoint touchLocation = [touch locationInNode:self];
    [man soldier].position = touchLocation;
    if (CGRectContainsPoint([scroll track1].boundingBox,touchLocation)) {
        NSLog(@"moved into track 1");
        [scroll track1].visible = true;
    } else if (CGRectContainsPoint([scroll track2].boundingBox, touchLocation)) {
        NSLog(@"moved into track 2");
        [scroll track2].visible = true;
    } else if (CGRectContainsPoint([scroll track3].boundingBox, touchLocation)) {
        NSLog(@"moved into track 3");
        [scroll track3].visible = true;
    } else {
        [scroll trackInvist];
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Ended");
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    if (CGRectContainsPoint([scroll track1].boundingBox,touchLocation)) {
        NSLog(@"located in track 1");
        [self launchmovingman:[scroll house1] dest:[scroll house4]];
    } else if (CGRectContainsPoint([scroll track2].boundingBox, touchLocation)) {
        NSLog(@"located in track 2");
        [self launchmovingman: [scroll house2] dest:[scroll house5]];
    } else if (CGRectContainsPoint([scroll track3].boundingBox, touchLocation)) {
        NSLog(@"located in track 3");
        [self launchmovingman:[scroll house3] dest:[scroll house6]];
    } else {
        [self removeChild:[man soldier]];
    }
    [scroll trackInvist];
}
/*
- (void)trackInvist {
    scroll=[_scrollview children][0];
    [scroll track1].visible = false;
    [scroll track2].visible = false;
    [scroll track3].visible = false;
}*/

- (void)launchmovingman: (CCNode *)sourcehouse dest:(CCNode *)desthouse {
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];
    if( man == NULL ){
        return;
    }
    [self removeChild: [man soldier]];
    man = NULL;
    Soldier* newSolider = [[Soldier alloc] init];
    [newSolider loadSolider:selected_soldier group:@"myGroup"
       collisionType:@"healthyCollision" startPos:sourcehouse.position];
    [_physicsWorld addChild: [newSolider soldier]];
    [newSolider move:desthouse.position];
    selected_soldier = NULL;
}

- (void)addjunk {
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];
    Soldier* test_junk = [[Soldier alloc] init];
    [test_junk loadSolider:@"burgerMan" group:@"enemyGroup" collisionType:@"junkCollision" startPos:[scroll house4].position];
    [test_junk soldier].scaleX *= -1; // TODO remove this after we have more models
    [_physicsWorld addChild: [test_junk soldier]];
    [test_junk move:[scroll house1].position];
}

- (void)test {
    NSLog(@"reduce Money");
    [SavedData deleteSavedData];
}




- (void)save {
    // We're going to save the data to SavedState.plist in our app's documents directory
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"SavedState.plist"];
    
    // Create a dictionary to store all your data
    NSMutableDictionary *dataToSave = [NSMutableDictionary dictionary];
    
    // Store any NSData, NSString, NSArray, NSDictionary, NSDate, and NSNumber directly.  See "NSPropertyListSerialization Class Reference" for more information.
    NSString *myString = @"Hello!";
    [dataToSave setObject:myString forKey:@"MyString"];
    
    
    // Create a serialized NSData instance, which can be written to a plist, from the data we've been storing in our NSMutableDictionary
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

- (void)load {
    // Fetch NSDictionary containing possible saved state
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"SavedStates.plist"];

    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *unarchivedData = (NSDictionary *)[NSPropertyListSerialization
                                                    propertyListFromData:plistXML
                                                    mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                    format:&format
                                                    errorDescription:&errorDesc];
    
    // If NSDictionary exists, look to see if it holds a saved game state
    if (!unarchivedData)
    {
        NSLog(@"hehe");
    }
    else
    {
        // Load property list objects directly
        NSString *myString = [unarchivedData objectForKey:@"MyString"];
        NSLog(@"%@", myString);
    }
}

@end
