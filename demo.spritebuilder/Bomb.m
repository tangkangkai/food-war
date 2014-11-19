#import <Foundation/Foundation.h>
#import "Bomb.h"
#import <CoreMotion/CoreMotion.h>
#import "Scrollback.h"
#import "SavedData.h"
@implementation Bomb {
    float accelator;
    int counter;
    CCNode *bombRing;
    
    float V0x;           //variables used for flying
    float V0y;
    float Vtx;
    float S;
    float a;
    float t;
    BOOL reverseFlag;
    float timeInterval;
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
    
    timeInterval = 0.01f;
    
    t = 0;
    V0y = 20;
    V0x = 300;
    
    Vtx = V0x;
    S = 200;
    a = V0x * V0x / (2*S);
    
    reverseFlag = NO;
    
    return self;
}

/*
-(void)fly: (CGPoint)start{
    NSLog(@"Bomb start flying");
    [self schedule:@selector(hover) interval:timeInterval];
    
}

-(void)hover{
    float yt = self.item.position.y - V0y * timeInterval;
    float xt;
    
    Vtx = Vtx - a * timeInterval;
    if(Vtx < 0) {
        reverseFlag = !reverseFlag;
        Vtx = V0x;
    }
    
    float deltaS = (2 * Vtx + a * timeInterval) * timeInterval / 2;          // deltaS = (Vt1 + Vt2) * (Vt1-Vt2) / 2a
    NSLog(@"Vtx: %f", Vtx);
    
    if(reverseFlag == NO){
        xt = self.item.position.x + deltaS;
    } else {
        xt = self.item.position.x - deltaS;
    }
    
    self.item.position = CGPointMake(xt, yt);
    if(yt < 0){
        [self.item removeFromParent];
    }
}
*/

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