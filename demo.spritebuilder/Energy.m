//
//  Energy.m
//  demo
//
//  Created by dqlkx on 11/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Energy.h"
#import "Gameplay.h"


@implementation Energy{
    CGPoint _arrivePosition;
}



-(id)initEnergy:(int) value pos:(CGPoint) position bgNode:(CCNode*)bgNode
{
    _deadBody=[CCBReader load:@"energy"];
    position.y=position.y-10;
    _deadBody.position=position;
    [bgNode addChild:_deadBody];
    _engergyValue=value;
    [self schedule:@selector(arrive) interval:0.1f];
    return self;
}

-(CCNode*)getDeadBody{
    return _deadBody;
}

-(void) collect:(CCNode*)Icon Gameplay:(CCScrollView*)c{
    _arrivePosition=CGPointMake(Icon.position.x+[c scrollPosition].x, Icon.position.y);
   // CCActionMoveTo *collectEnergy = [CCActionMoveTo actionWithDuration:1.0f position:_arrivePosition];
    CCActionRotateBy *actionRotate = [CCActionRotateBy actionWithDuration: 0.5f angle:360];
    CCActionJumpTo* jumpUp = [CCActionJumpTo actionWithDuration:1.0f position:_arrivePosition height:40 jumps:2];
    CCActionSpawn *groupAction = [CCActionSpawn actionWithArray:@[jumpUp,actionRotate]];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[groupAction, [CCActionCallFunc actionWithTarget:self selector:@selector(arrive)]]];
    [_deadBody runAction:sequence];
}

-(void) arrive{
        [self unschedule:@selector(arrive)];
        [_deadBody removeFromParent];
        [Gameplay addEnergy:[self engergyValue]];
}
@end