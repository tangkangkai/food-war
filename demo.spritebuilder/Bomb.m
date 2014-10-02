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

@end