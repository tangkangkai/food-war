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

- (int)getMoveSpeed {
    return moveSpeed;
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

- (NSMutableArray*)getArray:(int) enemy{
    if( enemy )
        return _enemyArray;
    else{
        return _ourArray;
    }
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
        
        [self attackAnimation:target];
        if( [ target loseHealth:atkPower ] == 0 ){
            if( [self detectEnemy] == NULL ){
                [self move];
            }
        }
    }
}

- (void)attackAnimation:(Soldier*)target{
}

- (Soldier*)detectEnemy{
    int nearest_distance = atkRange-8;
    Soldier *target = NULL;
    CGPoint self_pos = [self soldier].position;
    
    for( Soldier *s in _enemyArray ){
        CGPoint enemy_pos = [s soldier].position;
        if( [ s getType ] == 4 ){
            // give a virtual position for bases
            enemy_pos = _dest_pos;
            if( _group == 0 ){
                enemy_pos.x = enemy_pos.x + 30;
            }
            else if( _group == 1){
                enemy_pos.x = enemy_pos.x - 30;
            }
        }
        
        if( type == 3 ){
            double dx = ABS(self_pos.x-enemy_pos.x);
            double dy = ABS(self_pos.y-enemy_pos.y);
            double dist = sqrt(dx*dx + dy*dy);
            if( dist < nearest_distance ){
                target = s;
                nearest_distance = dist;
            }
        }
        else if( ( [s lane_num] == -1 || _lane_num == [ s lane_num ] ) &&
           ABS(enemy_pos.x-self_pos.x)< nearest_distance ){
            
            target = s;
            nearest_distance = ABS(enemy_pos.x-self_pos.x);
            // TODO find the enemy with the smallest health
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
    audio = [OALSimpleAudio sharedInstance];

    if (img != NULL) {
        _soldier = [CCBReader load:img];
        [_soldier setZOrder:999];
    }
    start.y += arc4random() % 8;
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
    BOOL update = false;
    for( int i = 0; i<[_soldier children].count; i++ ){
        if( [ [_soldier children][i] isKindOfClass:[CCNodeColor class]] ){
            CCNodeColor *healthBar = [ _soldier children][i];

            if( !update ){
                [healthBar setContentSize:CGSizeMake( (((float)health / (float)total_health))*100, 100)];
                update = true;
            }
            [ healthBar setVisible:true];
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
    total_health = health;

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
    total_health = health;

    self = [ super initSoldier:@"cokeMan" group:1 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    
    return self;
}


- (void)attackAnimation:(Soldier*) target{
    CCNode *bullet = [CCBReader load:@"coke_bullet"];
    
    bullet.position = CGPointMake([[self soldier] position].x-5, [[self soldier] position].y+15);;
    CCNode * parent = [self soldier].parent;
    [parent addChild:bullet];
    float duration = ABS(bullet.position.x - [[target soldier] position].x)/atkRange;
    
    CGPoint newLoc = [[target soldier] position];
    if( [target isMoving] ){
        newLoc.x = [[target soldier] position].x + [target getMoveSpeed]*duration;
    }
    
    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration
                                                   position: newLoc];
    CCActionRemove *actionRemove = [CCActionRemove action];
    [bullet runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove ]]];
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
    total_health = health;


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
    total_health = health;

    self = [ super initSoldier:@"bean" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    
    return self;
}
- (void)attackAnimation:(Soldier*) target{
    CCNode *bullet = [CCBReader load:@"bean_bullet"];
    
    bullet.position = CGPointMake([[self soldier] position].x+10, [[self soldier] position].y+5);;
    CCNode * parent = [self soldier].parent;
    [parent addChild:bullet];
    float duration = ABS(bullet.position.x - [[target soldier] position].x)/atkRange;

    CGPoint newLoc = [[target soldier] position];
    if( [target isMoving] ){
        newLoc.x = [[target soldier] position].x - [target getMoveSpeed]*duration;
    }
    
    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration
                                                   position: newLoc];
    CCActionRemove *actionRemove = [CCActionRemove action];
    [bullet runAction:[CCActionSequence actionWithArray:@[actionMove, actionRemove ]]];
    
}@end

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
    total_health = health;

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
    total_health = health;

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
        [self schedule:@selector(flash) interval:0.1];

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
    CCNode *readySign = [[self getSoldier] children][4];
    [readySign setVisible:false];
}

- (void) Launch:(CGPoint) targetLoc{
    CCParticleSystem *fire = (CCParticleSystem *)[CCBReader load:@"fire"];
    fire.autoRemoveOnFinish=true;
    fire.duration=0.2;
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:1.0f angle:90.f];
    CCActionJumpTo* jumpUp = [CCActionJumpTo actionWithDuration:1.0f position:targetLoc
                                                         height:80 jumps:1];
    CCActionSpawn *groupAction = [CCActionSpawn actionWithArray:@[rotate, jumpUp]];
    
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[groupAction, [CCActionCallFunc actionWithTarget:self selector:@selector(missileRemoved)]]];
    // allDone is your method to run...
    _missile = [CCBReader load:@"missle"];
    _missile.position = [[ self getSoldier] position];
    CCNode *parent = [[ self getSoldier ] parent];
    [parent addChild:_missile];

    fire.position=_missile.position;
    [self addChild:fire];
    [audio playEffect:@"missle_launch.mp3"];
    [_missile runAction:sequence];

    last_attack_time = [NSDate date];
    [self undoReady];
}

