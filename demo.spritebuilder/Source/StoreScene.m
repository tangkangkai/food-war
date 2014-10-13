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
    int total;
    
    CCNode *_hole1;
    CCNode *_hole2;
    CCNode *_hole3;
    CCNode *_hole4;
    
}

-(void) didLoadFromCCB {
    NSLog(@"enter store scene");
    total = [SavedData money];
    _total.string = [NSString stringWithFormat:@" %d", total];
}

-(void)back {
    
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}

-(void)button1 {
    [self reduceTotalMoney:10];
}

-(void)button2 {
    [self reduceTotalMoney:8];
}

-(void)button3 {
    [self reduceTotalMoney:6];
    
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
