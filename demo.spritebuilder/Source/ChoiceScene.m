//
//  ChoiceScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ChoiceScene.h"
#import "SavedData.h"
#import "Level.h"

@implementation ChoiceScene {
    CCTextField *_message;
    
    //background
    CCNode *_potatobg;
    CCNode *_beanbg;
    CCNode *_bananabg;
    CCNode *_cornbg;
    
    CCNode *_bananabgUn;
    CCNode *_cornbgUn;
    CCNode *_bananaunavl;
    CCNode *_cornunavl;
    
    
    
    //tick
    CCNode *_potatochoosed;
    CCNode *_beanchoosed;
    CCNode *_bananachoosed;
    CCNode *_cornchoosed;
    
    //
    NSMutableDictionary *lineupDict;
    
    //current level
    int currLevel;
}

- (void)didLoadFromCCB {
    currLevel = [[Levels getSelectedLevel] getLevel];
    _message.string = [NSString stringWithFormat:@"At level %d, now choose your lineups", currLevel];
    _message.opacity = 0;
    
    _potatobg.visible = false;
    _beanbg.visible = false;
    _bananabg.visible = false;
    _cornbg.visible = false;
    
    _potatochoosed.visible = false;
    _beanchoosed.visible = false;
    _bananachoosed.visible = false;
    _cornchoosed.visible = false;
    
    if (currLevel == 1) {
        _bananabgUn.visible = true;
        _bananaunavl.visible = true;
        _cornbgUn.visible = true;
        _cornunavl.visible = true;
    } else if (currLevel == 2) {
        _bananabgUn.visible = false;
        _bananaunavl.visible = false;
        _cornbgUn.visible = true;
        _cornunavl.visible = true;
    } else {
        _bananabgUn.visible = false;
        _bananaunavl.visible = false;
        _cornbgUn.visible = false;
        _cornunavl.visible = false;
        
    }
    
    lineupDict = [[NSMutableDictionary alloc] init];
}


- (void)potato {
    [self chooseSoldier:@"potatoMan" background:_potatobg choosed:_potatochoosed];
}

- (void)bean {
    [self chooseSoldier:@"bean" background:_beanbg choosed:_beanchoosed];
}

- (void)banana {
    if (currLevel == 1) {
        return;
    }
    [self chooseSoldier:@"banana" background:_bananabg choosed:_bananachoosed];
}

- (void)corn {
    if (currLevel <= 2) {
        return;
    }
    [self chooseSoldier:@"corn" background:_cornbg choosed:_cornchoosed];
}

- (void)chooseSoldier: (NSString *)soldier background: (CCNode *)bg choosed: (CCNode *)tick {
    if ([lineupDict objectForKey:soldier] != nil) {
        bg.visible = false;
        tick.visible = false;
        NSLog(@"remove soldier");
       [lineupDict removeObjectForKey:soldier];
    } else {
        bg.visible = true;
        tick.visible = true;
        [lineupDict setObject:[NSString stringWithFormat:@"%@.png", soldier] forKey:soldier];
        NSLog(@"If contain soldier: %@", ([lineupDict objectForKey:soldier]) != nil ? @"Yes" : @"No");
    }
}


- (void)go {
    // save lineup
    if (lineupDict.count == 0) {
//        CCActionMoveTo *moveleft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.4, 0.8)];
//        CCActionMoveTo *moveright = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.6, 0.8)];
//        CCActionMoveTo *moveback = [CCActionMoveTo actionWithDuration:0.05f position:ccp(0.5, 0.8)];
        
        CCActionFadeTo* fadeIn = [CCActionFadeTo actionWithDuration:0.01f opacity:255];
        CCActionMoveTo *moveLeft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(260, 281)];
        CCActionMoveTo *moveRight = [CCActionMoveTo actionWithDuration:0.05f position:ccp(304, 281)];
        CCActionMoveTo *moveBack = [CCActionMoveTo actionWithDuration:0.1f position:ccp(282, 281)];
        CCActionFadeTo* fadeOut = [CCActionFadeTo actionWithDuration:1.0f opacity:0];
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveLeft, moveRight, moveLeft, moveRight, moveBack, fadeOut]];
        
        _message.string = [NSString stringWithFormat:@"Please select soldiers"];
        [_message runAction:sequence];
        return;
    }
    
    [SavedData setLineUp:lineupDict];
    [SavedData saveLineupDict];
    NSLog(@"lineup num: %d", (int)lineupDict.count);
    
    CCScene *playScene = [CCBReader loadAsScene:@"Gameplay"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:playScene withTransition:trans];
}

-(void)store{
    CCScene *storeScene = [CCBReader loadAsScene:@"StoreScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionUp duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:storeScene withTransition:trans];
}

- (void)back {
    
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}
@end
