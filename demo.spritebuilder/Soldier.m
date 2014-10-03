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
    int lostHeath = Attack * (1 - _defence);
    health = health - lostHeath;
    if( health <= 0 ){
        [self dead];
        return 0;
    }
    [self update_health];
    return health;
}

- (void)attack{
    // TODO avoid duplicate schdule
    [self schedule:@selector(doAttack) interval:_atk_speed];
}

- (void)doAttack{
    //int range = _soldier.position.x + _atk_range;
    int nearest_distance = 9999;
    Soldier *target = NULL;
    CGPoint self_pos = [self soldier].position;
    
    for( Soldier *s in _enemyArray ){
        CGPoint enemy_pos = [s soldier].position;
        
        if( enemy_pos.y <= self_pos.y + 10 &&
           enemy_pos.y >= self_pos.y - 10 &&
           enemy_pos.x< nearest_distance ){
            
            target = s;
            nearest_distance = [s soldier].position.x;
            // TODO find the enemy with the least health
        }
    }
    if( target == NULL){
        [self unschedule:@selector(doAttack)];
        // move
        return;
    }
    [ target loseHealth:[self atk_power] ];
    
}


- (id)initSoldier:(NSString*) img group:(NSString*) group
                                collisionType:(NSString*) type
                                startPos:(CGPoint) pos
                                ourArr:(NSMutableArray*) ourArray
                                enemyArr:(NSMutableArray*) enemyArray{
    
    self = [super init];
    // default properties
    health = 100;
    _atk_power = 20;
    _atk_speed = 3;
    _atk_range = 10;
    _defence = 0.1;
    _move_speed = 60;
    
    _soldier = [CCBReader load:img];
    pos.y += arc4random() % 5;

    _soldier.position = pos; //CGPoint
    _soldier.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _soldier.contentSize} cornerRadius:0];
    _soldier.physicsBody.collisionGroup = group;
    _soldier.physicsBody.collisionType  = type;
    [self update_health];

    if( ourArray != NULL ){
        [ourArray addObject:self];
        _ourArray = ourArray;
    }
    if( enemyArray != NULL){
        _enemyArray = enemyArray;
    }
    return self;
}

-(void)move: (CGPoint) pos {
    int distance = ABS(pos.x - [_soldier position].x);
    int duration = distance/_move_speed;
    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration
                                         position:CGPointMake(pos.x,[_soldier position].y)];
    //CCAction *actionRemove = [CCActionRemove action];
    [_soldier runAction:[CCActionSequence actionWithArray:@[actionMove]]];
}

- (void)dead{
    [[self soldier] removeFromParent];
}

- (void)update_health{
    for( int i = 0; i<[_soldier children].count; i++ ){
        if( [ [_soldier children][i] isKindOfClass:[CCLabelTTF class]] ){
            CCLabelTTF *health_num = [ _soldier children][i];
            [health_num setString:[NSString stringWithFormat:@"%d", health]];
        }
    }
}

@end