- (void)missileRemoved
{
    NSMutableArray *_targetLoseHealth;
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explosion"];
    //  make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    explosion.duration = 1;
    
    // place the particle effect on the seals position
    explosion.position = _missile.position;
    // add the particle effect to the same node the seal is on
    [_missile.parent addChild:explosion];
    [audio playEffect:@"explode.mp3"];
    
    _targetLoseHealth=[self missileDetect];
    for (Soldier *target in _targetLoseHealth) {
        [target loseHealth:atkPower];
    }
    // finally, remove the destroyed seal
    [_missile removeFromParent];
}

//find target the missle hit
-(NSMutableArray*)missileDetect{
    //  int nearest_distance=[self missile_atk_range];
    Soldier *soldier = NULL;
    NSMutableArray* targets = [NSMutableArray arrayWithObjects:nil ];
    int dx;
    int dy;
    int exploreRange = 40;
    NSMutableArray *enemyArray = [ self getArray:1 ];
    for( long i = 0; i < enemyArray.count; i++ ){
        soldier=[enemyArray objectAtIndex:i];
        dx=ABS(_missile.position.x-[[soldier soldier]position].x);
        dy=ABS(_missile.position.y-[[soldier soldier] position].y);
        double dist = sqrt(dx*dx + dy*dy);
        if (dist < exploreRange) {
            [targets addObject:[enemyArray objectAtIndex:i]];
        }
    }
    return targets;
    
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
    atkPower = 40 + 15 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 120 + 20 * soldierLevel;
    total_health = health;
    
    self = [ super initSoldier:@"corn" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    [self schedule:@selector(countDown) interval:0.5];

    return self;
}

-(void)countDown{
    CCNodeColor *countBar = [[self getSoldier] children][3];
    if( last_attack_time != nil  ){
        float timeDiff = [last_attack_time timeIntervalSinceNow]*-1;
        if( timeDiff < 10){
            [countBar setContentSize:CGSizeMake((timeDiff/10.0)*100, 100)];
        }
        else{
            [countBar setContentSize:CGSizeMake(100, 100)];
            CCNode *readySign = [[self getSoldier] children][4];
            [readySign setVisible:true];
        }
    }
    else if( !moving ){
        CCNode *readySign = [[self getSoldier] children][4];
        [readySign setVisible:true];
    }
}

-(void)flash{
    
    CCNode *s = [self getSoldier];
    for( int i = 0; i<[s children].count; i++ ){
        if( [ [s children][i] isKindOfClass:[CCSprite class]] ){
            CCSprite *body = [s children][i];
                
            body.opacity = body.opacity+0.1;
            if( body.opacity > 1 )
                body.opacity = body.opacity-1;
        }
    }
}
@end

@implementation FriesMan

- (BOOL) readyToLaunch{
    
    if( moving ){
        return false;
    }
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= atkInterval ){
        _readyLaunch = true;
        return true;
    }
    return false;
}

