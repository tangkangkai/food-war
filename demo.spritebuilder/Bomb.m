#import <Foundation/Foundation.h>
#import "Bomb.h"
#import <CoreMotion/CoreMotion.h>
@implementation Bomb {
    float accelator;
    int counter;
}

/*
 - (id)init
 {
 self = [super init];
 _moveSpeed = 80;
 
 return self;
 }*/

-(void)drop: (CGPoint)start{
    NSLog(@"Bomb start dropping");
    //    [_motionManager startAccelerometerUpdates];
    [self schedule:@selector(update) interval:0.005f];
    /*
     CCAction *actionMove=[CCActionMoveTo actionWithDuration: duration
     position:_destPosi];*/
    //    [_bomb runAction:[CCActionSequence actionWithArray:@[actionMove]]];
    
}


-(id)initBomb:(NSString*) img startPosition:(CGPoint) start endPosition:(CGPoint) end{
    self = [super init];
    
    start.y -= 30;
    end.y -= 80;
    _bomb = [CCBReader load:img];
    _startPosi = start;
    _destPosi = end;
    _bomb.position = start;         //init CCNode;
    _bomb.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _bomb.contentSize} cornerRadius:0];
    
    accelator = 0;
    //    _motionManager = [[CMMotionManager alloc] init];
    return self;
}

- (void)update{
    if(accelator > 3) {
        /*
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explode"];
        explosion.autoRemoveOnFinish = YES;
        CGPoint expo = CGPointMake(_bomb.position.x, _bomb.position.y);
        explosion.position = expo;*/
        
        [_bomb removeFromParent];
//        [self addChild:explosion];
        return;
    }
    CGPoint posi = CGPointMake(_bomb.position.x, _bomb.position.y - accelator);
    _bomb.position = posi;
    accelator += 0.05;
    
    
    /*
     CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
     CMAcceleration acceleration = accelerometerData.acceleration;
     CGFloat newXPosition = _bomb.position.x + acceleration.y * 1000 * delta;
     newXPosition = clampf(newXPosition, 0, self.contentSize.width);
     _bomb.position = CGPointMake(newXPosition, _bomb.position.y);*/
}


@end