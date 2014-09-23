//
//  Gameplay.m
//  manmove
//
//  Created by dqlkx on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Soldier.h"

@implementation Gameplay{
    CCNode *_house1;
    CCNode *_house2;
    CCNode *_house3;
    CCNode *_house4;
    CCNode *_house5;
    CCNode *drag_redman;
    CCNode *_redman_button;
    CCNode *_greenman_button;
    CCPhysicsNode *_physicsWorld;

}

- (id)init{
    self = [super init];
    if (!self) return(nil);
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //_physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    _physicsWorld.zOrder = 1000;
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
    if (_redman_button.position.x==touchLocation.x&&_redman_button.position.y==touchLocation.y) {
        drag_redman=[CCBReader load:@"redman"];
        [self addChild:drag_redman];
        drag_redman.position=touchLocation;
    }
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Moved");
    CGPoint touchLocation = [touch locationInNode:self];
    drag_redman.position = touchLocation;
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

- (void)burger_play {
    NSLog(@"Burgerman play");
    CCNode* burgerMan = [CCBReader load:@"burgerMan"];
    burgerMan.position = CGPointMake(_house2.position.x - 50, _house2.position.y);
    [self addChild:burgerMan];
}

- (void)launchredman {
    Soldier* redman = [[Soldier alloc] init];
    [redman loadSolider:@"burger-small-left.png" group:@"ourGroup" collisionType:@"healthyCollision"
                        startPos:_house1.position];

    [_physicsWorld addChild: [redman soldier]];
    [redman move:6 targetPos:_house4.position];
}

- (void)launchgreenman {
    
    Soldier* greenman = [[Soldier alloc] init];
    [greenman loadSolider:@"burger-small.png" group:@"enemyGroup" collisionType:@"junkCollision" startPos:_house4.position];
    [_physicsWorld addChild: [greenman soldier]];
    [greenman move:6 targetPos:_house1.position];
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
