//
//  Scrollback.m
//  demo
//
//  Created by dqlkx on 9/29/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Scrollback.h"
#import "Soldier.h"
#import "Level.h"
#import "CCAnimation.h"
#import <UIKit/UIKit.h>
#include <CCDirector.h>
#import "CCAction.h"
#import "Energy.h"
#import "Gameplay.h"
#import "Item.h"




static NSMutableArray *energyArray;

const int BOMB = 1;
const int ICEBUCKET = 2;

@implementation Scrollback{

    int _startlaunch;
    int time;
    Soldier *s;
    Soldier *health_s;
    OALSimpleAudio *audio;
}

- (id)init{
    self = [super init];
    if (!self) return(nil);

    time = 0;
    _junk_soldiers = [NSMutableArray arrayWithObjects:nil ];
    _healthy_soldiers = [NSMutableArray arrayWithObjects:nil ];
    _target = [NSMutableArray arrayWithObjects:nil ];
    energyArray = [NSMutableArray arrayWithObjects:nil ];
    audio = [OALSimpleAudio sharedInstance];
    return self;
}

- (void)didLoadFromCCB {
    _healthBase = [[Base alloc] initBase:_base1.position group:0 ourArr:_healthy_soldiers enemyArr:_junk_soldiers bgNode:self];
    _junkBase = [[Base alloc] initBase:_base2.position group:1 ourArr:_junk_soldiers enemyArr:_healthy_soldiers bgNode:self];
    
    int laneNum = [[Levels getSelectedLevel] laneNum];
    if( laneNum == 1){
        [_lane1 setVisible:false];
        [_lane3 setVisible:false];
    }
    if( laneNum == 2){
        [_lane3 setVisible:false];
    }
    
    [self showTrack:0];
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self schedule:@selector(enemy_autobuild:) interval:1];
}

- (void)cleanup{
    [_junk_soldiers removeAllObjects];
    [_healthy_soldiers removeAllObjects];
    [self unschedule:@selector(enemy_autobuild)];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:self];
    long healtharraysize = _healthy_soldiers.count;
    CGFloat x=0;
    CGFloat y=0;

    if (energyArray!=nil) {
        for (Energy* en in energyArray) {
            if (CGRectContainsPoint([[en deadBody] boundingBox],touchLocation)) {
                [en setTouch];
                CCScrollView *c = (CCScrollView*)[self parent];
                Gameplay* cc = (Gameplay*)[c parent];
                CCNode* Icon=[cc energyIcon];
                [en collect:Icon Gameplay:c];
            }
        }
    }

    
    for(int i = 0; i < [[Gameplay getItArray] count]; i++){
        Item* tmp = [[Gameplay getItArray] objectAtIndex:i];
        
        if(CGRectContainsPoint([[tmp item] boundingBox],touchLocation)){
            CCScrollView* ccs = (CCScrollView*)[self parent];
            Gameplay* g = (Gameplay*)[ccs parent];
            if(tmp.itemType == 1){
                [g addItem:BOMB];
                [g showMessage:@"Bomb Obtained"];
                
            } else {
                [g addItem:ICEBUCKET];
                [g showMessage:@"IceBucket Obtained"];
                
            }
            [tmp disappear];
        }
    }
    
    if (_startlaunch==1) {
        if (CGRectContainsPoint([[s soldier] boundingBox],touchLocation)) {
            _startlaunch=0;
            [(CornMan*)s undoReady];
            return;
        }
        CGFloat xDist = (touchLocation.x - [s getSoldier].position.x);
        CGFloat yDist = (touchLocation.y - [s getSoldier].position.y);
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
        if( distance > _missile_atk_range  ||  touchLocation.x < [s getSoldier].position.x+40 ){
            return;
        }
        else{
            _startlaunch=0;
            x=[[s soldier] position ].x;
            y=[[s soldier] position ].y;
            [(CornMan*)s Launch:touchLocation];
            [(CornMan*)s cornLuanchshock];
            return;
        }
    }
    for(long i = 0; i < healtharraysize; i++ ){
        Boolean touch=CGRectContainsPoint([[[_healthy_soldiers objectAtIndex:i] soldier] boundingBox],touchLocation);
        s=[_healthy_soldiers objectAtIndex:i];
        int type=[s getType];

        if(type==3&&touch==true){
            if([(CornMan*)s readyToLaunch]){
                _missile_atk_range = [s getAtkRange];
                _startlaunch=1;
                break;
            }
        }
    }
}


