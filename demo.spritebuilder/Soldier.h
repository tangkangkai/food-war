//
//  Soldier.h
//  demo
//
//  Created by 丁硕青 on 9/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Soldier : CCNode{
    
    int health;
    NSDate *last_attack_time;
    bool moving;
    int type;         // 0: tank, 1: melee-DPS, 2: ranged-DPS, 3: missile launcher
    int atkRange;
    int atkPower;
    float atkInterval;  // the time interval between every attack
    float defence;    // value is from 0 ~ 1(100%)
    int moveSpeed;   // the distance soldier can move per second
    int value;
    int level;
}
@property NSInteger *id;
//@property NSString *name;

@property int group;         // 0: healthy 1:junk



@property int ability_id;
@property int lane_num;
@property CGPoint start_pos;
@property CGPoint dest_pos;
@property CCNode* soldier;
@property NSMutableArray* ourArray;
@property NSMutableArray* enemyArray;

- (id)initSoldier:(NSString*) img
                  group:(int) group
                  lane_num:(int) lane_num
                  startPos:(CGPoint) start
                  destPos:(CGPoint) destPos
                  ourArr:(NSMutableArray*) ourArray
                  enemyArr:(NSMutableArray*) enemyArray
            level:(int) soldierLevel;


- (int)loseHealth:(int)Attack;
- (void)update_health;
- (void)move;
- (void)dead;
// get methods add by kk
- (int)getLevel;
- (int)getAtkPower;
- (int)getDefence;
- (int)getHealth;

@end



@interface BurgerMan : Soldier

- (id)initBurger :(int) lane_num
         startPos:(CGPoint) start
          destPos:(CGPoint) dest
           ourArr:(NSMutableArray*) ourArray
         enemyArr:(NSMutableArray*) enemyArray
         level: (int) soldierLevel;

@end


@interface CokeMan : Soldier

- (id)initCoke :(int) lane_num
         startPos:(CGPoint) start
          destPos:(CGPoint) dest
           ourArr:(NSMutableArray*) ourArray
         enemyArr:(NSMutableArray*) enemyArray
          level: (int) soldierLevel;

@end

@interface FriesMan : Soldier

- (id)initFries :(int) lane_num
       startPos:(CGPoint) start
        destPos:(CGPoint) dest
         ourArr:(NSMutableArray*) ourArray
       enemyArr:(NSMutableArray*) enemyArray
           level: (int) soldierLevel;

@end

@interface PotatoMan : Soldier

- (id)initPotato :(int) lane_num
        startPos:(CGPoint) start
         destPos:(CGPoint) dest
          ourArr:(NSMutableArray*) ourArray
        enemyArr:(NSMutableArray*) enemyArray
            level: (int) soldierLevel;

@end

@interface BeanMan : Soldier

- (id)initBean :(int) lane_num
         startPos:(CGPoint) start
          destPos:(CGPoint) dest
           ourArr:(NSMutableArray*) ourArray
         enemyArr:(NSMutableArray*) enemyArray
         level: (int) soldierLevel;

@end

@interface BananaMan : Soldier

- (id)initBanana :(int) lane_num
       startPos:(CGPoint) start
        destPos:(CGPoint) dest
         ourArr:(NSMutableArray*) ourArray
       enemyArr:(NSMutableArray*) enemyArray
       level: (int) soldierLevel;

@end