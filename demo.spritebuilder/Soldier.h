//
//  Soldier.h
//  demo
//
//  Created by 丁硕青 on 9/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Soldier : CCNode{
    
    int total_health;
    int health;
    NSDate *last_attack_time;
    bool moving;
    int type;         // 0: tank, 1: melee-DPS, 2: ranged-DPS, 3: missile launcher, 4: base
    int atkRange;
    int atkPower;
    float atkInterval;  // the time interval between every attack
    float defence;    // value is from 0 ~ 1(100%)
    int moveSpeed;   // the distance soldier can move per second
    int value;       // the resource gained when the enemy dead
    int cost;
    int costInc;
    int energy;
    int level;
    OALSimpleAudio *audio;

}
@property NSInteger *id;
//@property NSString *name;

@property int group;         // 0: healthy 1:junk



@property int ability_id;
@property int lane_num;
@property CGPoint start_pos;
@property CGPoint dest_pos;
@property CCNode* soldier;
@property CCNode* animationNode;

@property CCNode* bgNode;
@property CCNode* dead_body;

@property CCAction* walkingAct;
@property CCAction* fightingAct;

@property NSMutableArray* ourArray;
@property NSMutableArray* enemyArray;

- (id)initSoldier:(NSString*) img
                  group:(int) group
                  lane_num:(int) lane_num
                  startPos:(CGPoint) start
                  destPos:(CGPoint) destPos
                  ourArr:(NSMutableArray*) ourArray
                  enemyArr:(NSMutableArray*) enemyArray
                  level:(int) soldierLevel
                  bgNode:(CCNode*)bgNode;

- (void)initAnimation;

- (CCAnimation*)loadAnimation:(NSString*) character
                  frameNumber:(int) frameNum
                     interval:(float)aniInterval
                    doubleInt:(BOOL)doubleInt;
- (void)loadWalkAnimation:(NSString*) character
                    frameNumber:(int) frameNum;
- (void)loadFightAnimation:(NSString*) character
               frameNumber:(int) frameNum;
- (int)loseHealth:(int)Attack;
- (void)attackAnimation:(Soldier*) target;
- (void)update_health;
- (void)move;
- (void)dead;
- (int)getLevel;
- (int)getEnergy;
- (int)getAtkPower;
- (int)getAtkRange;
- (double)getDefence;
- (int)getHealth;
- (int)getAtkInt;
- (int)getMoveSpeed;
- (int)getValue;
- (int)getUpgradeCost:(int)level;

- (NSMutableArray*)getOurArray;
- (NSMutableArray*)getEnemeyArray;

- (CCNode*)getBgNode;
- (CCNode*)getSoldier;
- (CCNode*)getAniNode;

- (NSMutableArray*)getArray:(int) enemy;

- (int)getType;
- (BOOL)isMoving;

@end



@interface BurgerMan : Soldier
@property CCNode* cokeAniNode;
- (id)initBurger :(int) lane_num
         startPos:(CGPoint) start
          destPos:(CGPoint) dest
           ourArr:(NSMutableArray*) ourArray
         enemyArr:(NSMutableArray*) enemyArray
            level: (int) soldierLevel
           bgNode:(CCNode*)bgNode;


@end


@interface CokeMan : Soldier

- (void)attackAnimation:(Soldier*) target;
- (id)initCoke :(int) lane_num
         startPos:(CGPoint) start
          destPos:(CGPoint) dest
           ourArr:(NSMutableArray*) ourArray
         enemyArr:(NSMutableArray*) enemyArray
            level: (int) soldierLevel
           bgNode:(CCNode*)bgNode;


@end



@interface PotatoMan : Soldier

+ (int) getEnergy: (int)lvl;
- (id)initPotato :(int) lane_num
        startPos:(CGPoint) start
         destPos:(CGPoint) dest
          ourArr:(NSMutableArray*) ourArray
        enemyArr:(NSMutableArray*) enemyArray
           level: (int) soldierLevel
          bgNode:(CCNode*)bgNode;


@end

@interface BeanMan : Soldier

+ (int) getEnergy: (int)lvl;
- (void)attackAnimation:(Soldier*) target;
- (id)initBean :(int) lane_num
         startPos:(CGPoint) start
          destPos:(CGPoint) dest
           ourArr:(NSMutableArray*) ourArray
         enemyArr:(NSMutableArray*) enemyArray
         level: (int) soldierLevel
         bgNode:(CCNode*)bgNode;


@end

@interface BananaMan : Soldier

+ (int) getEnergy: (int)lvl;
- (id)initBanana :(int) lane_num
       startPos:(CGPoint) start
        destPos:(CGPoint) dest
         ourArr:(NSMutableArray*) ourArray
       enemyArr:(NSMutableArray*) enemyArray
       level: (int) soldierLevel
           bgNode:(CCNode*)bgNode;


@end

@interface Base : Soldier

@property BOOL isDead;

- (void)dead;
- (id)initBase :(CGPoint) start
                group:(int) group
                ourArr:(NSMutableArray*) ourArray
                enemyArr:(NSMutableArray*) enemyArray
                bgNode:(CCNode*)bgNode;

@end

@interface CornMan : Soldier

@property BOOL readyLaunch;
@property CCNode* missile;

+ (int) getEnergy: (int)lvl;
- (void) undoReady;
- (BOOL) readyToLaunch;
- (void) Launch:(CGPoint) targetLoc;
- (void) move;
- (void) cornLuanchshock;

- (id)initCorn :(int) lane_num
                startPos:(CGPoint) start
                destPos:(CGPoint) dest
                ourArr:(NSMutableArray*) ourArray
                enemyArr:(NSMutableArray*) enemyArray
                level: (int) soldierLevel
                bgNode:(CCNode*)bgNode;

@end


@interface FriesMan : Soldier

@property BOOL readyLaunch;
@property CCNode* missile;

- (void) undoReady;
- (BOOL) readyToLaunch;
- (void) Launch:(CGPoint) targetLoc;
- (void) move;

- (id)initFries :(int) lane_num
        startPos:(CGPoint) start
         destPos:(CGPoint) dest
          ourArr:(NSMutableArray*) ourArray
        enemyArr:(NSMutableArray*) enemyArray
           level: (int) soldierLevel
            bgNode:(CCNode*)bgNode;

@end

@interface FoodTruck : Soldier

@property BOOL readyLaunch;

- (void) undoReady;
- (BOOL) readyToLaunch;
- (void) Launch:(CGPoint) targetLoc;
- (void) move;

- (id)initFoodTruck :(int) lane_num
        startPos:(CGPoint) start
         destPos:(CGPoint) dest
          ourArr:(NSMutableArray*) ourArray
        enemyArr:(NSMutableArray*) enemyArray
           level: (int) soldierLevel
          bgNode:(CCNode*)bgNode;

@end