- (void) undoReady{
    _readyLaunch = false;
}

- (void) Launch:(CGPoint) targetLoc{
    CCParticleSystem *fire = (CCParticleSystem *)[CCBReader load:@"fire"];
    fire.autoRemoveOnFinish=true;
    fire.duration=0.2;
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:1.0f angle:-90.f];
    CCActionJumpTo* jumpUp = [CCActionJumpTo actionWithDuration:1.0f position:targetLoc
                                                         height:80 jumps:1];
    CCActionSpawn *groupAction = [CCActionSpawn actionWithArray:@[rotate, jumpUp]];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[groupAction, [CCActionCallFunc actionWithTarget:self selector:@selector(missileRemoved)]]];
    // allDone is your method to run...
    _missile = [CCBReader load:@"friesMissile"];
    _missile.position = [[ self getSoldier] position];
    CCNode *parent = [[ self getSoldier ] parent];
    [parent addChild:_missile];
    
    fire.position=_missile.position;
    [self addChild:fire];
    [audio playEffect:@"missle_launch.mp3"];
    [_missile runAction:sequence];
    
    last_attack_time = [NSDate date];
    [self undoReady];
}

- (void)missileRemoved
{
    NSMutableArray *_targetLoseHealth;
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explosion"];
    //  make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    explosion.duration = 1;
    
    // place the particle effect on the seals position
    explosion.position = _missile.position;
    // add the particle effect to the same node the seal is on
    [_missile.parent addChild:explosion];
    [audio playEffect:@"explode.mp3"];
    
    _targetLoseHealth=[self missileDetect];
    for (Soldier *target in _targetLoseHealth) {
        [target loseHealth:atkPower];
    }
    // finally, remove the destroyed seal
    [_missile removeFromParent];
}

//find target the missle hit
-(NSMutableArray*)missileDetect{
    //  int nearest_distance=[self missile_atk_range];
    Soldier *soldier = NULL;
    NSMutableArray* targets = [NSMutableArray arrayWithObjects:nil ];
    int dx;
    int dy;
    int exploreRange = 40;
    NSMutableArray *enemyArray = [ self getArray:1 ];
    for( long i = 0; i < enemyArray.count; i++ ){
        soldier=[enemyArray objectAtIndex:i];
        dx=ABS(_missile.position.x-[[soldier soldier]position].x);
        dy=ABS(_missile.position.y-[[soldier soldier] position].y);
        double dist = sqrt(dx*dx + dy*dy);
        if (dist < exploreRange) {
            [targets addObject:[enemyArray objectAtIndex:i]];
        }
    }
    return targets;
    
}

-(void)move{
    if( !_readyLaunch ){
        [super move];
    }
}

- (id)initFries: (int) lane_num
       startPos:(CGPoint) start
        destPos:(CGPoint) dest
         ourArr:(NSMutableArray*) ourArray
       enemyArr:(NSMutableArray*) enemyArray
          level: (int) soldierLevel {
    
    type = 3;
    _readyLaunch = false;
    moveSpeed = 20;
    atkInterval = 10;
    atkRange = 350;
    atkPower = 40 + 15 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 200 + 20 * soldierLevel;
    health = 120 + 20 * soldierLevel;
    total_health = health;
    self = [ super initSoldier:@"friesMan" group:1 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel];
    [self schedule:@selector(countDown) interval:0.5];
    return self;
}

-(void)countDown{
    NSMutableArray *healthArray = [ self getArray:1 ];
    if ([self readyToLaunch]) {
        int range=[self getAtkRange];
        for( Soldier *s in healthArray ){
            CGPoint enemy_pos = [s soldier].position;
            if( [ s getType ] == 4 ){
                // make the base reachable
                enemy_pos.x = enemy_pos.x + 70;
            }
            
            CGFloat xDist = (enemy_pos.x - [self soldier].position.x);
            CGFloat yDist = (enemy_pos.y - [self soldier].position.y);
            CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
            if (distance<range && [s soldier].position.x<[self soldier].position.x-20) {
                [self Launch:[s soldier].position];
                return;
            }
        }
    }
}


@end

