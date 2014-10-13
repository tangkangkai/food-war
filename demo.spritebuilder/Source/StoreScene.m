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

@implementation StoreScene {
    CCTextField *_total;
    CCTextField *_cost1;
    CCTextField *_cost2;
    CCTextField *_cost3;
    CCTextField *_cost4;
    int total;
    int beanCost;
    int bananaCost;
    int tomatoCost;
    int cost4;
    
    CCNode *_hole1;
    CCNode *_hole2;
    CCNode *_hole3;
    CCNode *_hole4;
    
}

-(void) didLoadFromCCB {
    NSLog(@"enter store scene");
    total = [SavedData money];
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    
    //get level of soldiers
    int tomatoLevel = [[soldierLevelDict objectForKey:@"tomato"] intValue];
    int beanLevel = [[soldierLevelDict objectForKey:@"bean"] intValue];
    int bananaLevel = [[soldierLevelDict objectForKey:@"banana"] intValue];
    
    // calculate the cost of each soldier if upgrading
    beanCost = 200 * beanLevel;
    tomatoCost = 150 * tomatoLevel;
    bananaCost = 350 * bananaLevel;
    
    //set the price
    _cost1.string = [NSString stringWithFormat:@" %d", tomatoCost];
    _cost2.string = [NSString stringWithFormat:@" %d", beanCost];
    _cost3.string = [NSString stringWithFormat:@" %d", bananaCost];
    _cost4.string = @"Unknown";
    
    _total.string = [NSString stringWithFormat:@" %d", total];
}

-(void)back {
    
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}

-(void)button1 {
    [self reduceTotalMoney:tomatoCost];
}

-(void)button2 {
    [self reduceTotalMoney:beanCost];
}

-(void)button3 {
    [self reduceTotalMoney:bananaCost];
    
    BananaMan *newSoldier = [[BananaMan alloc] initBanana: -1
                                                 startPos:_hole1.position
                                                  destPos: _hole1.position
                                                   ourArr:NULL                                                                  enemyArr:NULL
                             level:1];
    NSLog(@"hehe, %d", [newSoldier getAtkPower]);
    
    
    
}

-(void)button4 {
    [self reduceTotalMoney:4];
}


-(void)reduceTotalMoney: (int)value {
    CCActionMoveTo *moveDown = [CCActionMoveTo actionWithDuration:0.1f position:ccp(128, 270)];
    CCActionMoveTo *moveUp = [CCActionMoveTo actionWithDuration:0.1f position:ccp(128, 287)];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveDown, moveUp]];
    [_total runAction:sequence];
    total -= value;
    _total.string = [NSString stringWithFormat:@"%d", total];
    [SavedData setMoney:total];
    [SavedData saveMoney];
}
@end
