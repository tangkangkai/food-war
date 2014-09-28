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
}

- (void)didLoadFromCCB {
    _message.string = [NSString stringWithFormat:@"At level %d, now choose your lineups", [SavedData level]];
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
