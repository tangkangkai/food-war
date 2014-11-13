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
    
    _level1.opacity = 0;
    _level2.opacity = 0;
    _level3.opacity = 0;
    
    
    gs=[GameScene shareLayer];
    self.userInteractionEnabled = TRUE;
    textArray = [[NSMutableArray alloc] init];
    [textArray addObject:_level1];
    [textArray addObject:_level2];
    [textArray addObject:_level3];
    if ([SavedData level]) {
        gs.text.string = [NSString stringWithFormat:@"Level %d", [SavedData level]];
    } else {
        gs.text.string = @"Please choose your level";
    }
    //levelArray = [SavedData levelArray];
}
/*

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
}
*/
- (void)level1 {
    [Levels setSelectedLevel:1];
    [self changeLevel:1];
    [self transit:1];
}

- (void)level2 {
    [Levels setSelectedLevel:2];
    [self changeLevel:2];
    [self transit:2];
}

- (void)level3 {
    [Levels setSelectedLevel:3];
    [self changeLevel:3];
    [self transit:3];
}


-(void) showMessage: (CCTextField *)levelText {
    CCActionFadeTo* fadeIn = [CCActionFadeTo actionWithDuration:0.5f opacity:255];
    CCActionFadeTo* fadeOut = [CCActionFadeTo actionWithDuration:0.5f opacity:0];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, fadeOut]];
    [levelText runAction:sequence];
}

- (void)changeLevel: (int) level {
    gs=[GameScene shareLayer];
    NSLog(@"choose level:%d, maxLevel:%d", level, [SavedData level]);
    
    if (level > [SavedData level]) {
        CCTextField *levelText = [textArray objectAtIndex:level-1];
        NSLog(@"scaleX : %f", levelText.scaleX);
//        CCActionMoveTo *moveleft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(levelText.scaleX, levelText.scaleY)];
//        CCActionMoveTo *moveright = [CCActionMoveTo actionWithDuration:0.05f position:ccp(levelText.scaleX , levelText.scaleY)];
//        CCActionMoveTo *moveback = [CCActionMoveTo actionWithDuration:0.05f position:ccp(levelText.scaleX, levelText.scaleY)];
//        
//        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveleft, moveright, moveleft, moveright, moveback]];
//        [textArray objectAtIndex:level-1][0]=@"Level Locked, please choose again";
//        gs.text.string = [NSString stringWithFormat:@"Level %d locked", level];
//        [levelText runAction:sequence];
        levelText.string = @"Level Locked, please choose again";
        [self showMessage:levelText];
//        gs.text.string = @"Level Locked, please choose again";

    }
}

- (void)transit: (int)level {
    if (level <= [SavedData level]) {
        CCScene *choiceScene = [CCBReader loadAsScene:@"ChoiceScene"];
        CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
        [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
    }
    
}
@end
