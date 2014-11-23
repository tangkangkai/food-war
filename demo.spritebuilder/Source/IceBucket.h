//
//  IceBucket.h
//  demo
//
//  Created by Yaning Wu on 11/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
#import "Item.h"

@interface IceBucket:Item

-(id) initIceBucket:(NSString *)img animation:(CCNode *)ani startPosition:(CGPoint)start endPosition:(CGPoint)end enemyArr:(NSMutableArray *)enemyArray flyingItemsArray: flyingItemsArr;
-(void)dropBucket;

@end
