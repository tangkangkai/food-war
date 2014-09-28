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

#define BURGER 1;
#define COKE 2;
#define FRIES 3;


@implementation Gameplay{
    CCNode *_house1;
    CCNode *_house2;
    CCNode *_house3;
    CCNode *_house4;
    CCNode *_house5;
    CCNode *_house6;
    
    CCPhysicsNode *_physicsWorld;
    CCNode *_burgerman;
    CCNode *_cokeman;
    CCNode *_friesman;
    
    int soldier;            // TODO
    Soldier *man;           //save the final man
    
    CCNode *_track1;        //invisible track
    CCNode *_track2;
    CCNode *_track3;
    
}

- (id)init{
    self = [super init];
    if (!self) return(nil);
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //_physicsWorld.debugDraw = YES;   // show the physic content
    _physicsWorld.collisionDelegate = self;
    _physicsWorld.zOrder = 10000;
    [self addChild:_physicsWorld];
    
    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Received a touch");
    CGPoint touchLocation = [touch locationInNode:self];
    Soldier* newSolider = [[Soldier alloc] init];
    NSString *soldier_ccb = NULL;
    
    if (CGRectContainsPoint(_burgerman.boundingBox,touchLocation)) {
        soldier_ccb = @"burgerMan";
        soldier = BURGER;
    } else if(CGRectContainsPoint(_cokeman.boundingBox,touchLocation)) {
        soldier_ccb = @"cokeMan";
        soldier = COKE;
    } else if(CGRectContainsPoint(_friesman.boundingBox,touchLocation)) {
        soldier_ccb = @"friesMan";
        soldier = FRIES;
    }
    
    if (soldier_ccb != NULL) {
        [newSolider loadSolider:soldier_ccb group:@"enemyGroup"
                    collisionType:@"noCollision" startPos:touchLocation];
        man = newSolider;
        [_physicsWorld addChild: [newSolider soldier]];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Moved");
    CGPoint touchLocation = [touch locationInNode:self];
    [man soldier].position = touchLocation;
    if (CGRectContainsPoint(_track1.boundingBox,touchLocation)) {
        NSLog(@"moved into track 1");
        _track1.visible = true;
    } else if (CGRectContainsPoint(_track2.boundingBox, touchLocation)) {
        NSLog(@"moved into track 2");
        _track2.visible = true;
    } else if (CGRectContainsPoint(_track3.boundingBox, touchLocation)) {
        NSLog(@"moved into track 3");
        _track3.visible = true;
    } else {
        [self trackInvist];
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Ended");
    CGPoint touchLocation = [touch locationInNode:self];
    //[man removeFromParent];
    if (CGRectContainsPoint(_track1.boundingBox,touchLocation)) {
        NSLog(@"located in track 1");
        [self launchmovingman:_house1 dest:_house4];
    } else if (CGRectContainsPoint(_track2.boundingBox, touchLocation)) {
        NSLog(@"located in track 2");
        [self launchmovingman: _house2 dest:_house5];
    } else if (CGRectContainsPoint(_track3.boundingBox, touchLocation)) {
        NSLog(@"located in track 3");
        [self launchmovingman:_house3 dest:_house6];
    } else {
        [_physicsWorld removeChild:[man soldier]];
    }
    [self trackInvist];
}

- (void)trackInvist {
    _track1.visible = false;
    _track2.visible = false;
    _track3.visible = false;
}

- (void)launchmovingman: (CCNode *)sourcehouse dest:(CCNode *)desthouse {
    [man soldier].physicsBody.collisionType = @"healthyCollision";
    [man soldier].physicsBody.collisionGroup = @"myGroup";
    [man soldier].position = sourcehouse.position;
    [man move:desthouse.position];
}

- (void)addjunk {
    Soldier* test_junk = [[Soldier alloc] init];
    [test_junk loadSolider:@"burgerMan" group:@"enemyGroup" collisionType:@"junkCollision" startPos:_house4.position];
    [test_junk soldier].scaleX *= -1; // TODO remove this after we have more models
    [_physicsWorld addChild: [test_junk soldier]];
    [test_junk move:_house1.position];
    
    [SavedData loadData];
    NSLog(@"%d", [SavedData money]);
}

- (void)test {
    NSLog(@"reduce Money");
    [SavedData deleteSavedData];
}


- (void)menu {
    [[CCDirector sharedDirector] pause];
    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Menu"
                                                message:@"Plese choose"
                                                delegate:self
                                                cancelButtonTitle:@"Resume"
                                                otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Quit Game"];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0){
        NSLog(@"You have clicked Cancel");
        [[CCDirector sharedDirector] resume];
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"You have clicked Quit Game");
        [[CCDirector sharedDirector] resume];
        CCScene *choiceScene = [CCBReader loadAsScene:@"GameScene"];
        CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
        [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair healthyCollision:(CCNode *)healthy junkCollision:(CCNode *)junk{
    [healthy stopAllActions];
    [junk stopAllActions];
    
    NSLog(@"Collision");
    return YES;
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
