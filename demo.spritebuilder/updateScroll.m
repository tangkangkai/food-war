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

    int total;
    CCNode *_potato;
    CCNode *_bean;
    CCNode *_banana;
    CCNode *_corn;
    
    PotatoMan *potato;
    BananaMan *banana;
    BeanMan *bean;
    CornMan *corn;
}

- (void) didLoadFromCCB {
    NSLog(@"enter store scene");
    total = [SavedData money];
    
    //update the data of soldier
    [self updateShowedData:@"potato"];
    [self updateShowedData:@"bean"];
    [self updateShowedData:@"corn"];
    [self updateShowedData:@"banana"];
}


- (void)updateShowedData:(NSString*) soldierType {
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    Soldier *soldier;
    CCNode *soliderBlock;
    int level;
    CCNode *nullNode;

    if( [soldierType isEqualToString:@"potato"] ){
        soliderBlock = _potato;
        level = [[soldierLevelDict objectForKey:soldierType] intValue];
        soldier = [[PotatoMan alloc] initPotato: -1
                                     startPos:nullNode.position
                                     destPos: nullNode.position
                                     ourArr:NULL
                                     enemyArr:NULL
                                     level:level
                                     bgNode:NULL ];
    }
    if( [soldierType isEqualToString:@"bean"] ){
        soliderBlock = _bean;
        level = [[soldierLevelDict objectForKey:soldierType] intValue];
        soldier = [[BeanMan alloc] initBean: -1
                                   startPos:nullNode.position
                                   destPos:nullNode.position
                                   ourArr:NULL
                                   enemyArr:NULL
                                   level:level
                                   bgNode:NULL ];
    }
    if( [soldierType isEqualToString:@"banana"] ){
        soliderBlock = _banana;
        level = [[soldierLevelDict objectForKey:soldierType] intValue];
        soldier = [[BananaMan alloc] initBanana: -1
                                     startPos:nullNode.position
                                     destPos:nullNode.position
                                     ourArr:NULL
                                     enemyArr:NULL
                                     level:level
                                     bgNode:NULL ];
    }
    if( [soldierType isEqualToString:@"corn"] ){
        soliderBlock = _corn;
        level = [[soldierLevelDict objectForKey:soldierType] intValue];
        soldier = [[CornMan alloc] initCorn: -1
                                   startPos:nullNode.position
                                   destPos:nullNode.position
                                   ourArr:NULL
                                   enemyArr:NULL
                                   level:level
                                   bgNode:NULL];
    }
    
    CCTextField *lvl = (CCTextField*)[soliderBlock getChildByName:@"level" recursively:true];
    int totalCost = [soldier getUpgradeCost:level];
    lvl.string = [NSString stringWithFormat:@"Lv.%d", level];
    int hlt = [soldier getHealth];
    int atk = [soldier getAtkPower];
    int def = [soldier getDefence]*100;
    int atkSpd = 100/[soldier getAtkInt];

    CCTextField *health = (CCTextField*)[soliderBlock getChildByName:@"healthy" recursively:true];
    CCTextField *attack = (CCTextField*)[soliderBlock getChildByName:@"attack" recursively:true];
    CCTextField *defence = (CCTextField*)[soliderBlock getChildByName:@"defence" recursively:true];
    CCTextField *attackSpeed = (CCTextField*)[soliderBlock getChildByName:@"attackSpeed" recursively:true];
    health.string = [NSString stringWithFormat:@"%d", hlt];
    attack.string = [NSString stringWithFormat:@"%d", atk];
    defence.string = [NSString stringWithFormat:@"%d", def];
    attackSpeed.string = [NSString stringWithFormat:@"%d", atkSpd];

    CCTextField *costStr = (CCTextField*)[soliderBlock getChildByName:@"cost" recursively:true];
    costStr.string = [NSString stringWithFormat:@"%d", totalCost];
    
    return;
}

-(void)button1 {
    CCTextField *costStr = (CCTextField*)[_potato getChildByName:@"cost" recursively:true];
    NSString *cost = costStr.string;
    int totalCost = [[cost substringFromIndex:2] intValue];
    if (totalCost > total) {
        [self showMessage];
        return;
    }
    
    [self reduceTotalMoney:totalCost];
    total = [SavedData money];

    //update
    [self updateSoldier:@"potato"];
    [self updateShowedData:@"potato"];
}

-(void)button2 {
    CCTextField *costStr = (CCTextField*)[_bean getChildByName:@"cost" recursively:true];
    NSString *cost = costStr.string;
    int totalCost = [[cost substringFromIndex:2] intValue];
    if (totalCost > total) {
        [self showMessage];
        return;
    }
    
    [self reduceTotalMoney:totalCost];
    total = [SavedData money];
    
    //update
    [self updateSoldier:@"bean"];
    [self updateShowedData:@"bean"];
}

-(void)button3 {
    CCTextField *costStr = (CCTextField*)[_banana getChildByName:@"cost" recursively:true];
    NSString *cost = costStr.string;
    int totalCost = [[cost substringFromIndex:2] intValue];
    if (totalCost > total) {
        [self showMessage];
        return;
    }
    
    [self reduceTotalMoney:totalCost];
    total = [SavedData money];
    
    //update
    [self updateSoldier:@"banana"];
    [self updateShowedData:@"banana"];
}

-(void)button4 {
    CCTextField *costStr = (CCTextField*)[_corn getChildByName:@"cost" recursively:true];
    NSString *cost = costStr.string;
    int totalCost = [[cost substringFromIndex:2] intValue];
    if (totalCost > total) {
        [self showMessage];
        return;
    }
    
    [self reduceTotalMoney:totalCost];
    total = [SavedData money];
    
    //update
    [self updateSoldier:@"corn"];
    [self updateShowedData:@"corn"];
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

- (void)updateSoldier:(NSString*) soldierType {
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    int level = [[soldierLevelDict objectForKey:soldierType] intValue];
    [soldierLevelDict setObject:[NSNumber numberWithInt:level+1] forKey:soldierType];

    [SavedData setSoldierLevel:soldierLevelDict];
    [SavedData saveSoldierLevel];
}







@end
