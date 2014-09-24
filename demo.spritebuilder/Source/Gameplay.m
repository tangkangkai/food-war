//
//  Gameplay.m
//  manmove
//
//  Created by dqlkx on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Soldier.h"

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
    
    CCNode *drag_redman;
    CCNode *_redman_button;
    CCNode *_greenman_button;
    CCPhysicsNode *_physicsWorld;
    
    CCNode *_burgerman;
    CCNode *_cokeman;
    CCNode *_friesman;
    
    
    Soldier *man;           //save the final man
    
    CCNode *_track1;        //invisible track
    CCNode *_track2;
    CCNode *_track3;
    
    int soldier; //
    
}

- (id)init{
    self = [super init];
    if (!self) return(nil);
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //_physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    _physicsWorld.zOrder = 10000;
    [self addChild:_physicsWorld];
    
    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Received a touch");
    CGPoint touchLocation = [touch locationInNode:self];
    Soldier* ourSoldier = [[Soldier alloc] init];
    NSString *tmp = NULL;
    
    if (CGRectContainsPoint(_burgerman.boundingBox,touchLocation)) {
        tmp = @"burgerMan";
        soldier = BURGER;
    } else if(CGRectContainsPoint(_cokeman.boundingBox,touchLocation)) {
        tmp = @"cokeMan";
        soldier = COKE;
    } else if(CGRectContainsPoint(_friesman.boundingBox,touchLocation)) {
        tmp = @"friesMan";
        soldier = FRIES;
    }
    
    if (tmp != NULL) {
        [ourSoldier loadSolider:tmp group:@"ourGroup" collisionType:@"healthyCollision" startPos:touchLocation];
        man = ourSoldier;
        [_physicsWorld addChild: [ourSoldier soldier]];
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
        [self launchmovingman:_track1 source:_house1 dest:_house4];
    } else if (CGRectContainsPoint(_track2.boundingBox, touchLocation)) {
        NSLog(@"located in track 2");
        [self launchmovingman:_track2 source:_house2 dest:_house5];
    } else if (CGRectContainsPoint(_track3.boundingBox, touchLocation)) {
        NSLog(@"located in track 3");
        [self launchmovingman:_track3 source:_house3 dest:_house6];
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

- (void)launchmovingman: (CCNode *)track source:(CCNode *)sourcehouse dest:(CCNode *)desthouse {
    Soldier* newSoldier = man;
    [newSoldier soldier].position = sourcehouse.position;
    [newSoldier move:desthouse.position];
    //    CCAction *actionMove=[CCActionMoveTo actionWithDuration: 5 position:CGPointMake(desthouse.position.x,desthouse.position.y)];
    //    CCAction *actionRemove = [CCActionRemove action];
    //    [newSoldier runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

- (void)addjunk {
    Soldier* greenman = [[Soldier alloc] init];
    [greenman loadSolider:@"burgerMan" group:@"enemyGroup" collisionType:@"junkCollision" startPos:_house4.position];
    [greenman soldier].scaleX *= -1;
    [_physicsWorld addChild: [greenman soldier]];
    [greenman move:_house1.position];
}



- (void)menu {
    [[CCDirector sharedDirector] pause];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Menu"
                                                     message:@"Plese choose"
                                                    delegate:self
                                           cancelButtonTitle:@"Resume"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Quit Game"];
    [alert show];
}


// called on every touch in this scene
- (void)redman_play{
    NSLog(@"redman play");
    [self launchredman];
}

- (void)greenman_play{
    NSLog(@"greenman play");
    [self launchgreenman];
}

- (void)launchredman {
    Soldier* redman = [[Soldier alloc] init];
    [redman loadSolider:@"burgerMan" group:@"ourGroup" collisionType:@"healthyCollision"
               startPos:_house1.position];
    
    [_physicsWorld addChild: [redman soldier]];
    [redman move:_house4.position];
}

- (void)launchgreenman {
    Soldier* greenman = [[Soldier alloc] init];
    [greenman loadSolider:@"burgerMan" group:@"enemyGroup" collisionType:@"junkCollision" startPos:_house4.position];
    [_physicsWorld addChild: [greenman soldier]];
    [greenman move:_house1.position];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0)
    {
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


@end
