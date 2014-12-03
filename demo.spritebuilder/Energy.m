//
//  Energy.m
//  demo
//
//  Created by dqlkx on 11/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Energy.h"
#import "Gameplay.h"
#import "Scrollback.h"


@implementation Energy{
    CGPoint _arrivePosition;
    NSDate *last_attack_time;
    NSDate *flash_time;
    CCSprite *img;

}

-(id)initEnergy:(int) value pos:(CGPoint) position bgNode:(CCNode*)bgNode
{
    self = [super init];

    _deadBody=[CCBReader load:@"energy"];
    img=[_deadBody children][0];
    position.y=position.y-30;
    _deadBody.position=position;
    [bgNode addChild:_deadBody];
    _engergyValue=value;
    _touch=0;
    last_attack_time = [NSDate date];
    [self schedule:@selector(disappear) interval:0.1];
    return self;
}

-(CCNode*)getDeadBody{
    return _deadBody;
}

-(void) collect:(CCNode*)Icon Gameplay:(CCScrollView*)c{
    _arrivePosition=CGPointMake(Icon.position.x+[c scrollPosition].x, Icon.position.y);
    CCActionRotateBy *actionRotate = [CCActionRotateBy actionWithDuration: 0.5f angle:360];
    CCActionJumpTo* jumpUp = [CCActionJumpTo actionWithDuration:1.0f position:_arrivePosition height:40 jumps:2];
    CCActionSpawn *groupAction = [CCActionSpawn actionWithArray:@[jumpUp,actionRotate]];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[groupAction, [CCActionCallFunc actionWithTarget:self selector:@selector(arrive)]]];
    [_deadBody runAction:sequence];
    OALSimpleAudio *energyAudio = [OALSimpleAudio sharedInstance];
    [energyAudio playEffect:@"bubble.mp3"];
}

-(void) arrive{
        [_deadBody removeFromParent];
        [Gameplay addEnergy:[self engergyValue]];
}

-(void) disappear{
    if( [ last_attack_time timeIntervalSinceNow ]*-1 >= 5 ){
        flash_time=[NSDate date];
        [self unschedule:@selector(disappear)];
        [self schedule:@selector(flash) interval:0.1];
    }
}

-(void) flash{
    if (_touch==1) {
        [self children];
        img.opacity=1;
        [self unschedule:@selector(flash)];
        return;
    }
    if ([ flash_time timeIntervalSinceNow ]*-1 >= 5) {
        [self unschedule:@selector(flash)];
        [_deadBody removeFromParent];
    }
    img.opacity = img.opacity+0.1;
    if(img.opacity > 1 ){
        img.opacity = img.opacity-1;
    }
}

-(void) setTouch{
    _touch=1;
}

@end