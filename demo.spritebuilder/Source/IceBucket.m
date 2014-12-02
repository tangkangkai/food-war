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
    CCSprite* snow;
    NSMutableArray *snowArray;
    NSMutableArray *frozenEnemies;

}



-(id) initIceBucket:(NSString *)img animation:(CCNode *)ani startPosition:(CGPoint)start endPosition:(CGPoint)end enemyArr:(NSMutableArray *)enemyArray flyingItemsArray: flyingItemsArr{
    self = [super initItem:img animation:ani startPosition:start endPosition:end enemyArr:enemyArray flyingItemsArray:flyingItemsArr];
    accelator = 0;
    snowArray = [[NSMutableArray alloc] init];
    frozenEnemies = [[NSMutableArray alloc] init];

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
            [audio playEffect:@"bucketSpl.mp3"];
            [audio playEffect:@"waterSpl.mp3"];
        }
        
        
        //NSMutableArray *targets = [NSMutableArray arrayWithObjects:nil ];
        for(Soldier *s in self.enemies){
            if( [s getType] == 4 || [s getType] == 5 ){
                continue;
            }
            float dx = ABS([s getSoldier].position.x - self.item.position.x);
            float dy = ABS([s getSoldier].position.y - self.item.position.y);
            double dist = sqrt(dx*dx + dy*dy);
            if(dist < 100){
//              [targets addObject:[self.enemies objectAtIndex:i]];
                CCSpriteFrame* snowFrame = [CCSpriteFrame frameWithImageNamed:@"snowEffect.png"];
                snow = [CCSprite spriteWithSpriteFrame:snowFrame];
                snow.position = CGPointMake([s getSoldier].position.x, [s getSoldier].position.y);
                CCNode *parent = [self.item parent];
                [snow setZOrder:3000];
                [parent addChild:snow];
                [snowArray addObject:snow];
                [ s freeze ];
                [frozenEnemies addObject:s];
            }
        }
        [self schedule:@selector(removeSnow) interval:4];

        /*
        long num = [targets count];
        for(int i = 0; i < num; i++){
            Soldier *s = [targets objectAtIndex:i];
            [s loseHealth:self.power];
        }
        */
        [self unschedule:@selector(updateBucket)];
        [self.item removeFromParent];
        return;
    }
    
    CGPoint posi = CGPointMake(self.item.position.x, self.item.position.y - accelator);
    self.item.position = posi;
    accelator += 0.05;
}

-(void) addSnow{
    /*
    CCSpriteFrame* snowFrame = [CCSpriteFrame frameWithImageNamed:@"snowEffect.png"];
    snow = [CCSprite spriteWithSpriteFrame:snowFrame];
    snow.position = CGPointMake(touchLocation.x, touchLocation.y - 90);
    [self addChild:snow];*/
}

-(void) removeSnow{
//    [snow removeFromParent];
    NSLog(@"removing snow");
    while([snowArray count] != 0){
        NSLog(@"Enter While loop");
        CCSprite* tmpsnow = [snowArray objectAtIndex:0];
        [tmpsnow removeFromParent];
        [snowArray removeObjectAtIndex:0];
    }
    
    for(Soldier *s in frozenEnemies){
        [s unfreeze];
    }
    /*
    for(int i = 0; i < [snowArray count]; i++){
        snow = [snowArray objectAtIndex:i];
        [snow removeFromParent];
    }*/
    [self unschedule:@selector(removeSnow)];
}


@end
