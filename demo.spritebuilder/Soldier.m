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

- (void)loadSolider:(NSString*) img group:(NSString*) group
                                collisionType:(NSString*) type startPos:(CGPoint) pos{
    _soldier = [CCBReader load:img];
    pos.y += arc4random() % 5;
    

    _soldier.position = pos; //CGPoint
    _soldier.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _soldier.contentSize} cornerRadius:0];
    _soldier.physicsBody.collisionGroup = group;
    _soldier.physicsBody.collisionType  = type;
}

-(void)move: (CGPoint) pos {
    int distance = ABS(pos.x - [_soldier position].x);
    int duration = distance/_move_speed;
    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration position:CGPointMake(pos.x,[_soldier position].y)];
    CCAction *actionRemove = [CCActionRemove action];
    [_soldier runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}


- (id)init {
    
    if ( self = [super init] ){
        // default properties
        health = 100;
        _atk_power = 20;
        _atk_speed = 1;
        _atk_range = 10;
        _defence = 0.1;
        _move_speed = 60;
    }
    return self;
}
@end
