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
@property (nonatomic, strong) CCAction *flashAction;
@property CCNode *energyIcon;

- (void)addBombExplosion:(CGPoint) posi;
+ (void)addEnergy:(int) amount;

@end
