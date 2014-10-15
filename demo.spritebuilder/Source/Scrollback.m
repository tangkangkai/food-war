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
    int _startlaunch;
    Soldier *s;
    OALSimpleAudio *audio;
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
    [self schedule:@selector(enemy_autobuild:) interval:6];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"Scrollback touch began");
    CGPoint touchLocation = [touch locationInNode:self];
    long healtharraysize = _healthy_soldiers.count;

    if (_startlaunch==1) {
        if (CGRectContainsPoint([[s soldier] boundingBox],touchLocation)) {
            _startlaunch=0;
            [(CornMan*)s undoReady];
            return;
        }
        CGFloat xDist = (touchLocation.x - [s getSoldier].position.x);
        CGFloat yDist = (touchLocation.y - [s getSoldier].position.y);
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
        if( distance > _missile_atk_range  ||  touchLocation.x < [s getSoldier].position.x+40 ){
            return;
        }
        else{
            [(CornMan*)s Launch:touchLocation];
            _startlaunch=0;
            return;
        }
    }
    
    for( long i = 0; i < healtharraysize; i++ ){
        Boolean touch=CGRectContainsPoint([[[_healthy_soldiers objectAtIndex:i] soldier] boundingBox],touchLocation);
        s=[_healthy_soldiers objectAtIndex:i];
        int type=[s getType];

        if(type==3&&touch==true){
            if([(CornMan*)s readyToLaunch]){
                _missile_atk_range = [s getAtkRange];
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
    CGPoint location2 = CGPointMake(location.x, location.y-100);
    fire.position = location;
    [self addChild:fire];
}

- (void)showTrack: (int) num {
    _track1.visible = false;
    _track2.visible = false;
    _track3.visible = false;

    if( num == 1 )
        _track1.visible = true;
    if( num == 2 )
        _track2.visible = true;
    if( num == 3 )
        _track3.visible = true;
}

@end
