//
//  Soldier.h
//  demo
//
//  Created by 丁硕青 on 9/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Soldier : CCNode
@property NSInteger *id;
//@property NSString *name;

@property float atk_speed;  // the time interval between every attack
@property int type;         // 0: tank, 1: melee-DPS, 2: ranged-DPS, 3: missile launcher
@property int group;         // 0: healthy 1:junk
@property int atk_range;
@property int atk_power;
@property float defence;    // value is from 0 ~ 1(100%)
@property int move_speed;   // the distance soldier can move per second
@property int value;

@property int ability_id;
@property int lane;         // TODO init this
@property CGPoint start_pos;
@property CGPoint dest_pos;
@property CCNode* soldier;
@property NSMutableArray* ourArray;
@property NSMutableArray* enemyArray;


- (int)loseHealth:(int)Attack;
- (void)attack;
- (id)initSoldier:(NSString*) img
                  group:(int) group
                  startPos:(CGPoint) start
                  destPos:(CGPoint) destPos
                  ourArr:(NSMutableArray*) ourArray
                  enemyArr:(NSMutableArray*) enemyArray;
- (void)move;
- (void)update_health;

- (void)dead;


@end
