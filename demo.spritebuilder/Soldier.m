//
//  Soldier.m
//  demo
//
//  Created by 丁硕青 on 9/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Soldier.h"
#import "SavedData.h"
#import "Gameplay.h"
#import "CCAnimation.h"
#import <UIKit/UIKit.h>
#include <CCDirector.h>
#import "CCAction.h"
#import "Energy.h"
#import "Scrollback.h"
#include <stdlib.h>

@implementation Soldier{
    
}


// get value of soldier(energy gained/reduced)
- (int)getValue {
    return 75 + 25 * [self getLevel];
}

// get methods implementations add by kk
- (int)getLevel {
    return level;
}

- (void)setLevel: (int)newLevel {
    level = newLevel;
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

- (int)getEnergy{
    return energy;
}

- (int)getHealth {
    return health;
}

- (int)getMoveSpeed {
    return moveSpeed;
}

- (CCNode*)getBgNode{
    return _bgNode;
}

- (void)initAnimation{
}

- (NSMutableArray*)getOurArray{
    return _ourArray;
}

- (NSMutableArray*)getEnemeyArray{
    return _enemyArray;
}



- (void)loadFirstAnimation:(NSString*) character{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat:@"%@Ani.plist", character]];
    CCSpriteFrame* frame = [CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"%@0.png", character]];
    _animationNode = [CCSprite spriteWithSpriteFrame:frame];
    _animationNode.position = [_soldier position];
    
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@Ani.png", character]];
    [_bgNode addChild:spriteSheet];
    
    [spriteSheet addChild:_animationNode];
    [spriteSheet setZOrder:900];
    [_animationNode setZOrder:900];

}

- (CCAnimation*)loadAnimation:(NSString*) character
                              frameNumber:(int) frameNum
                              interval:(float)aniInterval
                              doubleInt:(BOOL)doubleInt{
    NSMutableArray *soldierAnimFrames = [NSMutableArray array];
    
    for (int i=0; i<frameNum; i++) {
        if( doubleInt && i<10 ){
            [soldierAnimFrames addObject:
                [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                [NSString stringWithFormat:@"%@0%d.png", character, i]]];
        }
        else{
            [soldierAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"%@%d.png", character, i]]];
        }
    }
    
    return [CCAnimation animationWithSpriteFrames:soldierAnimFrames delay:aniInterval];
}

- (void)loadWalkAnimation:(NSString*) character
          frameNumber:(int) frameNum{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat:@"%@Ani.plist", character]];
    CCAnimation* ani = [self loadAnimation:character frameNumber:frameNum interval:0.15f doubleInt:false];
    
    _walkingAct = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:ani]];
    _walkingAct.tag = 10;
}