-(void)enemy_autobuild:(CCTime)dt{
    
    for( NSDictionary *d in [[Levels getSelectedLevel] enemySequence] ){
        NSNumber *num = (NSNumber*)[d objectForKey:@"time"];
        if( [num isEqualToNumber:[NSNumber numberWithInt:time]] ){
            NSNumber *laneNum = [d objectForKey:@"lane"];
            NSArray *soldiers = [d objectForKey:@"enemies"];
            NSArray *items = [d objectForKey:@"items"];
            NSNumber *enemyLev = [d objectForKey:@"lane"];

            for( int i=0; i<items.count; i++ ){
                int itemType = [(NSNumber*)items[i] intValue];
                // TODO
                
                
                CCScrollView* ccs = (CCScrollView*)[self parent];
                Gameplay* g = (Gameplay*)[ccs parent];
                [g itemAutoBuild:itemType];
            }
         
            
            for( int i=0; i<soldiers.count; i++ ){
                int soldierType = [(NSNumber*)soldiers[i] intValue]-1;
                [self buildEnemy:[laneNum intValue]-1 type:soldierType enemyLev:[enemyLev intValue]];
            }
        }
    }
    time++;
}


- (void)buildEnemy:(int) lane
                   type:(int) type
                   enemyLev:(int)enemyLev{
    
    NSArray *start_positions = @[_house4,_house5,_house6];
    NSArray *end_positions=@[_house1,_house2,_house3];
    CGPoint destination = CGPointMake([(CCNode*)end_positions[lane] position].x+30,
                                      [(CCNode*)end_positions[lane] position].y);
    
    if( type == 0 ){
        BurgerMan* enemy_soldier= [[BurgerMan alloc] initBurger:lane
                                                       startPos:[(CCNode*)start_positions[lane] position]
                                                        destPos:destination
                                                         ourArr:_junk_soldiers
                                                       enemyArr:_healthy_soldiers
                                                          level:enemyLev
                                                        bgNode:self];
        [enemy_soldier move];
    }
    if( type == 1 ){
        CokeMan* enemy_soldier= [[CokeMan alloc] initCoke: lane
                                                 startPos:[(CCNode*)start_positions[lane] position]
                                                  destPos:destination
                                                   ourArr:_junk_soldiers
                                                 enemyArr:_healthy_soldiers
                                                    level:enemyLev
                                                   bgNode:self];
        [enemy_soldier move];
    }
    if( type == 2 ){
        FriesMan* enemy_soldier= [[FriesMan alloc] initFries:lane
                                                    startPos:[(CCNode*)start_positions[lane] position]
                                                     destPos:destination
                                                      ourArr:_junk_soldiers
                                                    enemyArr:_healthy_soldiers
                                                       level:enemyLev
                                                    bgNode:self];
        [enemy_soldier move];
    }
    if( type == 3 ){
        FoodTruck* enemy_soldier= [[FoodTruck alloc] initFoodTruck:lane
                                                    startPos:[(CCNode*)start_positions[lane] position]
                                                     destPos:destination
                                                      ourArr:_junk_soldiers
                                                    enemyArr:_healthy_soldiers
                                                       level:enemyLev
                                                      bgNode:self];
        [enemy_soldier move];
    }
}

- (void)showTrack: (int) num {
    [_track1 setVisible:false];
    [_track2 setVisible:false];
    [_track3 setVisible:false];

    if( num == 1 )
        [_track1 setVisible:true];
    if( num == 2 ){
        [_track2 setVisible:true];
    }
    if( num == 3 )
        [_track3 setVisible:true];
}

+ (void) fillEnergyArray:(CCNode*)energy{
    [energyArray addObject:energy];
}

+ (NSMutableArray*) getEnergyArray{
    return energyArray;
}


@end
