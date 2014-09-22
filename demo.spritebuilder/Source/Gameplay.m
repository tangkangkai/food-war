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
    CCNode *_house5;
    CCNode *_house6;
    CCNode *drag_redman;
    CCNode *drag_greenman;
    CCNode *_redman;       //red man start button
    CCNode *_greenman;     //green man start button
    CCNode *man;           //save the final man
    CCNode *_track;        //invisible track
    CCNode *_background;
    int man_type;      //if red set 0, green set 1
    
    CCSprite* backGround;
    CGSize size;
}


- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Received a touch");
    CGPoint touchLocation = [touch locationInNode:self];

    if (CGRectContainsPoint(_redman.boundingBox,touchLocation)) {
        drag_redman=[CCBReader load:@"redman"];
        man=drag_redman;
        man_type=0;
        [self addChild:man];
        man.position=touchLocation;
    }
    else if(CGRectContainsPoint(_greenman.boundingBox,touchLocation)) {
        drag_greenman=[CCBReader load:@"greenman"];
        man=drag_greenman;
        man_type=1;
        [self addChild:man];
        man.position=touchLocation;
    }

}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Moved");
    CGPoint touchLocation = [touch locationInNode:self];
    man.position = touchLocation;
    

    
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Ended");
    CGPoint touchLocation = [touch locationInNode:self];
    [man removeFromParent];
    if (CGRectContainsPoint(_track.boundingBox,touchLocation)) {
        
        [self launchman];
    }
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

- (void)launchman {
    if (man_type==0) {
        [self launchredman];
    }
    else if (man_type==1){
        [self launchgreenman];
    }

}

- (void)launchredman {
    // loads the Penguin.ccb we have set up in Spritebuilder
    CCNode* redman = [CCBReader load:@"redman"];
    // position the penguin at the bowl of the catapult
    redman.position = _house1.position;
    [self addChild:redman];
    
    CCLOG(@"Hello!");
    CCAction *actionMove=[CCActionMoveTo actionWithDuration:4 position:CGPointMake(_house4.position.x, _house4.position.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [redman runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}

- (void)launchgreenman {
    // loads the Penguin.ccb we have set up in Spritebuilder
    CCNode* greenman = [CCBReader load:@"greenman"];
    // position the penguin at the bowl of the catapult
    greenman.position = _house4.position;
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
