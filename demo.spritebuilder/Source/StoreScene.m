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
    CCTextField *_level1;
    CCTextField *_level2;
    CCTextField *_level3;
    CCTextField *_level4;
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
    total = [SavedData money];
    [self updateShowedData];
    
    //set the state(atkPower, health, defense value)
    

    
    
    _total.string = [NSString stringWithFormat:@" %d", total];
    
    //update the data of soldier
    
    potato = [[PotatoMan alloc] initPotato: -1
                                           startPos:_hole1.position
                                            destPos: _hole1.position
                                             ourArr:NULL                                                                  enemyArr:NULL
                                              level:potatoLevel
                                            Animation:NULL];
    bean = [[BeanMan alloc] initBean: -1
                                     startPos:_hole1.position
                                      destPos: _hole1.position
                                       ourArr:NULL                                                                  enemyArr:NULL
                                        level:beanLevel
                           Animation:NULL];

    
    banana = [[BananaMan alloc] initBanana: -1
                                             startPos:_hole1.position
                                              destPos: _hole1.position
                                               ourArr:NULL                                                                  enemyArr:NULL
                                                level:bananaLevel
                                 Animation:NULL];

    
    
    [self updateShowedData];
}

- (void)updateShowedData {
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    //get level of soldiers
    potatoLevel = [[soldierLevelDict objectForKey:@"potato"] intValue];
    beanLevel = [[soldierLevelDict objectForKey:@"bean"] intValue];
    bananaLevel = [[soldierLevelDict objectForKey:@"banana"] intValue];
    
    //set the level
    _level1.string = [NSString stringWithFormat:@"Lv.%d", potatoLevel];
    _level2.string = [NSString stringWithFormat:@"Lv.%d", beanLevel];
    _level3.string = [NSString stringWithFormat:@"Lv.%d", bananaLevel];
    
    // calculate the cost of each soldier if upgrading
    beanCost = 200 * beanLevel;
    potatoCost = 150 * potatoLevel;
    bananaCost = 350 * bananaLevel;
    
    //set the price
    _cost1.string = [NSString stringWithFormat:@"$ %d", potatoCost];
    _cost2.string = [NSString stringWithFormat:@"$ %d", beanCost];
    _cost3.string = [NSString stringWithFormat:@"$ %d", bananaCost];
    _cost4.string = @"Unknown";
    
    // value of health, atkPower, defense
    int ph = [potato getHealth] / 5;
    int pa = [potato getAtkPower];
    int pd = [potato getDefence] * 200;
    int beh = [bean getHealth] / 5;
    int bea = [bean getAtkPower];
    int bed = [bean getDefence] * 200;
    int bah = [banana getHealth] / 5;
    int baa = [banana getAtkPower];
    int bad = [banana getDefence] * 200;
    
    
    _potatoH.string = [NSString stringWithFormat:@"H:%d", ph];
    _potatoAtk.string = [NSString stringWithFormat:@"A:%d", pa];
    _potatoD.string = [NSString stringWithFormat:@"D:%d", pd];
    _potatoHealth.contentSize = CGSizeMake(ph, _potatoHealth.contentSize.height);
    _potatoAtkPower.contentSize = CGSizeMake(pa, _potatoAtkPower.contentSize.height);
    _potatoDefense.contentSize = CGSizeMake(pd, _potatoDefense.contentSize.height);
    
    
    _beanH.string = [NSString stringWithFormat:@"H:%d", beh];
    _beanAtk.string = [NSString stringWithFormat:@"A:%d", bea];
    _beanD.string = [NSString stringWithFormat:@"D:%d", bed];
    _beanHealth.contentSize = CGSizeMake(beh, _beanHealth.contentSize.height);
    _beanAtkPower.contentSize = CGSizeMake(bea, _beanAtkPower.contentSize.height);
    _beanDefense.contentSize = CGSizeMake(bed, _beanDefense.contentSize.height);
    
    _bananaH.string = [NSString stringWithFormat:@"H:%d", bah];
    _bananaAtk.string = [NSString stringWithFormat:@"A:%d", baa];
    _bananaD.string = [NSString stringWithFormat:@"D:%d", bad];
    _bananaHealth.contentSize = CGSizeMake(bah, _bananaHealth.contentSize.height);
    _bananaAtkPower.contentSize = CGSizeMake(baa, _bananaAtkPower.contentSize.height);
    _bananaDefense.contentSize = CGSizeMake(bad, _bananaDefense.contentSize.height);
    
}

- (void)updateStoredData {
    
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    [soldierLevelDict setObject:[NSNumber numberWithInt:potatoLevel] forKey:@"potato"];
    [soldierLevelDict setObject:[NSNumber numberWithInt:beanLevel] forKey:@"bean"];
    [soldierLevelDict setObject:[NSNumber numberWithInt:bananaLevel] forKey:@"banana"];
    
    [SavedData setSoldierLevel:soldierLevelDict];
    [SavedData saveSoldierLevel];
}

- (void)back {
    
    CCScene *gameScene = [CCBReader loadAsScene:@"ChoiceScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}

- (void)next {
    
    CCScene *gameScene = [CCBReader loadAsScene:@"StoreScene2"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.01f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}

-(void)button1 {
    if (potatoCost > total) {
        return;
    }
    
    [self reduceTotalMoney:potatoCost];
    potato = [[PotatoMan alloc] initPotato: -1
                                  startPos:_hole1.position
                                   destPos: _hole1.position
                                    ourArr:NULL enemyArr:NULL
                                     level:++potatoLevel
                                 Animation:NULL];

    //update
    [self updateStoredData];
    [self updateShowedData];
    
}

-(void)button2 {
    if (beanCost > total) {
        return;
    }
    
    [self reduceTotalMoney:beanCost];
    bean = [[BeanMan alloc] initBean: -1
                                             startPos:_hole1.position
                                              destPos: _hole1.position
                                               ourArr:NULL                                                                  enemyArr:NULL
                                                level:++beanLevel
                           Animation:NULL];

    //update
    [self updateStoredData];
    [self updateShowedData];
}

-(void)button3 {
    if (bananaCost > total) {
        return;
    }
    
    [self reduceTotalMoney:bananaCost];
    banana = [[BananaMan alloc] initBanana: -1
                                         startPos:_hole1.position
                                          destPos: _hole1.position
                                           ourArr:NULL                                                                  enemyArr:NULL
                                            level:++bananaLevel
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
@end
