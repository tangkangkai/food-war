//
//  updateScroll.m
//  demo
//
//  Created by dqlkx on 11/22/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "StoreScene.h"
#import "SavedData.h"
#import "Soldier.h"
#import "Level.h"
#import "updateScroll.h"


@implementation updateScroll {
    CCTextField *_cost1;
    CCTextField *_cost2;
    CCTextField *_cost3;
    CCTextField *_cost4;
    CCTextField *_level1;
    CCTextField *_level2;
    CCTextField *_level3;
    CCTextField *_level4;
    
    int beanCost;
    int bananaCost;
    int potatoCost;
    int cornCost;
    int total;
    
    CCNode *_hole1;
    CCNode *_hole2;
    CCNode *_hole3;
    CCNode *_hole4;
    
    // Level State parameters
    // level
    int potatoLevel;
    int beanLevel;
    int bananaLevel;
    int cornLevel;
    
    // health
    
    //bar
    CCNode *_potatoHealth;
    CCNode *_beanHealth;
    CCNode *_bananaHealth;
    CCNode *_cornHealth;
    //value
    CCTextField *_potatoH;
    CCTextField *_beanH;
    CCTextField *_bananaH;
    CCTextField *_cornH;
    
    // attack
    //bar
    CCNode *_potatoAtkPower;
    CCNode *_beanAtkPower;
    CCNode *_bananaAtkPower;
    CCNode *_cornAtkPower;
    //value
    CCTextField *_potatoAtk;
    CCTextField *_beanAtk;
    CCTextField *_bananaAtk;
    CCTextField *_cornAtk;
    
    // defence
    //bar
    CCNode *_potatoDefense;
    CCNode *_beanDefense;
    CCNode *_bananaDefense;
    CCNode *_cornDefense;
    //value
    CCTextField *_potatoD;
    CCTextField *_beanD;
    CCTextField *_bananaD;
    CCTextField *_cornD;
    
    
    PotatoMan *potato;
    BananaMan *banana;
    BeanMan *bean;
    CornMan *corn;
}



- (void) didLoadFromCCB {
    NSLog(@"enter store scene");
    [self updateShowedData];
    total = [SavedData money];
    //set the state(atkPower, health, defense value)
    
    //update the data of soldier
    
    potato = [[PotatoMan alloc] initPotato: -1
                                  startPos:_hole1.position
                                   destPos: _hole1.position
                                    ourArr:NULL
                                  enemyArr:NULL
                                     level:potatoLevel
                                    bgNode:NULL ];
    bean = [[BeanMan alloc] initBean: -1
                            startPos:_hole1.position
                             destPos: _hole1.position
                              ourArr:NULL
                            enemyArr:NULL
                               level:beanLevel
                              bgNode:NULL ];
    
    banana = [[BananaMan alloc] initBanana: -1
                                  startPos:_hole1.position
                                   destPos: _hole1.position
                                    ourArr:NULL
                                  enemyArr:NULL
                                     level:bananaLevel
                                    bgNode:NULL ];
    
    corn = [[CornMan alloc] initCorn: -1
                            startPos:_hole4.position
                             destPos: _hole4.position
                              ourArr:NULL
                            enemyArr:NULL
                               level:cornLevel
                              bgNode:NULL];
    
    
    
    [self updateShowedData];
}


