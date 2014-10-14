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

}

// get methods implementations add by kk
- (int)getLevel {
    return level;
}
- (int)getAtkPower {
    return atkPower;
}

- (int)getAtkRange {
    return atkRange;
}

- (int)getAtkInt {
    return atkInterval;
}

- (int)getType {
    return type;
}

- (BOOL)isMoving {
    return moving;
}

- (double)getDefence {
    return defence;
}

- (int)getHealth {
    return health;
}

- (int)loseHealth:(int)Attack {
    int lostHeath = Attack * (1 - defence);
    health = health - lostHeath;
    if( health <= 0 ){
        [self dead];
        return 0;
    }
    [self update_health];
    return health;
}

- (CCNode*)getSoldier{
    return _soldier;
}

- (void)doAttack{
    if( type == 4 )
        return;
    
    Soldier *target = [self detectEnemy];
    if( target == NULL){
        [self move];
        moving = true;
        return;
    }
    [[ self soldier ] stopAllActions ];
    moving = false;
    // for missle launcher
    if( type == 3 )
        return;
    
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= atkInterval ){
        last_attack_time = [NSDate date];
        
        if( [ target loseHealth:atkPower ] == 0 ){
            if( [self detectEnemy] == NULL ){
                [self move];
            }
        }
    }
}

