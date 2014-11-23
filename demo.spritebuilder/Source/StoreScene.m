//
//  StoreScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StoreScene.h"
#import "SavedData.h"
#import "Soldier.h"
#import "Level.h"

@implementation StoreScene {
    CCTextField *_total;
    CCTextField *_cost1;
    CCTextField *_cost2;
    CCTextField *_cost3;
    CCTextField *_cost4;
    CCTextField *_level1;
    CCTextField *_level2;
    CCTextField *_level3;
    CCTextField *_level4;
    CCTextField *_message;

    int total;
    int beanCost;
    int bananaCost;
    int potatoCost;
    int cost4;
    
    CCNode *_hole1;
    CCNode *_hole2;
    CCNode *_hole3;
    CCNode *_hole4;
    
    // Level State parameters
    // level
    int potatoLevel;
    int beanLevel;
    int bananaLevel;
    
    // health
    
        //bar
    CCNode *_potatoHealth;
    CCNode *_beanHealth;
    CCNode *_bananaHealth;
        //value
    CCTextField *_potatoH;
    CCTextField *_beanH;
    CCTextField *_bananaH;
    
    // attack
        //bar
    CCNode *_potatoAtkPower;
    CCNode *_beanAtkPower;
    CCNode *_bananaAtkPower;
        //value
    CCTextField *_potatoAtk;
    CCTextField *_beanAtk;
    CCTextField *_bananaAtk;
    
    // defence
        //bar
    CCNode *_potatoDefense;
    CCNode *_beanDefense;
    CCNode *_bananaDefense;
        //value
    CCTextField *_potatoD;
    CCTextField *_beanD;
    CCTextField *_bananaD;
    
    
    PotatoMan *potato;
    BananaMan *banana;
    BeanMan *bean;

}

- (void) didLoadFromCCB {
    NSLog(@"enter store scene");
    _message.string = [NSString stringWithFormat:@"You need more money to update"];
    _message.opacity = 0;
    total = [SavedData money];
    
    //set the state(atkPower, health, defense value)
    _total.string = [NSString stringWithFormat:@" %d", total];
}


- (void)back {
    
    CCScene *gameScene = [CCBReader loadAsScene:@"ChoiceScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}

-(void)updateTotal:(int)totalMoney {
    _total.string = [NSString stringWithFormat:@" %d", totalMoney];
}

-(void) showMessage {
    CCActionFadeTo* fadeIn = [CCActionFadeTo actionWithDuration:0.1f opacity:255];
    CCActionMoveTo *moveLeft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(258, 293)];
    CCActionMoveTo *moveRight = [CCActionMoveTo actionWithDuration:0.05f position:ccp(298, 293)];
    CCActionMoveTo *moveBack = [CCActionMoveTo actionWithDuration:0.1f position:ccp(278, 293)];

    CCActionFadeTo* fadeOut = [CCActionFadeTo actionWithDuration:1.0f opacity:0];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveLeft, moveRight, moveLeft, moveRight, moveBack, fadeOut]];
    [_message runAction:sequence];
}

-(void)reduceTotalMoney: (int)value {
    CCActionMoveTo *moveDown = [CCActionMoveTo actionWithDuration:0.1f position:ccp(496, 270)];
    CCActionMoveTo *moveUp = [CCActionMoveTo actionWithDuration:0.1f position:ccp(496, 292)];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveDown, moveUp]];
    [_total runAction:sequence];
    total -= value;
    _total.string = [NSString stringWithFormat:@"%d", total];
    [SavedData setMoney:total];
    [SavedData saveMoney];
}

@end
