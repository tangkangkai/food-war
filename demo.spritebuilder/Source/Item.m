//
//  item.m
//  demo
//
//  Created by Yaning Wu on 11/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import <CoreMotion/CoreMotion.h>
#import "Scrollback.h"
#import "SavedData.h"
#import "Gameplay.h"

@implementation Item{
    float V0x;           //variables used for flying
    float V0y;
    float Vtx;
    float S;
    float a;
    BOOL reverseFlag;
    BOOL reduceFlag;
    float timeInterval;
    
}

-(id)initItem:(NSString*) img animation:(CCNode*) ani startPosition:(CGPoint) start endPosition:(CGPoint) end enemyArr:(NSMutableArray*) enemyArray flyingItemsArray: flyingItemsArr;
{
    self = [super init];
    
    start.y -= 30;                  //adjust coordinates
    end.y -= 80;
//    _item = [CCBReader load:img];
    _item = ani;
    _startPosi = start;
    _destPosi = end;
    _item.position = start;         //init CCNode;
    _item.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _item.contentSize} cornerRadius:0];
    _enemies = enemyArray;
    _flyingItems = flyingItemsArr;

    timeInterval = 0.01f;       //intialize v
    V0y = 20;
    V0x = 300;
    
    Vtx = V0x;
    S = 160;
    a = V0x * V0x / (2*S);
    
    reverseFlag = NO;
    reduceFlag = YES;
    return self;
    
}

-(void)fly: (CGPoint)start{     // Now we use fly2. This function is preserved to be referance;
    [self schedule:@selector(hover) interval:timeInterval];
    
}

-(void)hover{
    float yt = self.item.position.y - V0y * timeInterval;
    float xt;
    
    Vtx = Vtx - a * timeInterval;
    if(Vtx < 0) {
        reverseFlag = !reverseFlag;
        Vtx = V0x;
    }
    
    float deltaS = (2 * Vtx + a * timeInterval) * timeInterval / 2;          // deltaS = (Vt1 + Vt2) * (Vt1-Vt2) / 2a
    if(reverseFlag == NO){
        xt = self.item.position.x + deltaS;
    } else {
        xt = self.item.position.x - deltaS;
    }
    
    self.item.position = CGPointMake(xt, yt);
    if(yt < 0){
        [self.item removeFromParent];
        [self unschedule:@selector(hover)];
        [[self flyingItems] removeObject:self];
    }
}

-(void)fly2: (CGPoint)start{
    [self schedule:@selector(hover2) interval:timeInterval];
    
}

-(void)hover2{
    float yt = self.item.position.y - V0y * timeInterval;
    float xt;
    
    
    float deltaS = 0;          // deltaS = (Vt1 + Vt2) * (Vt1-Vt2) / 2a
    if(reduceFlag == YES) {
        Vtx = Vtx - a * timeInterval;
        deltaS = (2 * Vtx + a * timeInterval) * timeInterval / 2;
    } else {
        Vtx = Vtx + a * timeInterval;
        deltaS = (2 * Vtx - a * timeInterval) * timeInterval / 2;
    }
    
    
    if(Vtx < 0) {
        reverseFlag = !reverseFlag;
        reduceFlag = !reduceFlag;
    }
    
    if(Vtx > V0x){
        reduceFlag = !reduceFlag;
    }

    
    if(reverseFlag == NO){
        xt = self.item.position.x + deltaS;
    } else {
        xt = self.item.position.x - deltaS;
    }
    
    self.item.position = CGPointMake(xt, yt);
    if(yt < -100){
        [self.item removeFromParent];
        [self unschedule:@selector(hover2)];
        [[self flyingItems] removeObject:self];
        [self removeFromParent];
    }
}

-(void)disappear{
    [self.item removeFromParent];
    [self unschedule:@selector(hover2)];
    [[self flyingItems] removeObject:self];
    [self removeFromParent];
}

@end
