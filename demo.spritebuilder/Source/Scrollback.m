//
//  Scrollback.m
//  demo
//
//  Created by dqlkx on 9/29/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Scrollback.h"
#import "Soldier.h"

@implementation Scrollback{
    


}

- (id)init{
    self = [super init];
    if (!self) return(nil);

    
    _junk_soldiers = [NSMutableArray arrayWithObjects:nil ];
    _healthy_soldiers = [NSMutableArray arrayWithObjects:nil ];
    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self schedule:@selector(enemy_autobuild:) interval:6];
}


-(void)enemy_autobuild:(CCTime)dt{

    //TODO change to dictionary
    NSArray *soldier_image = @[@"burgerMan",@"cokeMan",@"friesMan"];
    NSArray *start_positions = @[_house4,_house5,_house6];
    NSArray *end_positions=@[_house1,_house2,_house3];

    int i = arc4random()%3;
    int lane_num = arc4random()%3;
    
    CGPoint destination = CGPointMake([(CCNode*)end_positions[lane_num] position].x+50,
                                      [(CCNode*)end_positions[lane_num] position].y);
    Soldier* enemy_soldier= [[Soldier alloc] initSoldier:soldier_image[i]
                                             group:1
                                             lane_num:lane_num
                                             startPos:[(CCNode*)start_positions[lane_num] position]
                                             destPos:destination
                                             ourArr:_junk_soldiers
                                             enemyArr:_healthy_soldiers];
    
    [ self addChild: [enemy_soldier soldier]];
    [enemy_soldier move];
}



- (void)trackInvist {
    _track1.visible = false;
    _track2.visible = false;
    _track3.visible = false;
}

@end
