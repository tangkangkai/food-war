//
//  Gameplay.h
//  manmove
//
//  Created by dqlkx on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Gameplay : CCNode<CCScrollViewDelegate>

@property (nonatomic, strong) CCSprite *anibomb;
@property (nonatomic, strong) CCSprite *aniIceBucket;
@property (nonatomic, strong) CCAction *flashAction;
@property CCNode *energyIcon;

@property NSMutableArray* flyingItems;

- (void)addBombExplosion:(CGPoint) posi;
+ (void)addEnergy:(int) amount;
+ (NSMutableArray*) getItArray;
-(void)addBombNumber;
- (void)dropItem: (int) type position: (CGPoint) location;
-(void)itemAutoBuild;
@end
