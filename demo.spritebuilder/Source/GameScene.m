//
//  GameScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "SavedData.h"
#import "Selectscroll.h"

static GameScene* GameSceneInstance;

@implementation GameScene {
    //CCTextField *_text;
    NSMutableArray *levelArray;
    BOOL ifLocked;
    Selectscroll *ss;
    CCNode *_gs_scroll;
    
}

+(GameScene*)sharelayer{
    return GameSceneInstance;
}

-(id) init
{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super" return value
    if( (self=[super init])) {
        GameSceneInstance=self;
        
        Selectscroll* sl=[[Selectscroll alloc] init];
    //    sl.tag=10;
        [self addChild:sl z:100];
   //     self.isTouchEnabled=YES;
        
    }
    return self;
}

- (void) didLoadFromCCB {
    NSLog(@"Enter Game Level Scene");
    self.userInteractionEnabled = TRUE;
 //   ss=[_gs_scroll children][0];
    if ([SavedData level]) {
        _text.string = [NSString stringWithFormat:@"Level %d", [SavedData level]];
    } else {
        _text.string = @"Please choose your level";
    }
    levelArray = [SavedData levelArray];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"mouse is moving");
    
}

- (void) back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionRight duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:trans];
}

- (void) store {
    CCScene *storeScene = [CCBReader loadAsScene:@"StoreScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionUp duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:storeScene withTransition:trans];
}

- (void)next {
    if (ifLocked) {
        _text.string = @"Level Locked, please choose again";
        return;
    }
    
    CCScene *choiceScene = [CCBReader loadAsScene:@"ChoiceScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
}

/*
- (void)level1 {
    NSLog(@"level1 button");
    [self changeLevel:1];
}

- (void)level2 {
    NSLog(@"level2 button");
    [self changeLevel:2];
}

- (void)level3 {
    NSLog(@"level3 button");
    [self changeLevel:3];
    
}

- (void)level4 {
    NSLog(@"level4 button");
    [self changeLevel:4];
}
*/
- (void)changeLevel: (int) level {
        
    if ([[levelArray objectAtIndex:level - 1] intValue] == 0) {
        CCActionMoveTo *moveleft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.4, 0.8)];
        CCActionMoveTo *moveright = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.6, 0.8)];
        CCActionMoveTo *moveback = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.5, 0.8)];
        
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveleft, moveright, moveleft, moveright, moveback]];
        _text.string = [NSString stringWithFormat:@"Level %d locked", level];
        [_text runAction:sequence];
        ifLocked = true;
    } else {
        CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:0.2f angle:360];
        [_text runAction:rotate];
        _text.string = [NSString stringWithFormat:@"Level %d", level];
        [SavedData setLevel:level];
        ifLocked = false;
    }

}

@end
