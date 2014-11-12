//
//  StoreScene2.m
//  demo
//
//  Created by dqlkx on 10/27/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "StoreScene2.h"
#import "Soldier.h"
#import "SavedData.h"


@implementation StoreScene2 {
    CCTextField *_total;
    CCTextField *_cost4;
    CCTextField *_level4;
    int cornCost;
    int total;
    
    CCNode *_hole4;
    
    int cornLevel;
    // health
    
    //bar
    CCNode *_cornHealth;
    //value
    CCTextField *_cornH;
    
    // attack
    //bar
    CCNode *_cornAtkPower;
    //value
    CCTextField *_cornAtk;
    
    // defence
    //bar
    CCNode *_cornDefense;
    //value
    CCTextField *_cornD;
    
    CornMan *corn;
}
- (void) didLoadFromCCB {
    NSLog(@"enter store scene2");
    total = [SavedData money];
    
    _total.string = [NSString stringWithFormat:@" %d", total];
    corn = [[CornMan alloc] initCorn: -1
                            startPos:_hole4.position
                                  destPos: _hole4.position
                                    ourArr:NULL                                                                  enemyArr:NULL
                                     level:cornLevel
                                 Animation:NULL];
    [self updateShowedData];
}


- (void)updateShowedData {
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    //get level of soldiers
    cornLevel = [[soldierLevelDict objectForKey:@"corn"] intValue];
    
    //set the level
    _level4.string = [NSString stringWithFormat:@"Lv.%d", cornLevel];
    
    // calculate the cost of each soldier if upgrading
    cornCost = 300 * cornLevel;
    
    //set the price
    _cost4.string = [NSString stringWithFormat:@"$ %d", cornCost];
    
    // value of health, atkPower, defense
    int ch = [corn getHealth] / 5;
    int ca = [corn getAtkPower];
    int cd = [corn getDefence] * 200;
    
    
    _cornH.string = [NSString stringWithFormat:@"HP:%d", ch];
    _cornAtk.string = [NSString stringWithFormat:@"Atk:%d", ca];
    _cornD.string = [NSString stringWithFormat:@"D:%d", cd];
    _cornHealth.contentSize = CGSizeMake(ch / 2, _cornHealth.contentSize.height);
    _cornAtkPower.contentSize = CGSizeMake(ca / 2, _cornAtkPower.contentSize.height);
    _cornDefense.contentSize = CGSizeMake(cd / 2, _cornDefense.contentSize.height);
    
}

- (void)updateStoredData {
    
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    [soldierLevelDict setObject:[NSNumber numberWithInt:cornLevel] forKey:@"corn"];
    [SavedData setSoldierLevel:soldierLevelDict];
    [SavedData saveSoldierLevel];
}

-(void)button4 {
    if (cornCost > total) {
        return;
    }
    
    [self reduceTotalMoney:cornCost];
    corn = [[CornMan alloc] initCorn: -1
                                  startPos:_hole4.position
                                   destPos: _hole4.position
                                    ourArr:NULL                                                                  enemyArr:NULL
                                     level:++cornLevel
                                 Animation:NULL];
    
    
    //update
    [self updateStoredData];
    [self updateShowedData];
}

-(void)reduceTotalMoney: (int)value {
    CCActionMoveTo *moveDown = [CCActionMoveTo actionWithDuration:0.1f position:ccp(412, 270)];
    CCActionMoveTo *moveUp = [CCActionMoveTo actionWithDuration:0.1f position:ccp(412, 291)];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveDown, moveUp]];
    [_total runAction:sequence];
    total -= value;
    _total.string = [NSString stringWithFormat:@"%d", total];
    [SavedData setMoney:total];
    [SavedData saveMoney];
}


- (void)back{
    
    CCScene *gameScene = [CCBReader loadAsScene:@"StoreScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.01f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}
@end
