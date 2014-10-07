//
//  ChoiceScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ChoiceScene.h"
#import "SavedData.h"

@implementation ChoiceScene {
    CCTextField *_message;
    
    //background
    CCNode *_potatobg;
    CCNode *_beanbg;
    CCNode *_bananabg;
    CCNode *_cokebg;
    
    //tick
    CCNode *_potatochoosed;
    CCNode *_beanchoosed;
    CCNode *_bananachoosed;
    CCNode *_cokechoosed;
    
    //
    NSMutableDictionary *lineupDict;
}

- (void)didLoadFromCCB {
    
    _message.string = [NSString stringWithFormat:@"At level %d, now choose your lineups", [SavedData level]];
    
    _potatobg.visible = false;
    _beanbg.visible = false;
    _bananabg.visible = false;
    _cokebg.visible = false;
    
    _potatochoosed.visible = false;
    _beanchoosed.visible = false;
    _bananachoosed.visible = false;
    _cokechoosed.visible = false;
    
    lineupDict = [[SavedData lineupDictonary] copy];
}

- (void)potato {
    
    [self chooseSoldier:@"potato" background:_potatobg choosed:_potatochoosed];
}

- (void)chooseSoldier: (NSString *)soldier background: (CCNode *)bg choosed: (CCNode *)tick {
    NSLog(@"If contain soldier: %@", ([lineupDict objectForKey:soldier]) != nil ? @"Yes" : @"No");
    if ([lineupDict objectForKey:soldier] != nil) {
        bg.visible = false;
        tick.visible = false;
        NSLog(@"remove soldier");
       [lineupDict removeObjectForKey:soldier];
    } else {
        bg.visible = true;
        tick.visible = true;
        [lineupDict setObject:@"hehe" forKey:soldier];
        NSLog(@"If contain soldier: %@", ([lineupDict objectForKey:soldier]) != nil ? @"Yes" : @"No");
    }
    //[SavedData setLineUp:lineupDict];
    //[SavedData saveLineupDict];
}

- (void)go {

    CCScene *playScene = [CCBReader loadAsScene:@"Gameplay"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:playScene withTransition:trans];
}

- (void)back {
    
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}
@end
