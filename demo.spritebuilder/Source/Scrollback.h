//
//  Scrollback.h
//  demo
//
//  Created by dqlkx on 9/29/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

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
@property CCPhysicsNode *scroll_physicsWorld;

- (void)trackInvist;
@end
