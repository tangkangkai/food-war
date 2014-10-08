//
//  Selectscroll.m
//  demo
//
//  Created by dqlkx on 10/7/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Selectscroll.h"
#import "GameScene.h"
#import "SavedData.h"

@implementation Selectscroll{
    NSMutableArray *levelArray;
    BOOL ifLocked;
    GameScene *gs;
}

- (void) didLoadFromCCB {
    NSLog(@"Enter Game Level Scene");
    gs=[GameScene sharelayer];
    self.userInteractionEnabled = TRUE;
    if ([SavedData level]) {
        gs.text.string = [NSString stringWithFormat:@"Level %d", [SavedData level]];
    } else {
        gs.text.string = @"Please choose your level";
    }
    levelArray = [SavedData levelArray];
}


- (void)level1 {
    NSLog(@"level1 button");
    [self changeLevel:1];
    [self next];
    
}

- (void)level2 {
    NSLog(@"level2 button");
    [self changeLevel:3];
    [self next];
}

- (void)level3 {
    NSLog(@"level3 button");
    [self changeLevel:3];
    [self next];
}

- (void)next {
    if (ifLocked) {
        gs.text.string = @"Level Locked, please choose again";
        return;
    }
    
    CCScene *choiceScene = [CCBReader loadAsScene:@"ChoiceScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
}

- (void)changeLevel: (int) level {
    gs=[GameScene sharelayer];
    if ([[levelArray objectAtIndex:level - 1] intValue] == 0) {
        NSLog(@"level %d:%d",level,[[levelArray objectAtIndex:level - 1] intValue] );
        CCActionMoveTo *moveleft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.4, 0.8)];
        CCActionMoveTo *moveright = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.6, 0.8)];
        CCActionMoveTo *moveback = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.5, 0.8)];
        
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveleft, moveright, moveleft, moveright, moveback]];
        gs.text.string = [NSString stringWithFormat:@"Level %d locked", level];
        [gs.text runAction:sequence];
        ifLocked = true;
        NSLog(@"true");
    } else {
        NSLog(@"level %d:%d",level,[[levelArray objectAtIndex:level - 1] intValue] );
        CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:0.2f angle:360];
        [gs.text runAction:rotate];
        gs.text.string  = [NSString stringWithFormat:@"Level %d", level];
        //   [SavedData setLevel:level];
        ifLocked = false;
        NSLog(@"false");
    }
    
}
@end
