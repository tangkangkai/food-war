//
//  Scrollback.m
//  demo
//
//  Created by dqlkx on 9/29/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Scrollback.h"
#import "Soldier.h"

@implementation Scrollback{
    CCNode *_missile;
    int _startlaunch;
    Soldier *s;
    OALSimpleAudio *audio;
    int nearest_distance;
}

- (id)init{
    self = [super init];
    if (!self) return(nil);

    _junk_soldiers = [NSMutableArray arrayWithObjects:nil ];
    _healthy_soldiers = [NSMutableArray arrayWithObjects:nil ];
    _target = [NSMutableArray arrayWithObjects:nil ];
    audio = [OALSimpleAudio sharedInstance];
    return self;
}

- (void)didLoadFromCCB {
    _healthBase = [[Base alloc] initBase:_base1.position group:0 ourArr:_healthy_soldiers enemyArr:_junk_soldiers];
    _junkBase = [[Base alloc] initBase:_base2.position group:1 ourArr:_junk_soldiers enemyArr:_healthy_soldiers];
    [self addChild:[_healthBase soldier]];
    [self addChild:[_junkBase soldier]];
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    nearest_distance=40;
    [self schedule:@selector(enemy_autobuild:) interval:6];
}


//find target the missle hit
-(NSMutableArray*)missileDetect{
  //  int nearest_distance=[self missile_atk_range];
    Soldier *soldier = NULL;
    int x_diff;
    int y_diff;
    long junkarraysize = _junk_soldiers.count;
    for( long i = 0; i < junkarraysize; i++ ){
        soldier=[_junk_soldiers objectAtIndex:i];
        x_diff=ABS(_missile.position.x-[[soldier soldier]position].x);
        y_diff=ABS(_missile.position.y-[[soldier soldier] position].y);
        if (x_diff<nearest_distance&&y_diff<nearest_distance) {
       //     _target=[_junk_soldiers objectAtIndex:i];
            [_target addObject:[_junk_soldiers objectAtIndex:i]];
        }
    }
    return _target;

}

//missle lauch from healthyfoor
-(void)missileLaunch:(CCNode *)missile :(CGPoint ) touchLocation{
    CCParticleSystem *fire = (CCParticleSystem *)[CCBReader load:@"fire"];
    fire.autoRemoveOnFinish=true;
    fire.duration=0.2;
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:1.0f angle:90.f];
    CCActionJumpTo* jumpUp = [CCActionJumpTo actionWithDuration:1.0f position:touchLocation
                                                         height:80 jumps:1];
    CCActionSpawn *groupAction = [CCActionSpawn actionWithArray:@[rotate, jumpUp]];
  
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[groupAction, [CCActionCallFunc actionWithTarget:self selector:@selector(missileRemoved)]]];
    // allDone is your method to run...
    fire.position=_missile.position;
    [self addChild:fire];
    [audio playEffect:@"missle_launch.mp3"];
    [missile runAction:sequence];

}

//the effect when the missile hit the target

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
        [target loseHealth:_missile_atk];
    }
    // finally, remove the destroyed seal
    [_missile removeFromParent];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"Scrollback touch began");
    CGPoint touchLocation = [touch locationInNode:self];
    long healtharraysize = _healthy_soldiers.count;
    CGFloat xDist = (touchLocation.x - _missile.position.x);
    CGFloat yDist = (touchLocation.y - _missile.position.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    if (_startlaunch==1) {
        if (CGRectContainsPoint([[s soldier] boundingBox],touchLocation)) {
            _startlaunch=0;
            [(CornMan*)s undoReady];
        //    [self removeChild:_missile];
            return;
        }
        
        if(distance>_missile_atk_range){
            return;
        }
        if (touchLocation.x<_missile.position.x+40) {
            return;
        }
        else{
            [self addChild:_missile];
            [self missileLaunch:_missile :touchLocation];
            [(CornMan*)s Launch];
            _startlaunch=0;
            return;
        }
    }
    
    for( long i = 0; i < healtharraysize; i++ ){
        Boolean touch=CGRectContainsPoint([[[_healthy_soldiers objectAtIndex:i] soldier] boundingBox],touchLocation);
        s=[_healthy_soldiers objectAtIndex:i];
        int type=[s getType];

        if(type==3&&touch==true){
            _missile_atk_range=[s getAtkRange];
            _missile_atk=[s getAtkPower];
            
            if([(CornMan*)s readyToLaunch]){
                NSLog(@"touch healthy food");
                _missile = [CCBReader load:@"missle"];
                _missile.position=[[_healthy_soldiers objectAtIndex:i] soldier].position;

               // [self addChild:_missile];
                _startlaunch=1;
                break;
            }
        }
    }
}




-(void)enemy_autobuild:(CCTime)dt{
    //TODO change to dictionary
    NSArray *start_positions = @[_house4,_house5,_house6];
    NSArray *end_positions=@[_house1,_house2,_house3];

    int soldier_type = arc4random()%2;
    int lane_num = arc4random()%3;
    
    CGPoint destination = CGPointMake([(CCNode*)end_positions[lane_num] position].x+30,
                                      [(CCNode*)end_positions[lane_num] position].y);
    
    if( soldier_type == 0 ){
        BurgerMan* enemy_soldier= [[BurgerMan alloc] initBurger:
                                             lane_num
                                             startPos:[(CCNode*)start_positions[lane_num] position]
                                             destPos:destination
                                             ourArr:_junk_soldiers
                                             enemyArr:_healthy_soldiers
                                             level:1];
        [ self addChild: [enemy_soldier soldier]];
        [enemy_soldier move];
    }
    if( soldier_type == 1 ){
        CokeMan* enemy_soldier= [[CokeMan alloc] initCoke: lane_num
                                                       startPos:[(CCNode*)start_positions[lane_num] position]
                                                        destPos:destination
                                                         ourArr:_junk_soldiers
                                                       enemyArr:_healthy_soldiers
                                                       level:1];
        [ self addChild: [enemy_soldier soldier]];
        [enemy_soldier move];
    }
}

- (void)bombExplode:(CGPoint)location{
    CCParticleSystem *fire = (CCParticleSystem *)[CCBReader load:@"fire"];
    fire.autoRemoveOnFinish = YES;
    fire.position = location;
    [self addChild:fire];
}

- (void)trackInvist {
    _track1.visible = false;
    _track2.visible = false;
    _track3.visible = false;
}

@end
