#import <Foundation/Foundation.h>
#import "Bomb.h"
#import <CoreMotion/CoreMotion.h>
#import "Scrollback.h"
#import "SavedData.h"
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


-(id)initBomb:(NSString*) img animation:(CCSprite*) ani startPosition:(CGPoint) start endPosition:(CGPoint) end               enemyArr:(NSMutableArray*) enemyArray;
{
    self = [super init];
    
    start.y -= 30;
    end.y -= 80;
//    _bomb = [CCBReader load:img];
    _bomb = ani;
    _startPosi = start;
    _destPosi = end;
    _bomb.position = start;         //init CCNode;
    _bomb.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _bomb.contentSize} cornerRadius:0];
    _enemies = enemyArray;
    accelator = 0;
    _power= 90 ;
    //    _motionManager = [[CMMotionManager alloc] init];
    

    return self;
}

- (void)update{
    if(accelator > 3) {

        CCParticleSystem *fire = (CCParticleSystem *)[CCBReader load:@"fire"];
        fire.autoRemoveOnFinish = YES;
        fire.position = _destPosi;
        CCNode *parent = [_bomb parent];
        [parent addChild:fire];
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        if ([SavedData audio]) {
            [audio playEffect:@"explode.mp3"];
        }
        
        
        NSMutableArray *targets = [NSMutableArray arrayWithObjects:nil ];
        for(int i = 0; i < _enemies.count; i++){
            Soldier *s = [_enemies objectAtIndex:i];
            float dx = ABS([s getSoldier].position.x - _bomb.position.x);
            float dy = ABS([s getSoldier].position.y - _bomb.position.y);
            double dist = sqrt(dx*dx + dy*dy);
            if(dist < 100){
                [targets addObject:[_enemies objectAtIndex:i]];
            }
        }
        long num = [targets count];
        for(int i = 0; i < num; i++){
            Soldier *s = [targets objectAtIndex:i];
            [s loseHealth:_power];
        }
        [self unschedule:@selector(update)];
        [_bomb removeFromParent];
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
-(int) getPower{
    return _power;
}


@end