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

@implementation Item{
    
}

-(id)initItem:(NSString*) img animation:(CCSprite*) ani startPosition:(CGPoint) start endPosition:(CGPoint) end               enemyArr:(NSMutableArray*) enemyArray;
{
    self = [super init];
    
    start.y -= 30;                  //adjust coordinates
    end.y -= 80;
    //    _bomb = [CCBReader load:img];
    _item = ani;
    _startPosi = start;
    _destPosi = end;
    _item.position = start;         //init CCNode;
    _item.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _item.contentSize} cornerRadius:0];
    _enemies = enemyArray;
//    accelator = 0; should be initted in subclasses
//    _power= 90 ;
    
    return self;
}


@end