- (void)loadFightAnimation:(NSString*) character
              frameNumber:(int) frameNum{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat:@"%@FightAni.plist", character]];
    CCAnimation* ani;
    if( frameNum > 10 ){
        ani = [self loadAnimation:character frameNumber:frameNum interval:0.04f doubleInt:true];
    }
    else{
        ani = [self loadAnimation:character frameNumber:frameNum interval:0.04f doubleInt:false];
    }
    _fightingAct = [CCActionAnimate actionWithAnimation:ani];
    _fightingAct.tag = 11;
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
        return;
    }
    [[ self soldier ] stopAllActions ];
    if(_animationNode != NULL){
        [_animationNode stopAction:_walkingAct];
    }
    moving = false;
    
    // for missle launcher
    if( type == 3 )
        return;
    
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= atkInterval ){
        last_attack_time = [NSDate date];
        if( _fightingAct != nil){
            [_animationNode runAction:_fightingAct];
        }
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
            if( (_group == 0 && [[s soldier] position].x < self_pos.x)
               || (_group ==1 && [[s soldier] position].x > self_pos.x)){
                continue;
            }
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
                  level: (int) soldierLevel
                  bgNode:(CCNode*)bgNode{
    
    self = [super init];
    [self setLevel:soldierLevel];
    moving = false;
    last_attack_time = NULL;
    _lane_num = lane_num;
    audio = [OALSimpleAudio sharedInstance];

    _bgNode = bgNode;
    if (img != NULL) {
        _soldier = [CCBReader load:img];

        if( _bgNode != NULL){
            [_bgNode addChild:_soldier];
        }
        [_soldier setZOrder:999];

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
        [self initAnimation];
        if ( _animationNode == NULL){
            [(CCSprite*)[_soldier children][0] setVisible:true];
        }
        else{
            [(CCSprite*)[_soldier children][0] setVisible:false];
        }

    }
    
    return self;
}


-(void)move{
    if( _animationNode != NULL ){
        [_animationNode setPosition:[_soldier position]];
        CCAction* act = [_animationNode getActionByTag:10];
        if( act == nil )
            [_animationNode runAction:_walkingAct];
    }
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
    if( _group == 1 && [self getType]!=4){
        Energy* dropoff= [[Energy alloc] initEnergy:[self getValue] pos:[[self soldier]position] bgNode:[self soldier].parent];
        [Scrollback fillEnergyArray:dropoff];
    }
    
    [[self ourArray] removeObject:self];
    [[self soldier] removeFromParent];
    [self unschedule:@selector(doAttack)];
    
    if( _animationNode != NULL ){
        [_animationNode removeFromParent];
    }
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
                  level: (int) soldierLevel
                  bgNode:(CCNode*)bgNode{

    type = 0;
    moveSpeed = 30;
    atkInterval = 4;
    atkRange = 40;
    atkPower = 20 + 5 * soldierLevel;
    defence = 0.2 + 0.05 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 200 + 50 * soldierLevel;
    total_health = health;
    
    self = [ super initSoldier:@"burgerMan"
                               group:1
                               lane_num:lane_num
                               startPos:start
                               destPos:dest
                               ourArr:ourArray
                               enemyArr:enemyArray
                               level:soldierLevel
                               bgNode:bgNode];
    return self;
}

- (void)initAnimation{
    [self loadFirstAnimation:@"burger"];
    [self loadWalkAnimation:@"burger" frameNumber:8];
    [self loadFightAnimation:@"burger" frameNumber:8];
}

@end

@implementation CokeMan

- (id)initCoke: (int) lane_num
                startPos:(CGPoint) start
                destPos:(CGPoint) dest
                ourArr:(NSMutableArray*) ourArray
                enemyArr:(NSMutableArray*) enemyArray
                level:(int) soldierLevel
                bgNode:(CCNode*)bgNode{
    type = 2;

    moveSpeed = 35;
    atkInterval = 1;
    atkRange = 180;
    atkPower = 5 + 5 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 100 + 20 * soldierLevel;
    total_health = health;

    self = [ super initSoldier:@"cokeMan"
                         group:1
                      lane_num:lane_num
                      startPos:start
                       destPos:dest
                        ourArr:ourArray
                      enemyArr:enemyArray
                         level:soldierLevel
                        bgNode:bgNode];
    return self;
}

- (void)initAnimation{
    [self loadFirstAnimation:@"coke"];
    [self loadWalkAnimation:@"coke" frameNumber:7];
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
          level:(int) soldierLevel
         bgNode:(CCNode*)bgNode{

    type = 0;
    moveSpeed = 30;
    atkInterval = 4;
    atkRange = 40;
    atkPower = 20 + 5 * soldierLevel;
    defence = 0.2 + 0.05 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 200 + 50 * soldierLevel;
    energy = [PotatoMan getEnergy:soldierLevel];

    total_health = health;

    self = [ super initSoldier:@"potatoMan"
                   group:0
                   lane_num:lane_num
                   startPos:start
                   destPos:dest
                   ourArr:ourArray
                   enemyArr:enemyArray
                   level:soldierLevel
                   bgNode:bgNode];
    return self;
}

+ (int)getEnergy: (int) lvl{
    return 200 + 40 * lvl;
}

- (void)initAnimation{
    [self loadFirstAnimation:@"potato"];
    [self loadWalkAnimation:@"potato" frameNumber:8];
    [self loadFightAnimation:@"potato" frameNumber:12];

}

@end

@implementation BeanMan

- (id)initBean: (int) lane_num
      startPos:(CGPoint) start
       destPos:(CGPoint) dest
        ourArr:(NSMutableArray*) ourArray
      enemyArr:(NSMutableArray*) enemyArray
         level: (int) soldierLevel
        bgNode:(CCNode*)bgNode{

    type = 2;
    
    moveSpeed = 35;
    atkInterval = 1;
    atkRange = 180;
    atkPower = 5 + 5 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 100 + 20 * soldierLevel;
    energy = [BeanMan getEnergy:soldierLevel];

    total_health = health;

    self = [ super initSoldier:@"bean" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel bgNode:bgNode ];
    return self;
}

- (void)initAnimation{
    [self loadFirstAnimation:@"bean"];
    [self loadWalkAnimation:@"bean" frameNumber:8];
}

+ (int)getEnergy: (int) lvl{
    return 210 + 45 * lvl;
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

+ (int)getEnergy: (int) lvl{
    return 230 + 50 * lvl;
}

- (id)initBanana: (int) lane_num
      startPos:(CGPoint) start
       destPos:(CGPoint) dest
        ourArr:(NSMutableArray*) ourArray
      enemyArr:(NSMutableArray*) enemyArray
         level:(int) soldierLevel
        bgNode:(CCNode*)bgNode{

    type = 2;
    
    moveSpeed = 35;
    atkInterval = 2;
    atkRange = 40;
    atkPower = 20 + 8 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 140 + 20 * soldierLevel;
    energy = [BananaMan getEnergy:soldierLevel];

    total_health = health;

    self = [ super initSoldier:@"banana" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel bgNode:bgNode ];
    return self;
}

   
- (void)initAnimation{
    [self loadFirstAnimation:@"banana"];
    [self loadWalkAnimation:@"banana" frameNumber:7];
    [self loadFightAnimation:@"banana" frameNumber:9];
}

@end


@implementation Base

- (id)initBase:(CGPoint) start
               group:(int) group
               ourArr:(NSMutableArray*) ourArray
               enemyArr:(NSMutableArray*) enemyArray
               bgNode:(CCNode*)bgNode{
    

    type = 4;
    _isDead = false;
    //atkInterval = 1;
    //atkRange = 120;
    //atkPower = 5 + 5 * level;
    defence = 0.2 + 0.03 * level;
    value = 100 + 20 * level;
    health = 1000 + 200 * level;
    total_health = health;

    self = [ super initSoldier:@"base" group:group lane_num:-1 startPos:start destPos:start ourArr:ourArray enemyArr:enemyArray level:level bgNode:bgNode];
    
    return self;
}

- (void)dead{
    [ super dead ];
    _isDead = true;
}

@end

@implementation CornMan

-(void)dead{
    [super dead];
    [self unschedule:@selector(countDown)];
}

+ (int)getEnergy: (int) lvl{
    return 300 + 50 * lvl;
}

- (BOOL) readyToLaunch{
    
    if( moving ){
        return false;
    }
    
    if( last_attack_time == nil || [ last_attack_time timeIntervalSinceNow ]*-1 >= atkInterval ){
        _readyLaunch = true;
        [self schedule:@selector(flash) interval:0.1];
        [self schedule:@selector(detectTarget) interval:0.1];

        return true;
    }
    return false;
}

- (void) undoReady{
    _readyLaunch = false;
    [self unschedule:@selector(flash)];
    [self unschedule:@selector(detectTarget)];
    [self cancelDetectTarget];
    CCNode *body = [self animationNode];
    body.opacity = 1;
    CCNode *readySign = [[self getSoldier] children][3];
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
    _missile = [CCBReader load:@"missle"];
    _missile.position = [[ self getSoldier] position];
    CCNode *parent = [[ self getSoldier ] parent];
    [parent addChild:_missile];

    fire.position=_missile.position;
    [self addChild:fire];
    if ([SavedData audio]) {
        [audio playEffect:@"missle_launch.mp3"];
    }
    [_missile runAction:sequence];

    last_attack_time = [NSDate date];
    [self undoReady];
}

- (void)missileRemoved
{
    NSMutableArray *_targetLoseHealth;
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explosion"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.duration = 1;
    explosion.position = _missile.position;
    [_missile.parent addChild:explosion];
    if ([SavedData audio]) {
        [audio playEffect:@"explode.mp3"];
    }
    
    _targetLoseHealth=[self missileDetect];
    for (Soldier *target in _targetLoseHealth) {
        [target loseHealth:atkPower];
    }
    [_missile removeFromParent];
}

//find target the missle hit
-(NSMutableArray*)missileDetect{
    Soldier *soldier = NULL;
    NSMutableArray* targets = [NSMutableArray arrayWithObjects:nil ];
    double dx;
    double dy;
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

-(void)detectTarget{
    NSMutableArray *enemyArray = [ self getArray:1 ];
    double dx;
    double dy;
    
    for (Soldier* enemy in enemyArray) {
        dx=ABS([[self soldier] position].x-[[enemy soldier] position].x);
        dy=ABS([[self soldier] position].y-[[enemy soldier] position].y);
        double dist = sqrt(dx*dx + dy*dy);
        if (dist<=[self getAtkRange] && [[self soldier] position].x+40<[[enemy soldier] position].x) {
            for (CCSprite* prop in [[enemy soldier] children]) {
                if ([[prop name] isEqual:@"target"]) {
                    [prop setVisible:true];
                }
            }
        }
        else{
            for (CCSprite* target in [[enemy soldier] children]) {
                if ([[target name] isEqual:@"target"]) {
                    [target setVisible:0];
                }
            }
        }
    }
}

-(void)cancelDetectTarget{
    NSMutableArray *enemyArray = [ self getArray:1 ];
    for (Soldier* enemy in enemyArray) {
        for (CCSprite* target in [[enemy soldier] children]) {
            if ([[target name] isEqual:@"target"]) {
            [target setVisible:0];
                }
        }
    }
}


-(void)move{
    if( !_readyLaunch ){
        [super move];
    }
}


-(void)cornLuanchshock{
    CGPoint oldPos = [[self animationNode] position];
    CCActionMoveTo *moveLeft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(oldPos.x - 20 , oldPos.y)];
    CCActionMoveTo *moveBack = [CCActionMoveTo actionWithDuration:0.5f position:oldPos];
    CCActionSequence *shock = [CCActionSequence actionWithArray:@[moveLeft, moveBack]];

    [[self animationNode] runAction:shock];
}

- (id)initCorn: (int) lane_num
        startPos:(CGPoint) start
         destPos:(CGPoint) dest
          ourArr:(NSMutableArray*) ourArray
        enemyArr:(NSMutableArray*) enemyArray
           level: (int) soldierLevel
        bgNode:(CCNode*)bgNode{

    
    type = 3;
    _readyLaunch = false;
    moveSpeed = 20;
    atkInterval = 10;
    atkRange = 360;
    atkPower = 50 + 20 * soldierLevel;
    defence = 0.1 + 0.03 * soldierLevel;
    value = 100 + 20 * soldierLevel;
    health = 120 + 20 * soldierLevel;
    energy = [CornMan getEnergy:soldierLevel];

    total_health = health;
    
    self = [ super initSoldier:@"corn" group:0 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel bgNode:bgNode ];
    [self schedule:@selector(countDown) interval:0.5];
    return self;
}

-(void)countDown{
    CCNodeColor *countBar = [[self getSoldier] children][2];
    if( last_attack_time != nil  ){
        float timeDiff = [last_attack_time timeIntervalSinceNow]*-1;
        if( timeDiff < 10){
            [countBar setContentSize:CGSizeMake((timeDiff/10.0)*100, 100)];
        }
        else{
            [countBar setContentSize:CGSizeMake(100, 100)];
            CCNode *readySign = [[self getSoldier] children][3];
            if( !moving ){
                [readySign setVisible:true];
            }
            else{
                [readySign setVisible:false];
            }
        }
    }
    else{
        CCNode *readySign = [[self getSoldier] children][3];
        if( !moving ){
            [readySign setVisible:true];
        }
        else{
            [readySign setVisible:false];
        }
    }
}

- (void)initAnimation{
    [self loadFirstAnimation:@"corn"];
    [self loadWalkAnimation:@"corn" frameNumber:7];
}

-(void)flash{
    
    CCNode *body = [self animationNode];

    body.opacity = body.opacity+0.1;
    if( body.opacity > 1 )
        body.opacity = body.opacity-1;
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
    CCActionJumpTo* jumpUp = [CCActionJumpTo actionWithDuration:1.0f position:targetLoc height:80 jumps:1];
    CCActionSpawn *groupAction = [CCActionSpawn actionWithArray:@[rotate, jumpUp]];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[groupAction, [CCActionCallFunc actionWithTarget:self selector:@selector(missileRemoved)]]];
    
    _missile = [CCBReader load:@"friesMissile"];
    _missile.position = [[ self getSoldier] position];
    CCNode *parent = [[ self getSoldier ] parent];
    [parent addChild:_missile];
    
    fire.position=_missile.position;
    [self addChild:fire];
    if ([SavedData audio]) {
        [audio playEffect:@"missle_launch.mp3"];
    }
    [_missile runAction:sequence];
    [self friesLaunchShock];
    
    last_attack_time = [NSDate date];
    [self undoReady];
}

-(void) friesLaunchShock{
    CCNode *fries=[self getSoldier];
    CCActionMoveTo *moveright_0 = [CCActionMoveTo actionWithDuration:0.05f position:ccp(10 , 0)];
    CCActionMoveTo *moveback_0 = [CCActionMoveTo actionWithDuration:0.5f position:ccp(0,0)];
    CCActionSequence *sequence_0 = [CCActionSequence actionWithArray:@[moveright_0, moveback_0]];
    
    CCActionMoveTo *moveright_1 = [CCActionMoveTo actionWithDuration:0.05f position:ccp(-8 , 29)];
    CCActionMoveTo *moveback_1 = [CCActionMoveTo actionWithDuration:0.5f position:ccp(-18,29)];
    CCActionSequence *sequence_1 = [CCActionSequence actionWithArray:@[moveright_1, moveback_1]];
    
    [[fries children][0] runAction:sequence_0];
    [[fries children][1] runAction:sequence_1];

}

- (void)missileRemoved
{
    NSMutableArray *_targetLoseHealth;
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explosion"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.duration = 1;
    
    explosion.position = _missile.position;
    [_missile.parent addChild:explosion];
    if ([SavedData audio]) {
        NSLog(@"hehe");
        [audio playEffect:@"explode.mp3"];
    }
    
    _targetLoseHealth=[self missileDetect];
    for (Soldier *target in _targetLoseHealth) {
        [target loseHealth:atkPower];
    }
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

-(void)dead{
    [super dead];
    [self unschedule:@selector(countDown)];
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
          level: (int) soldierLevel
         bgNode:(CCNode*)bgNode{
    
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
    self = [ super initSoldier:@"friesMan" group:1 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel bgNode:bgNode ];
    
    [self schedule:@selector(countDown) interval:0.5];
    return self;
}

- (void)initAnimation{
    [self loadFirstAnimation:@"fries"];
    [self loadWalkAnimation:@"fries" frameNumber:8];
}

-(void)countDown{
    NSMutableArray *healthArray = [ self getArray:1 ];
    if ([self readyToLaunch]) {
        int range=[self getAtkRange];
        CGPoint target = CGPointMake(0, 0);
        float minDistance = range;
        for( Soldier *s in healthArray ){
            CGPoint enemy_pos = [s soldier].position;
            if( [ s getType ] == 4 ){
                // make the base reachable
                enemy_pos.x = enemy_pos.x + 40;
            }
            
            CGFloat xDist = (enemy_pos.x - [self soldier].position.x);
            CGFloat yDist = (enemy_pos.y - [self soldier].position.y);
            CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
            if (distance<minDistance && [s soldier].position.x<[self soldier].position.x-20) {
                minDistance = distance;
                target = [[s soldier] position];
            }
        }
        if( target.x != 0){
            [self Launch:target];
        }
    }
}


@end

@implementation FoodTruck

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
    CCNode *missle = [CCBReader load:@"friesMissile"];
    missle.position = [[ self getSoldier] position];
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:1.0f angle:-90.f];
    CCActionJumpTo* jumpUp = [CCActionJumpTo actionWithDuration:1.0f position:targetLoc height:80 jumps:1];
    CCActionSpawn *groupAction = [CCActionSpawn actionWithArray:@[rotate, jumpUp]];
    CCActionSequence *sequence = [CCActionSequence
                                  actionWithArray:@[ groupAction,
                                                     [CCActionCallBlock actionWithBlock:^{
                                                        [self missileRemoved:missle];
                                                        }]]];

    CCNode *parent = [[ self getSoldier ] parent];
    [parent addChild:missle];
    
    fire.position=missle.position;
    [self addChild:fire];
    if ([SavedData audio]) {
        [audio playEffect:@"missle_launch.mp3"];
    }
    [missle runAction:sequence];
    
    last_attack_time = [NSDate date];
    [self undoReady];
}

- (void)missileRemoved:(CCNode*) missile
{
    NSMutableArray *_targetLoseHealth;
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explosion"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.duration = 1;
    
    explosion.position = missile.position;
    [missile.parent addChild:explosion];
    if ([SavedData audio]) {
        NSLog(@"hehe");
        [audio playEffect:@"explode.mp3"];
    }
    
    _targetLoseHealth=[self missileDetect:missile];
    for (Soldier *target in _targetLoseHealth) {
        [target loseHealth:atkPower];
    }
    [missile removeFromParent];
}

//find target the missle hit
-(NSMutableArray*)missileDetect:(CCNode*)missile{
    //  int nearest_distance=[self missile_atk_range];
    Soldier *soldier = NULL;
    NSMutableArray* targets = [NSMutableArray arrayWithObjects:nil ];
    int dx;
    int dy;
    int exploreRange = 40;
    NSMutableArray *enemyArray = [ self getArray:1 ];
    
    for( long i = 0; i < enemyArray.count; i++ ){
        soldier=[enemyArray objectAtIndex:i];
        dx=ABS(missile.position.x-[[soldier soldier]position].x);
        dy=ABS(missile.position.y-[[soldier soldier] position].y);
        double dist = sqrt(dx*dx + dy*dy);
        if (dist < exploreRange) {
            [targets addObject:[enemyArray objectAtIndex:i]];
        }
    }
    
    return targets;
}

-(void)dead{
    [super dead];
    [self unschedule:@selector(countDown)];
    [self unschedule:@selector(createSolider)];

}

-(void)move{
    if( !_readyLaunch ){
        [super move];
    }
}

- (id)initFoodTruck: (int) lane_num
       startPos:(CGPoint) start
        destPos:(CGPoint) dest
         ourArr:(NSMutableArray*) ourArray
       enemyArr:(NSMutableArray*) enemyArray
          level: (int) soldierLevel
         bgNode:(CCNode*)bgNode{
    
    type = 3;
    _readyLaunch = false;
    moveSpeed = 15;
    atkInterval = 10;
    atkRange = 350;
    atkPower = 40 + 15 * soldierLevel;
    defence = 0.2 + 0.03 * soldierLevel;
    value = 200 + 20 * soldierLevel;
    health = 400 + 50 * soldierLevel;
    total_health = health;
    
    // Fix the position so that it stand on the lane
    start.y += 25;
    
    self = [ super initSoldier:@"foodTruck" group:1 lane_num:lane_num startPos:start destPos:dest ourArr:ourArray enemyArr:enemyArray level:soldierLevel bgNode:bgNode ];
    
    [self schedule:@selector(countDown) interval:0.5];
    [self schedule:@selector(createSolider) interval:8];

    return self;
}

- (void)createSolider{

    
    Scrollback *sb = (Scrollback*)[self getBgNode];
    NSArray *start_positions = @[[sb house4], [sb house5], [sb house6]];
    NSArray *end_positions=@[ [sb house1], [sb house2], [sb house3]];
    int lane = arc4random_uniform(3);

    CGPoint destination = CGPointMake([(CCNode*)end_positions[lane] position].x+30,
                                      [(CCNode*)end_positions[lane] position].y);
    CGPoint selfPos = [[ self getSoldier ] position];
    
    // we move the truck position to make it stand on the lane,
    // so we need to change the position back to the original
    selfPos.y = selfPos.y - 25;

    CGPoint newStart = CGPointMake(selfPos.x - 20, [(CCNode*)start_positions[lane] position].y);
    
    int soldierType = arc4random_uniform(2);
    
    if( soldierType == 0 ){
        BurgerMan* enemy_soldier= [[BurgerMan alloc] initBurger:lane
                                                                startPos: selfPos
                                                                destPos: destination
                                                                ourArr:[self getOurArray]
                                                                enemyArr:[self getEnemeyArray]
                                                                level:2
                                                                bgNode:sb];
        CCAction *actionMove=[CCActionMoveTo actionWithDuration: 1
                                             position: newStart];
        [[enemy_soldier getSoldier] runAction:[CCActionSequence actionWithArray:@[actionMove]]];
        
        [enemy_soldier move];
    }
    if( soldierType == 1 ){
        CokeMan* enemy_soldier= [[CokeMan alloc] initCoke:lane
                                                       startPos: selfPos
                                                        destPos: destination
                                                         ourArr:[self getOurArray]
                                                       enemyArr:[self getEnemeyArray]
                                                          level:2
                                                         bgNode:sb];
        CCAction *actionMove=[CCActionMoveTo actionWithDuration: 1
                                                       position: newStart];
        [[enemy_soldier getSoldier] runAction:[CCActionSequence actionWithArray:@[actionMove]]];
        [enemy_soldier move];
    }
}

- (void)initAnimation{
    [self loadFirstAnimation:@"foodtruck"];
    [self loadWalkAnimation:@"foodtruck" frameNumber:3];
}

-(void)countDown{
    NSMutableArray *healthArray = [ self getArray:1 ];
    if ([self readyToLaunch]) {
        int range=[self getAtkRange];
        CGPoint target0 = CGPointMake(0, 0);
        CGPoint target1 = CGPointMake(0, 0);
        CGPoint target2 = CGPointMake(0, 0);

        float minDistance0 = range;
        float minDistance1 = range;
        float minDistance2 = range;

        for( Soldier *s in healthArray ){
            CGPoint enemy_pos = [s soldier].position;
            if( [ s getType ] == 4 ){
                // make the base reachable
                enemy_pos.x = enemy_pos.x + 40;
            }
            
            CGFloat xDist = (enemy_pos.x - [self soldier].position.x);
            CGFloat yDist = (enemy_pos.y - [self soldier].position.y);
            CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
            if ( [s soldier].position.x<[self soldier].position.x-20 ) {
                if( [s lane_num] == 0 && distance < minDistance0 ){
                    minDistance0 = distance;
                    target0 = enemy_pos;
                }
                if( ( [s lane_num] == 1 || [s lane_num] == -1 ) && distance < minDistance1 ){
                    minDistance1 = distance;
                    target1 = enemy_pos;
                }
                if( [s lane_num] == 2 && distance < minDistance2 ){
                    minDistance2 = distance;
                    target2 = enemy_pos;
                }
            }
        }
        
        if( target0.x != 0){
            [self Launch:target0];
        }
        if( target1.x != 0){
            [self Launch:target1];
        }
        if( target2.x != 0){
            [self Launch:target2];
        }
    }
}


@end

