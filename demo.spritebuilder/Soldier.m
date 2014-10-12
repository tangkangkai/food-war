//
//  Soldier.m
//  demo
//
//  Created by 丁硕青 on 9/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Soldier.h"
#import "SavedData.h"


@implementation Soldier{
    int health;
    NSDate *last_attack_time;
    bool moving;
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


- (void)doAttack{
    Soldier *target = [self detect_enemy];
    if( target == NULL){
        [self move];
        return;
    }
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= _atk_speed ){
        last_attack_time = [NSDate date];
        [[ self soldier ] stopAllActions ];
        moving = false;
        if( [ target loseHealth:[self atk_power] ] == 0 ){
            if( [self detect_enemy] == NULL ){
                [self move];
            }
        }
    }
}

- (Soldier*)detect_enemy{
    int nearest_distance = [ self atk_range];
    Soldier *target = NULL;
    CGPoint self_pos = [self soldier].position;
    
    for( Soldier *s in _enemyArray ){
        CGPoint enemy_pos = [s soldier].position;
        
        if( _lane_num == [ s lane_num ] &&
           ABS(enemy_pos.x-self_pos.x)< nearest_distance ){
            
            target = s;
            nearest_distance = ABS(enemy_pos.x-self_pos.x);
            // TODO find the enemy with the least health
        }
    }
    return target;
}

- (id)initSoldier:(NSString*) img
                  group:(int) group
                  lane_num:(int) lane_num
                  startPos:(CGPoint) start
                  destPos:(CGPoint) dest
                  ourArr:(NSMutableArray*) ourArray
                  enemyArr:(NSMutableArray*) enemyArray{
    
    self = [super init];
    // default properties
    moving = false;
    health = 100;
    last_attack_time = NULL;
    _atk_power = 30;
    _atk_speed = 3;
    _atk_range = 40;
    _defence = 0.1;
    _move_speed = 60;
    _value = 100;
    _lane_num = lane_num;
    
    _soldier = [CCBReader load:img];
    start.y += arc4random() % 5;
    _start_pos = start;
    _dest_pos = dest;
    _soldier.position = start; //CGPoint
    _group = group;

    [self update_health];

    if( ourArray != NULL ){
        [ourArray addObject:self];
        _ourArray = ourArray;
    }
    if( enemyArray != NULL){
        _enemyArray = enemyArray;
    }
    if( _group != -1 ){
        [self schedule:@selector(doAttack) interval:0.2];
    }
    return self;
}

-(void)move{
    if( moving == true || _group == -1 ){
        return;
    }
    
    moving = true;
    int distance = ABS(_dest_pos.x - [_soldier position].x);
    int duration = distance/_move_speed;
    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration
                                         position:CGPointMake(_dest_pos.x,[_soldier position].y)];
    [_soldier runAction:[CCActionSequence actionWithArray:@[actionMove]]];
}

- (void)dead{
    [ [self ourArray] removeObject:self];
    [[self soldier] removeFromParent];
    if( _group == 1 ){
        [SavedData addMoney:_value];
        [SavedData saveMoney];
    }
    // TODO release
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
