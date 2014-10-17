//
//  Scrollback.h
//  demo
//
//  Created by dqlkx on 9/29/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Soldier.h"

@interface Scrollback : CCNode<CCPhysicsCollisionDelegate>

@property CCNode *house1;
@property CCNode *house2;
@property CCNode *house3;
@property CCNode *house4;
@property CCNode *house5;
@property CCNode *house6;
@property CCNode *track1;        //invisible track
@property CCNode *track2;
@property CCNode *track3;
@property CCNode *base1;
@property CCNode *base2;
@property CCPhysicsNode *scroll_physicsWorld;
@property NSMutableArray *junk_soldiers;
@property NSMutableArray *healthy_soldiers;
@property NSMutableArray *target;
@property int missile_atk_range;
@property int missile_atk;
@property Base *healthBase;
@property Base *junkBase;


- (void)showTrack:(int) num;

- (void)bombExplode:(CGPoint)location;

@end
