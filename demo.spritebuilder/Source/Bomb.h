//
//  Bomb.h
//  demo
//
//  Created by Yaning Wu on 10/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
#import "Item.h"
@interface Bomb : Item {
    
}

/*
@property CCSprite* bomb;
@property CGPoint startPosi;
@property CGPoint destPosi;
@property int power;
@property NSMutableArray* enemies;*/


-(void)drop: (CGPoint)start;
-(void)fly: (CGPoint)start;

-(id)initBomb:(NSString*) img
              animation:(CCNode*)ani
              startPosition:(CGPoint) start
              endPosition:(CGPoint) end
              enemyArr:(NSMutableArray*) enemyArray
      flyingItemsArray: flyingItemsArr;
@end