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
    long _healtharraysize;
    long _junkarraysize;
    int _startlaunch;

    int j;
}

- (id)init{
    self = [super init];
    if (!self) return(nil);

    _missile_atk=20;
    _missile_atk_range=10;
    _junk_soldiers = [NSMutableArray arrayWithObjects:nil ];
    _healthy_soldiers = [NSMutableArray arrayWithObjects:nil ];
    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self schedule:@selector(enemy_autobuild:) interval:3];
    [self schedule:@selector(sceneDetect) interval:0.2];
}

//find whether enemy come out
-(void)sceneDetect{
    _healtharraysize = [_healthy_soldiers count];
    _junkarraysize = [_junk_soldiers count];
    if (_junkarraysize!=0) {
        for(long i = 0; i < _healtharraysize; i++ ){
            //    NSLog(@"x:%f, y:%f ",s.position.x,s.position.y);
            if (j==2) {
                break;
            }
            [[[_healthy_soldiers objectAtIndex:i] soldier] stopAllActions];
            j++;


        }
    }

}

//find target the missle hit
-(Soldier*)missileDetect{
    int nearest_distance=[self missile_atk_range];
    Soldier *target = NULL;
    int x_diff;
    int y_diff;

    for( long i = 0; i < _junkarraysize; i++ ){
        x_diff=ABS(_missile.position.x-[[[_junk_soldiers objectAtIndex:i] soldier] position].x);
        y_diff=ABS(_missile.position.y-[[[_junk_soldiers objectAtIndex:i] soldier] position].y);
        if (x_diff<nearest_distance||y_diff<nearest_distance) {
            target=[_junk_soldiers objectAtIndex:i];
        }
    }
    return target;

}

//missle lauch from healthyfoor
-(void)missileLaunch:(CCNode *)missile :(CGPoint ) touchLocation{
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:1.0f angle:90.f];
    CCActionJumpTo* jumpUp = [CCActionJumpTo actionWithDuration:1.0f position:touchLocation
                                                         height:touchLocation.y jumps:1];
    CCActionSpawn *groupAction = [CCActionSpawn actionWithArray:@[rotate, jumpUp]];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[groupAction, [CCActionCallFunc actionWithTarget:self selector:@selector(missileRemoved)]]];
    // allDone is your method to run...
    [missile runAction:sequence];

}

//the effect when the missile hit the target

- (void)missileRemoved
{
    Soldier *target;
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explosion"];
    //  make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    
    explosion.duration = 5;
    
    // place the particle effect on the seals position
    explosion.position = _missile.position;
    // add the particle effect to the same node the seal is on
    [_missile.parent addChild:explosion];
    
    target=[self missileDetect];
    [target loseHealth:_missile_atk];
    // finally, remove the destroyed seal
    [_missile removeFromParent];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"Scrollback touch began");
    CGPoint touchLocation = [touch locationInNode:self];
    if (_startlaunch==1) {
        [self missileLaunch:_missile :touchLocation];
    }
    for( long i = 0; i < _healtharraysize; i++ ){
        if(CGRectContainsPoint([[[_healthy_soldiers objectAtIndex:i] soldier] boundingBox],touchLocation))
        {
            NSLog(@"touch healthy food");
            _missile = [CCBReader load:@"missle"];
            _missile.position=[[_healthy_soldiers objectAtIndex:i] soldier].position;
            [self addChild:_missile];
            _startlaunch=1;
        }    
    }
}


-(void)enemy_autobuild:(CCTime)dt{

    //TODO change to dictionary
    NSArray *start_positions = @[_house4,_house5,_house6];
    NSArray *end_positions=@[_house1,_house2,_house3];

    int soldier_type = arc4random()%3;
    int lane_num = arc4random()%3;
    
    CGPoint destination = CGPointMake([(CCNode*)end_positions[lane_num] position].x+50,
                                      [(CCNode*)end_positions[lane_num] position].y);
    
    if( soldier_type == 0 ){
        BurgerMan* enemy_soldier= [[BurgerMan alloc] initBurger:
                                             lane_num
                                             startPos:[(CCNode*)start_positions[lane_num] position]
                                             destPos:destination
                                             ourArr:_junk_soldiers
                                             enemyArr:_healthy_soldiers];
        [ self addChild: [enemy_soldier soldier]];
        [enemy_soldier move];
    }
    if( soldier_type == 1 ){
        CokeMan* enemy_soldier= [[CokeMan alloc] initCoke: lane_num
                                                       startPos:[(CCNode*)start_positions[lane_num] position]
                                                        destPos:destination
                                                         ourArr:_junk_soldiers
                                                       enemyArr:_healthy_soldiers];
        [ self addChild: [enemy_soldier soldier]];
        [enemy_soldier move];
    }

}



- (void)trackInvist {
    _track1.visible = false;
    _track2.visible = false;
    _track3.visible = false;
}

@end
