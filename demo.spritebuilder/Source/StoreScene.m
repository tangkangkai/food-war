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
    CCNode *_potatoHealth;
    CCNode *_beanHealth;
    CCNode *_bananaHealth;
    
    // attack
    CCNode *_potatoAtkPower;
    CCNode *_beanAtkPower;
    CCNode *_bananaAtkPower;
    
    // defence
    CCNode *_potatoDefense;
    CCNode *_beanDefense;
    CCNode *_bananaDefense;

}

- (void) didLoadFromCCB {
    NSLog(@"enter store scene");
    total = [SavedData money];
    [self updateShowedData];
    
    //set the state(atkPower, health, defense value)
    

    
    
    _total.string = [NSString stringWithFormat:@" %d", total];
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
    
    //update the data of soldier
    PotatoMan *pman = [[PotatoMan alloc] initPotato: -1
                                           startPos:_hole1.position
                                            destPos: _hole1.position
                                             ourArr:NULL                                                                  enemyArr:NULL
                                              level:potatoLevel];
    BeanMan *bean = [[BeanMan alloc] initBean: -1
                                     startPos:_hole1.position
                                      destPos: _hole1.position
                                       ourArr:NULL                                                                  enemyArr:NULL
                                        level:beanLevel];
    
    BananaMan *banana = [[BananaMan alloc] initBanana: -1
                                             startPos:_hole1.position
                                              destPos: _hole1.position
                                               ourArr:NULL                                                                  enemyArr:NULL
                                                level:bananaLevel];
    
    _potatoHealth.contentSize = CGSizeMake([pman getHealth] / 5, _potatoHealth.contentSize.height);
    _potatoAtkPower.contentSize = CGSizeMake([pman getAtkPower], _potatoAtkPower.contentSize.height);
    _potatoDefense.contentSize = CGSizeMake([pman getDefence] * 200, _potatoDefense.contentSize.height);
    
    _beanHealth.contentSize = CGSizeMake([bean getHealth] / 5, _beanHealth.contentSize.height);
    _beanAtkPower.contentSize = CGSizeMake([bean getAtkPower] * 2, _beanAtkPower.contentSize.height);
    _beanDefense.contentSize = CGSizeMake([bean getDefence] * 200, _beanDefense.contentSize.height);
    
    _bananaHealth.contentSize = CGSizeMake([banana getHealth] / 5, _bananaHealth.contentSize.height);
    _bananaAtkPower.contentSize = CGSizeMake([banana getAtkPower], _bananaAtkPower.contentSize.height);
    _bananaDefense.contentSize = CGSizeMake([banana getDefence] * 200, _bananaDefense.contentSize.height);
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

-(void)button1 {
    if (potatoCost > total) {
        return;
    }
    
    [self reduceTotalMoney:potatoCost];
    PotatoMan *potato = [[PotatoMan alloc] initPotato: -1
                                              startPos:_hole1.position
                                               destPos: _hole1.position
                                                ourArr:NULL                                                                  enemyArr:NULL
                                                 level:++potatoLevel];
    _potatoHealth.contentSize = CGSizeMake([potato getHealth] / 5,
                                           _potatoHealth.contentSize.height);
    _potatoAtkPower.contentSize = CGSizeMake([potato getAtkPower] * 2,
                                           _potatoAtkPower.contentSize.height);
    _potatoDefense.contentSize = CGSizeMake([potato getDefence] * 200,
                                             _potatoDefense.contentSize.height);
    //update
    [self updateStoredData];
    [self updateShowedData];
    
}

-(void)button2 {
    if (beanCost > total) {
        return;
    }
    
    [self reduceTotalMoney:beanCost];
    BeanMan *bean = [[BeanMan alloc] initBean: -1
                                             startPos:_hole1.position
                                              destPos: _hole1.position
                                               ourArr:NULL                                                                  enemyArr:NULL
                                                level:++beanLevel];
    _beanHealth.contentSize = CGSizeMake([bean getHealth] / 5,
                                           _beanHealth.contentSize.height);
    _beanAtkPower.contentSize = CGSizeMake([bean getAtkPower] * 2,
                                             _beanAtkPower.contentSize.height);
    _beanDefense.contentSize = CGSizeMake([bean getDefence] * 200,
                                            _beanDefense.contentSize.height);
    //update
    [self updateStoredData];
    [self updateShowedData];
}

-(void)button3 {
    if (bananaCost > total) {
        return;
    }
    
    [self reduceTotalMoney:bananaCost];
    BananaMan *banana = [[BananaMan alloc] initBanana: -1
                                         startPos:_hole1.position
                                          destPos: _hole1.position
                                           ourArr:NULL                                                                  enemyArr:NULL
                                            level:++bananaLevel];
    _bananaHealth.contentSize = CGSizeMake([banana getHealth] / 5,
                                         _bananaHealth.contentSize.height);
    _bananaAtkPower.contentSize = CGSizeMake([banana getAtkPower] * 2,
                                           _bananaAtkPower.contentSize.height);
    _bananaDefense.contentSize = CGSizeMake([banana getDefence] * 200,
                                          _bananaDefense.contentSize.height);
    //update
    [self updateStoredData];
    [self updateShowedData];
    
    
}

-(void)button4 {
    [self reduceTotalMoney:4];
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
