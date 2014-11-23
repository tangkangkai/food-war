//
//  IceBucket.m
//  demo
//
//  Created by Yaning Wu on 11/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IceBucket.h"
#import "Soldier.h"
#import "SavedData.h"
@implementation IceBucket{
    float accelator;
    
}



-(id) initIceBucket:(NSString *)img animation:(CCNode *)ani startPosition:(CGPoint)start endPosition:(CGPoint)end enemyArr:(NSMutableArray *)enemyArray flyingItemsArray: flyingItemsArr{
    self = [super initItem:img animation:ani startPosition:start endPosition:end enemyArr:enemyArray flyingItemsArray:flyingItemsArr];
    accelator = 0;
    return self;
}

-(void)dropBucket{
    [self schedule:@selector(updateBucket) interval:0.005f];
}

-(void)updateBucket{
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
        [self unschedule:@selector(updateBucket)];
        [self.item removeFromParent];
        return;
    }
    
    CGPoint posi = CGPointMake(self.item.position.x, self.item.position.y - accelator);
    self.item.position = posi;
    accelator += 0.05;
}



@end
