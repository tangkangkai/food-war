//
//  GameScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene


- (void) didLoadFromCCB {
    NSLog(@"Enter Game Level Scene");
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
    CCScene *choiceScene = [CCBReader loadAsScene:@"ChoiceScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
}

@end
