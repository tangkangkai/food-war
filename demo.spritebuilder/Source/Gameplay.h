//
//  Gameplay.h
//  manmove
//
//  Created by dqlkx on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Gameplay : CCNode

@property (nonatomic, strong) CCSprite *anibomb;
@property (nonatomic, strong) CCAction *flashAction;

- (void)addBombExplosion:(CGPoint) posi;

@end
