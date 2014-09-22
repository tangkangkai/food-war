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
    Soldier* redman = [[Soldier alloc] init];
    [redman loadSolider:@"redman" startPos:_house1.position];
    [self addChild: [redman soldier]];
    [redman move:5 targetPos:_house4.position];
}

- (void)launchgreenman {
    
    Soldier* redman = [[Soldier alloc] init];
    [redman loadSolider:@"greenman" startPos:_house4.position];
    [self addChild: [redman soldier]];
    [redman move:5 targetPos:_house1.position];
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
