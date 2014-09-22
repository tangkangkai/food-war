//
//  Soldier.h
//  demo
//
//  Created by 丁硕青 on 9/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Soldier : NSObject
@property NSInteger *id;
@property NSString *name;

@property float atk_speed;  // the time interval between every attack
@property int type;         // 0: tank, 1: melee-DPS, 2: ranged-DPS, 3: missile launcher
@property int atk_range;
@property int atk_power;
@property float defence;    // value is from 0 ~ 1(100%)
@property int ability_id;
@property CCNode* soldier;


- (int)loseHealth:(int)Attack;
- (void)attack;
- (void)loadSolider:(NSString*) solder_img startPos:(CGPoint) pos;
- (void)move:(int) duration targetPos:(CGPoint) pos;

@end