- (Soldier*)detectEnemy{
    int nearest_distance = atkRange-10;
    Soldier *target = NULL;
    CGPoint self_pos = [self soldier].position;
    
    for( Soldier *s in _enemyArray ){
        CGPoint enemy_pos = [s soldier].position;
        if( [ s getType ] == 4 ){
            enemy_pos = _dest_pos;
            if( _group == 0 ){
                enemy_pos.x = enemy_pos.x + 25;
            }
            else if( _group == 1){
                enemy_pos.x = enemy_pos.x - 28;
            }
        }
        
        if( ( [s lane_num] == -1 || _lane_num == [ s lane_num ] ) &&
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
                  enemyArr:(NSMutableArray*) enemyArray
                  level: (int) level{
    
    self = [super init];
    
    moving = false;
    last_attack_time = NULL;
    _lane_num = lane_num;
    
    if (img != NULL) {
        _soldier = [CCBReader load:img];
    }
    start.y += arc4random() % 5;
    _start_pos = start;
    _dest_pos = dest;
    _soldier.position = start; //CGPoint
    _group = group;

    if( health != 0 )
        [self update_health];

    if( ourArray != NULL ){
        [ourArray addObject:self];
        _ourArray = ourArray;
    }
    if( enemyArray != NULL){
        _enemyArray = enemyArray;
    }
    if( _group != -1 ){
        [self schedule:@selector(doAttack) interval:0.1];
    }
    return self;
}


-(void)move{
    if( moving == true || _group == -1 ){
        return;
    }
    
    moving = true;
    int distance = ABS(_dest_pos.x - [_soldier position].x);
    int duration = distance/moveSpeed;
    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration
                                         position:CGPointMake(_dest_pos.x,[_soldier position].y)];
    [_soldier runAction:[CCActionSequence actionWithArray:@[actionMove]]];
}

- (void)dead{
    [[self ourArray] removeObject:self];
    [[self soldier] removeFromParent];
    [self unschedule:@selector(doAttack)];

    if( _group == 1 ){
        [SavedData addMoney:value];
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


@implementation BurgerMan

- (id)initBurger: (int) lane_num
                  startPos:(CGPoint) start
                  destPos:(CGPoint) dest
                  ourArr:(NSMutableArray*) ourArray
                  enemyArr:(NSMutableArray*) enemyArray
                  level: (int) soldierLevel{

    // TODO read level from file
    //level = 1;
    type = 0;
    moveSpeed = 30;
    atkInterval = 4;
    atkRange = 40;
    atkPower = 20 + 5 * soldierLevel;
    defence = 0.2 + 0.05 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 200 + 50 * soldierLevel;
    self = [ super initSoldier:@"burgerMan" group:1 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    
    return self;
}

@end

@implementation CokeMan

- (id)initCoke: (int) lane_num
        startPos:(CGPoint) start
         destPos:(CGPoint) dest
          ourArr:(NSMutableArray*) ourArray
        enemyArr:(NSMutableArray*) enemyArray
        level: (int) soldierLevel{
    
    // TODO read level from file
    //level = 1;
    type = 2;

    moveSpeed = 35;
    atkInterval = 1;
    atkRange = 180;
    atkPower = 5 + 5 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 100 + 20 * soldierLevel;
    self = [ super initSoldier:@"cokeMan" group:1 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    
    return self;
}

- (void)doAttack{
    if( type == 4 )
        return;
    
    Soldier *target = [self detectEnemy];
    if( target == NULL){
        [self move];
        moving = true;
        return;
    }
    [[ self soldier ] stopAllActions ];
    moving = false;
    // for missle launcher
    if( type == 3 )
        return;
    
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= atkInterval ){
        last_attack_time = [NSDate date];
        
        CCNode *bullet = [CCBReader load:@"coke_bullet"];
        bullet.position = [[self soldier] position];
        CCNode * parent = [self soldier].parent;
        [parent addChild:bullet];
        CCAction *actionMove=[CCActionMoveTo actionWithDuration: 1
                                                       position:[[target soldier] position]];
        CCActionRemove *actionRemove = [CCActionRemove action];
        
        [bullet runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove ]]];
        if( [ target loseHealth:atkPower ] == 0 ){
            if( [self detectEnemy] == NULL ){
                [self move];
            }
        }
    }
}

@end

@implementation FriesMan

- (id)initFries: (int) lane_num
      startPos:(CGPoint) start
       destPos:(CGPoint) dest
        ourArr:(NSMutableArray*) ourArray
      enemyArr:(NSMutableArray*) enemyArray
      level: (int) soldierLevel
    {
    
    // TODO read level from file
    //level = 1;
    type = 3;
    
    moveSpeed = 20;
    atkInterval = 10;
    atkRange = 200;
    atkPower = 50 + 20 * level;
    defence = 0.1 + 0.03 * level;
    value = 200 + 20 * level;
    health = 150 + 30 * level;
    self = [ super initSoldier:@"friesMan" group:1 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    
    return self;
}

@end

@implementation PotatoMan

- (id)initPotato: (int) lane_num
       startPos:(CGPoint) start
        destPos:(CGPoint) dest
         ourArr:(NSMutableArray*) ourArray
       enemyArr:(NSMutableArray*) enemyArray
        level: (int) soldierLevel{
    
    // TODO read level from file
    level = 1;
    type = 0;
    
    moveSpeed = 30;
    atkInterval = 4;
    atkRange = 40;
    atkPower = 20 + 5 * soldierLevel;
    defence = 0.2 + 0.05 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 200 + 50 * soldierLevel;

    self = [ super initSoldier:@"potatoMan" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    
    return self;
}

@end

@implementation BeanMan

- (id)initBean: (int) lane_num
      startPos:(CGPoint) start
       destPos:(CGPoint) dest
        ourArr:(NSMutableArray*) ourArray
      enemyArr:(NSMutableArray*) enemyArray
        level: (int) soldierLevel{
    
    // TODO read level from file
    level = 1;
    type = 2;
    
    moveSpeed = 35;
    atkInterval = 1;
    atkRange = 180;
    atkPower = 5 + 5 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 100 + 20 * soldierLevel;
    self = [ super initSoldier:@"bean" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    
    return self;
}

- (void)doAttack{
    if( type == 4 )
        return;
    
    Soldier *target = [self detectEnemy];
    if( target == NULL){
        [self move];
        moving = true;
        return;
    }
    [[ self soldier ] stopAllActions ];
    moving = false;
    // for missle launcher
    if( type == 3 )
        return;
    
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= atkInterval ){
        last_attack_time = [NSDate date];
        
        CCNode *bullet = [CCBReader load:@"bean_bullet"];
        bullet.position = [[self soldier] position];
        CCNode * parent = [self soldier].parent;
        [parent addChild:bullet];
        CCAction *actionMove=[CCActionMoveTo actionWithDuration: 1
                                                       position:[[target soldier] position]];
        CCActionRemove *actionRemove = [CCActionRemove action];

        [bullet runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove ]]];
        if( [ target loseHealth:atkPower ] == 0 ){
            if( [self detectEnemy] == NULL ){
                [self move];
            }
        }
    }
}
@end

@implementation BananaMan

- (BOOL) readyToLaunch{
    if( moving ){
        return false;
    }
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= atkInterval ){
        return true;
    }
    return false;
}

- (void) Launch{
    last_attack_time = [NSDate date];
}

- (id)initBanana: (int) lane_num
      startPos:(CGPoint) start
       destPos:(CGPoint) dest
        ourArr:(NSMutableArray*) ourArray
      enemyArr:(NSMutableArray*) enemyArray
      level: (int) soldierLevel{
    
    // TODO read level from file
    level = 1;
    type = 2;
    
    moveSpeed = 35;
    atkInterval = 2;
    atkRange = 40;
    atkPower = 15 + 6 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 140 + 20 * soldierLevel;
    self = [ super initSoldier:@"banana" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    
    return self;
}
@end


@implementation Base

- (id)initBase:(CGPoint) start
               group:(int) group
               ourArr:(NSMutableArray*) ourArray
               enemyArr:(NSMutableArray*) enemyArray{
    
    // TODO read level from file
    level = 1;
    type = 4;
    _isDead = false;
    //atkInterval = 1;
    //atkRange = 120;
    //atkPower = 5 + 5 * level;
    defence = 0.2 + 0.03 * level;
    value = 100 + 20 * level;
    health = 1000 + 200 * level;
    self = [ super initSoldier:@"base" group:group lane_num:-1 startPos:start destPos:start ourArr:ourArray enemyArr:enemyArray level:level];
    
    return self;
}

- (void)dead{
    [ super dead ];
    _isDead = true;
}

@end

@implementation CornMan

- (BOOL) readyToLaunch{
    
    if( moving ){
        return false;
    }
    
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= atkInterval ){
        _readyLaunch = true;
        [self schedule:@selector(flash) interval:0.5];
        return true;
    }
    return false;
}

- (void) undoReady{
    _readyLaunch = false;
    [self unschedule:@selector(flash)];
    CCNode *s = [self getSoldier];
    for( int i = 0; i<[s children].count; i++ ){
        if( [ [s children][i] isKindOfClass:[CCSprite class]] ){
            CCSprite *body = [s children][i];
            body.opacity = 1;
        }
    }
}

- (void) Launch{
    last_attack_time = [NSDate date];
    [self undoReady];
}

-(void)move{
    if( !_readyLaunch ){
        
        [super move];
    }
}

- (id)initCorn: (int) lane_num
        startPos:(CGPoint) start
         destPos:(CGPoint) dest
          ourArr:(NSMutableArray*) ourArray
        enemyArr:(NSMutableArray*) enemyArray
           level: (int) soldierLevel{
    
    // TODO read level from file
    level = 1;
    type = 3;
    _readyLaunch = false;
    moveSpeed = 20;
    atkInterval = 10;
    atkRange = 350;
    atkPower = 20 + 8 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 120 + 20 * soldierLevel;
    self = [ super initSoldier:@"corn" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];

    return self;
}


-(void)flash{

        CCNode *s = [self getSoldier];
        for( int i = 0; i<[s children].count; i++ ){
            if( [ [s children][i] isKindOfClass:[CCSprite class]] ){
                CCSprite *body = [s children][i];
                body.opacity = (body.opacity + 0.5)/1;
            }
        }
    
    
}
@end
