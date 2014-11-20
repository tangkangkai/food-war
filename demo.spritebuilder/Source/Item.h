//
//  item.h
//  demo
//
//  Created by Yaning Wu on 11/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

@interface Item : CCNode{
    
}

@property CCSprite* item;
@property CGPoint startPosi;
@property CGPoint destPosi;
@property int power;
@property NSMutableArray* enemies;
@property NSMutableArray* flyingItems;

-(id)initItem:(NSString*) img
    animation:(CCSprite*) ani
startPosition:(CGPoint) start
  endPosition:(CGPoint) end
     enemyArr:(NSMutableArray*) enemyArray
flyingItemsArray:(NSMutableArray*) flyingItemsArr;


-(void)fly: (CGPoint)start;
-(void)fly2: (CGPoint)start;


@end