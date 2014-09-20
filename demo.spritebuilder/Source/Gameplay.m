//
//  Gameplay.m
//  manmove
//
//  Created by dqlkx on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"


@implementation Gameplay{
    CCNode *_house1;
    CCNode *_house2;
    CCNode *_house3;
    CCNode *_house4;
    CCNode *drag_redman;
    CCNode *_redman_button;
    CCNode *_greenman_button;
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

- (void)launchredman {
    // loads the Penguin.ccb we have set up in Spritebuilder
    CCNode* redman = [CCBReader load:@"redman"];
    // position the penguin at the bowl of the catapult
    redman.position = _house1.position;
    [self addChild:redman];
    
    CCLOG(@"Hello!");
    CCAction *actionMove=[CCActionMoveTo actionWithDuration:4 position:CGPointMake(_house3.position.x, _house3.position.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [redman runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}

- (void)launchgreenman {
    // loads the Penguin.ccb we have set up in Spritebuilder
    CCNode* greenman = [CCBReader load:@"greenman"];
    // position the penguin at the bowl of the catapult
    greenman.position = _house3.position;
    [self addChild:greenman];
    
    CCLOG(@"Hello!");
    CCAction *actionMove=[CCActionMoveTo actionWithDuration:4 position:CGPointMake(_house1.position.x, _house1.position.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [greenman runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
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



@end
