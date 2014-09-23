//
//  Soldier.m
//  demo
//
//  Created by 丁硕青 on 9/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Soldier.h"

@implementation Soldier{
    int health;
}


- (int)loseHealth:(int)Attack {
    NSLog(@"Original health: %d.", health);
    int lostHeath = Attack * (_defence);
    health = health - lostHeath;
    NSLog(@"Health after attacked: %d.", health);
    
    return health;
}

- (void)attack{
    NSLog(@"Attack");
}

- (void)loadSolider:(NSString*) solder_img group:(NSString*) group
                                collisionType:(NSString*) type startPos:(CGPoint) pos{
    CCSprite* node = [CCSprite spriteWithImageNamed:solder_img];
    //CCSprite* node = [CCBReader load:solder_img];

    node.position = pos; //CGPoint
    
    node.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, node.contentSize} cornerRadius:0]; // 1
    node.physicsBody.collisionGroup = group; // 2
    node.physicsBody.collisionType  = type;
    self.soldier = node;
}

-(void)move:(int) duration targetPos:(CGPoint) pos {
    CCAction *actionMove=[CCActionMoveTo actionWithDuration:duration position:CGPointMake(pos.x, pos.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [self.soldier runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}



- (id)init {
    
    if ( self = [super init] ){
        // default properties
        health = 100;
        _atk_power = 20;
        _atk_speed = 1;
        _atk_range = 10;
        _defence = 0.1;
    }
    return self;
}
@end
