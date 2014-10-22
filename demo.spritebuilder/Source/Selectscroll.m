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
#import "Level.h"

@implementation Selectscroll{
    NSMutableArray *levelArray;
    BOOL ifLocked;
    GameScene *gs;
    CCTextField *_level1;
    CCTextField *_level2;
    CCTextField *_level3;
    NSMutableArray *textArray;
    
}

- (void) didLoadFromCCB {
    NSLog(@"Enter Game Level Scene");
    gs=[GameScene shareLayer];
    self.userInteractionEnabled = TRUE;
    textArray = [[NSMutableArray alloc] init];
    [textArray addObject:_level1];
    [textArray addObject:_level2];
    [textArray addObject:_level3];
    [ Levels initLevels ];
    if ([SavedData level]) {
        gs.text.string = [NSString stringWithFormat:@"Level %d", [SavedData level]];
    } else {
        gs.text.string = @"Please choose your level";
    }
    levelArray = [SavedData levelArray];
}


- (void)level1 {
    [Levels setSelectedLevel:1];
    [self changeLevel:1];
}

- (void)level2 {
    [Levels setSelectedLevel:2];
    [self changeLevel:2];
}

- (void)level3 {
    [Levels setSelectedLevel:3];
    [self changeLevel:3];
}


- (void)changeLevel: (int) level {
    gs=[GameScene shareLayer];
    if ([[levelArray objectAtIndex:level - 1] intValue] == 0) {
        NSLog(@"level %d:%d",level,[[levelArray objectAtIndex:level - 1] intValue] );
//        CCActionMoveTo *moveleft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.4, 0.8)];
//        CCActionMoveTo *moveright = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.6, 0.8)];
//        CCActionMoveTo *moveback = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.5, 0.8)];
//        
//        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveleft, moveright, moveleft, moveright, moveback]];
     //   [textArray objectAtIndex:level-1][0]=@"Level Locked, please choose again";
     //   gs.text.string = [NSString stringWithFormat:@"Level %d locked", level];
     //   [[textArray objectAtIndex:level-1] runAction:sequence];
        gs.text.string = @"Level Locked, please choose again";
    } else {
        CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:0.2f angle:360];
        [gs.text runAction:rotate];
        
        gs.text.string  = [NSString stringWithFormat:@"Level %d", level];
        CCScene *choiceScene = [CCBReader loadAsScene:@"ChoiceScene"];
        CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
        [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
    }
}
@end