- (void)updateShowedData {
    return;
//    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
//    //get level of soldiers
//    potatoLevel = [[soldierLevelDict objectForKey:@"potato"] intValue];
//    beanLevel = [[soldierLevelDict objectForKey:@"bean"] intValue];
//    bananaLevel = [[soldierLevelDict objectForKey:@"banana"] intValue];
//    cornLevel = [[soldierLevelDict objectForKey:@"corn"] intValue];
//    
//    //set the level
//    _level1.string = [NSString stringWithFormat:@"Lv.%d", potatoLevel];
//    _level2.string = [NSString stringWithFormat:@"Lv.%d", beanLevel];
//    _level3.string = [NSString stringWithFormat:@"Lv.%d", bananaLevel];
//    _level4.string = [NSString stringWithFormat:@"Lv.%d", cornLevel];
//    
//    // calculate the cost of each soldier if upgrading
//    beanCost = 200 * beanLevel;
//    potatoCost = 150 * potatoLevel;
//    bananaCost = 350 * bananaLevel;
//    cornCost = 300 * cornLevel;
//    
//    //set the price
//    _cost1.string = [NSString stringWithFormat:@"$ %d", potatoCost];
//    _cost2.string = [NSString stringWithFormat:@"$ %d", beanCost];
//    _cost3.string = [NSString stringWithFormat:@"$ %d", bananaCost];
//    _cost4.string = [NSString stringWithFormat:@"$ %d", cornCost];
//    
//    // value of health, atkPower, defense
//    int ph = [potato getHealth] / 5;
//    int pa = [potato getAtkPower];
//    int pd = [potato getDefence] * 200;
//    int beh = [bean getHealth] / 5;
//    int bea = [bean getAtkPower];
//    int bed = [bean getDefence] * 200;
//    int bah = [banana getHealth] / 5;
//    int baa = [banana getAtkPower];
//    int bad = [banana getDefence] * 200;
//    int ch = [corn getHealth] / 5;
//    int ca = [corn getAtkPower];
//    int cd = [corn getDefence] * 200;
//    
//    _potatoH.string = [NSString stringWithFormat:@"HP:%d", ph];
//    _potatoAtk.string = [NSString stringWithFormat:@"Atk:%d", pa];
//    _potatoD.string = [NSString stringWithFormat:@"D:%d", pd];
//    _potatoHealth.contentSize = CGSizeMake(ph, _potatoHealth.contentSize.height);
//    _potatoAtkPower.contentSize = CGSizeMake(pa, _potatoAtkPower.contentSize.height);
//    _potatoDefense.contentSize = CGSizeMake(pd, _potatoDefense.contentSize.height);
//    
//    
//    _beanH.string = [NSString stringWithFormat:@"HP:%d", beh];
//    _beanAtk.string = [NSString stringWithFormat:@"Atk:%d", bea];
//    _beanD.string = [NSString stringWithFormat:@"D:%d", bed];
//    _beanHealth.contentSize = CGSizeMake(beh, _beanHealth.contentSize.height);
//    _beanAtkPower.contentSize = CGSizeMake(bea, _beanAtkPower.contentSize.height);
//    _beanDefense.contentSize = CGSizeMake(bed, _beanDefense.contentSize.height);
//    
//    _bananaH.string = [NSString stringWithFormat:@"HP:%d", bah];
//    _bananaAtk.string = [NSString stringWithFormat:@"Atk:%d", baa];
//    _bananaD.string = [NSString stringWithFormat:@"D:%d", bad];
//    _bananaHealth.contentSize = CGSizeMake(bah, _bananaHealth.contentSize.height);
//    _bananaAtkPower.contentSize = CGSizeMake(baa, _bananaAtkPower.contentSize.height);
//    _bananaDefense.contentSize = CGSizeMake(bad, _bananaDefense.contentSize.height);
//    
//    _cornH.string = [NSString stringWithFormat:@"HP:%d", ch];
//    _cornAtk.string = [NSString stringWithFormat:@"Atk:%d", ca];
//    _cornD.string = [NSString stringWithFormat:@"D:%d", cd];
//    _cornHealth.contentSize = CGSizeMake(ch / 2, _cornHealth.contentSize.height);
//    _cornAtkPower.contentSize = CGSizeMake(ca / 2, _cornAtkPower.contentSize.height);
//    _cornDefense.contentSize = CGSizeMake(cd / 2, _cornDefense.contentSize.height);
    
}

-(void)button1 {
    if (potatoCost > total) {
        [self showMessage];
        return;
    }
    
    [self reduceTotalMoney:potatoCost];
    total = [SavedData money];
    potato = [[PotatoMan alloc] initPotato: -1
                                  startPos:_hole1.position
                                   destPos: _hole1.position
                                    ourArr:NULL enemyArr:NULL
                                     level:++potatoLevel
                                    bgNode:NULL];
    
    //update
    [self updateStoredData];
    [self updateShowedData];
    
}

-(void)button2 {
    if (beanCost > total) {
        [self showMessage];
        return;
    }
    
    [self reduceTotalMoney:beanCost];
    total = [SavedData money];
    bean = [[BeanMan alloc] initBean: -1
                            startPos:_hole1.position
                             destPos: _hole1.position
                              ourArr:NULL
                            enemyArr:NULL
                               level:++beanLevel
                              bgNode:NULL];
    
    //update
    [self updateStoredData];
    [self updateShowedData];
}

-(void)button3 {
    if (bananaCost > total) {
        [self showMessage];
        return;
    }
    
    [self reduceTotalMoney:bananaCost];
    total = [SavedData money];
    banana = [[BananaMan alloc] initBanana: -1
                                  startPos:_hole1.position
                                   destPos: _hole1.position
                                    ourArr:NULL
                                  enemyArr:NULL
                                     level:++bananaLevel
                                    bgNode:NULL];
    
    
    //update
    [self updateStoredData];
    [self updateShowedData];
    
}

-(void)button4 {
    if (cornCost > total) {
        [self showMessage];
        return;
    }
    
    [self reduceTotalMoney:cornCost];
    total = [SavedData money];
    corn = [[CornMan alloc] initCorn: -1
                            startPos:_hole4.position
                             destPos: _hole4.position
                              ourArr:NULL
                            enemyArr:NULL
                               level:++cornLevel
                              bgNode:NULL];
    
    //update
    [self updateStoredData];
    [self updateShowedData];
}


- (void)showMessage {
    CCScrollView *parentScroll = (CCScrollView*)[self parent];
    StoreScene* storeScene = (StoreScene*)[parentScroll parent];
    [storeScene showMessage];
}

-(void)reduceTotalMoney: (int)value {
    CCScrollView *parentScroll = (CCScrollView*)[self parent];
    StoreScene* storeScene = (StoreScene*)[parentScroll parent];
    [storeScene reduceTotalMoney:value];
}

- (void)updateStoredData {
    
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    [soldierLevelDict setObject:[NSNumber numberWithInt:potatoLevel] forKey:@"potato"];
    [soldierLevelDict setObject:[NSNumber numberWithInt:beanLevel] forKey:@"bean"];
    [soldierLevelDict setObject:[NSNumber numberWithInt:bananaLevel] forKey:@"banana"];
    
    [SavedData setSoldierLevel:soldierLevelDict];
    [SavedData saveSoldierLevel];
}







@end
