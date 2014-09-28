//
//  GameScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "SavedData.h"

@implementation GameScene {
    CCTextField *_text;
}



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

- (void)changeLevel: (int) level {
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:0.2f angle:360];
    [_text runAction:rotate];
    _text.string = [NSString stringWithFormat:@"Level %d", level];
    [SavedData setLevel:level];
}

@end
