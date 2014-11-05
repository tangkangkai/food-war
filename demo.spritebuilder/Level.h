//
//  Level.h
//  demo
//
//  Created by 丁硕青 on 10/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property int levelNum;
@property int laneNum;
@property int time;
@property int award;
@property int energy;
@property NSMutableArray *enemySequence;


- (id)initLevel:(int) levelNum
            laneNum:(int) laneNum
            time:(int) time
            award:(int) award
            energy:(int) energy
            enemySequence:(NSMutableArray*) enemies;
- (int)getLevel;
- (int)getAward;

@end


@interface Levels : NSObject
+ (void) initLevels;
+ (Level*) getSelectedLevel;
+ (void) setSelectedLevel:(int) level;
@end
