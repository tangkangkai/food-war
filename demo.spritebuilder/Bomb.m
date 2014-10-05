#import <Foundation/Foundation.h>
#import "Bomb.h"
@implementation Bomb {
    CCNode* _soldier;
    
}

- (id)init
{
    self = [super init];
    return self;
}

-(void)drop: (CGPoint) pos {
    int distance = ABS(pos.x - self.soldier.position.x);
    int duration = distance/self.move_speed;
    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration position:CGPointMake(pos.x,[_soldier position].y)];
    CCAction *actionRemove = [CCActionRemove action];
    [self.soldier runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

-(void)move: (CGPoint) pos {
    int distance = ABS(pos.y - self.soldier.position.y);
    int duration = distance/self.move_speed;
    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration position:CGPointMake(pos.x,[_soldier position].y)];
//    CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration position:CGPointMake(self.soldier.position.x,pos.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [self.soldier runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}


@end