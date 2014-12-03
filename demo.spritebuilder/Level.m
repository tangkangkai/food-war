//
//  Level.m
//  demo
//
//  Created by 丁硕青 on 10/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level

- (id)initLevel:(int) levelNum
                laneNum:(int) laneNum
                time:(int) time
                award:(int) award
                energy:(int) energy
                enemySequence:(NSMutableArray*) enemies{
    
    self = [super init];
    
    _levelNum = levelNum;
    _laneNum = laneNum;
    _award = award;
    _energy = energy;
    _time = time;
    _enemySequence = enemies;
    
    return self;
    
}

- (int)getLevel {
    
    return _levelNum;
}

- (int)getAward {
    return _award;
}

- (int)getEnergy {
    return _energy;
}

@end

static Level *level1;
static Level *level2;
static Level *level3;
static Level *Levelselected;


@implementation Levels : NSObject

+ (void) setSelectedLevel:(int) level{
    if(level == 1){
        Levelselected = level1;
    }
    if(level == 2){
        Levelselected = level2;
    }
    if(level == 3){
        Levelselected = level3;
    }
}

+ (Level*) getSelectedLevel{
    return Levelselected;
}

+ (void) initLevels{
    
    Levelselected = NULL;
    NSMutableArray *lvlOneSeq = [ [NSMutableArray alloc] init ];
    // codes for enemies 1: burger 2: coke 3:fries
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@5,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@1] } ];
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@8,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@2] } ];
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@8,
                                            @"lane":@2,
                                            @"items":@[@2],
                                            @"enemyLev":@1,
                                            @"enemies":@[] } ];
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@15,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@2] } ];
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@20,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@1] } ];
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@30,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@3] } ];
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@50,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@1,@2] } ];
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@15,
                                            @"lane":@2,
                                            @"items":@[@2],
                                            @"enemyLev":@1} ];
    [lvlOneSeq addObject:(NSDictionary*) @{ @"time":@18,
                                            @"lane":@2,
                                            @"items":@[@1],
                                            @"enemyLev":@1} ];
    level1 = [ [Level alloc] initLevel:1
                              laneNum:1
                              time:200
                              award:1000
                              energy: 2000
                              enemySequence:lvlOneSeq ];
    
    
    NSMutableArray *lvlTwoSeq = [ [NSMutableArray alloc] init ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@5,
                                            @"lane":@1,
                                            @"enemyLev":@2,
                                            @"enemies":@[@1] } ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@5,
                                            @"lane":@2,
                                            @"enemyLev":@2,
                                            @"enemies":@[@2] } ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@5,
                                            @"lane":@1,
                                            @"enemyLev":@2,
                                            @"enemies":@[@2] } ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@15,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@3] } ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@20,
                                            @"lane":@2,
                                            @"enemies":@[@1] } ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@50,
                                            @"lane":@1,
                                            @"enemies":@[@1,@2] } ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@80,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@3] } ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@100,
                                            @"lane":@2,
                                            @"enemyLev":@1,
                                            @"enemies":@[@1,@2] } ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@5,
                                            @"lane":@2,
                                            @"items":@[@2],
                                            @"enemyLev":@1} ];
    [lvlTwoSeq addObject:(NSDictionary*) @{ @"time":@14,
                                            @"lane":@2,
                                            @"items":@[@1],
                                            @"enemyLev":@1} ];
    level2 = [ [Level alloc] initLevel:2
                                laneNum:2
                                   time:200
                                  award:2000
                                energy:2500
                          enemySequence:lvlTwoSeq ];
    
    NSMutableArray *lvlThreeSeq = [ [NSMutableArray alloc] init ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@1,
                                              @"lane":@2,
                                              @"enemyLev":@1,
                                              @"enemies":@[@4] } ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@25,
                                              @"lane":@1,
                                              @"enemyLev":@2,
                                              @"enemies":@[@1] } ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@25,
                                              @"lane":@2,
                                              @"enemyLev":@1,
                                              @"enemies":@[@2] } ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@25,
                                              @"lane":@3,
                                              @"enemyLev":@3,
                                              @"enemies":@[@2] } ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@50,
                                              @"lane":@2,
                                              @"enemyLev":@2,
                                              @"enemies":@[@1,@3] } ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@60,
                                              @"lane":@2,
                                              @"enemyLev":@3,
                                              @"enemies":@[@1,@2] } ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@70,
                                              @"lane":@1,
                                              @"enemyLev":@2,
                                              @"enemies":@[@3] } ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@80,
                                              @"lane":@2,
                                              @"enemyLev":@2,
                                              @"enemies":@[@1,@2,@3] } ];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@6,
                                              @"lane":@2,
                                              @"enemyLev":@2,
                                              @"items":@[@1]}];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@16,
                                              @"lane":@2,
                                              @"enemyLev":@2,
                                              @"items":@[@2]}];
    [lvlThreeSeq addObject:(NSDictionary*) @{ @"time":@20,
                                              @"lane":@2,
                                              @"enemyLev":@2,
                                              @"items":@[@1]}];

    
    level3 = [ [Level alloc] initLevel:3
                               laneNum:3
                                  time:200
                                 award:2000
                                energy:3000
                         enemySequence:lvlThreeSeq ];
}

@end