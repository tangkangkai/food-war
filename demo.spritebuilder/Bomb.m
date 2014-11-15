#import <Foundation/Foundation.h>
#import "Bomb.h"
#import <CoreMotion/CoreMotion.h>
#import "Scrollback.h"
#import "SavedData.h"
@implementation Bomb {
    float accelator;
    int counter;
    CCNode *bombRing;
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

-(id) initBomb:(NSString *)img animation:(CCSprite *)ani startPosition:(CGPoint)start endPosition:(CGPoint)end enemyArr:(NSMutableArray *)enemyArray{
    self = [super initItem:img animation:ani startPosition:start endPosition:end enemyArr:enemyArray];
    accelator = 0;
    self.power = 90;

    return self;
}


- (void)update{
    if(accelator > 3) {

        CCParticleSystem *fire = (CCParticleSystem *)[CCBReader load:@"fire"];
        fire.autoRemoveOnFinish = YES;
        fire.position = self.destPosi;
        CCNode *parent = [self.item parent];
        [parent addChild:fire];
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        if ([SavedData audio]) {
            [audio playEffect:@"explode.mp3"];
        }
        
        
        NSMutableArray *targets = [NSMutableArray arrayWithObjects:nil ];
        for(int i = 0; i < self.enemies.count; i++){
            Soldier *s = [self.enemies objectAtIndex:i];
            float dx = ABS([s getSoldier].position.x - self.item.position.x);
            float dy = ABS([s getSoldier].position.y - self.item.position.y);
            double dist = sqrt(dx*dx + dy*dy);
            if(dist < 100){
                [targets addObject:[self.enemies objectAtIndex:i]];
            }
        }
        long num = [targets count];
        for(int i = 0; i < num; i++){
            Soldier *s = [targets objectAtIndex:i];
            [s loseHealth:self.power];
        }
        [self unschedule:@selector(update)];
        [self.item removeFromParent];
        return;
    }
    CGPoint posi = CGPointMake(self.item.position.x, self.item.position.y - accelator);
    self.item.position = posi;
    accelator += 0.05;
    
}


@end