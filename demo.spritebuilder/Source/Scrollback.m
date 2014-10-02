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
    
    _scroll_physicsWorld = [CCPhysicsNode node];
    _scroll_physicsWorld.gravity = ccp(0,0);
    //_physicsWorld.debugDraw = YES;   // show the physic content
    _scroll_physicsWorld.collisionDelegate = self;
    _scroll_physicsWorld.zOrder = 10000;
    [self addChild:_scroll_physicsWorld];
    
    _junk_soldiers = [NSMutableArray arrayWithObjects:nil ];
    _healthy_soldiers = [NSMutableArray arrayWithObjects:nil ];
    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self schedule:@selector(enemy_autobuild:) interval:5];
}


-(void)enemy_autobuild:(CCTime)dt{

    //TODO change to dictionary
    NSArray *soldier_image = @[@"burgerMan",@"cokeMan",@"friesMan"];
    NSArray *start_positions = @[_house4,_house5,_house6];
    NSArray *end_positions=@[_house1,_house2,_house3];

    int i = arc4random()%3;
    int lane_num = arc4random()%3;

    Soldier* enemy_soldier= [[Soldier alloc] initSoldier:soldier_image[i]
                               group:@"enemyGroup"
                               collisionType:@"junkCollision"
                               startPos:[(CCNode*)start_positions[lane_num] position]
                               arr:_junk_soldiers];
    [_scroll_physicsWorld addChild: [enemy_soldier soldier]];
    [enemy_soldier move:[(CCNode*)end_positions[lane_num] position]];

}


- (void)menu {
    [[CCDirector sharedDirector] pause];
    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Menu"
                                                      message:@"Plese choose"
                                                     delegate:self
                                            cancelButtonTitle:@"Resume"
                                            otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Quit Game"];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0){
        NSLog(@"You have clicked Cancel");
        [[CCDirector sharedDirector] resume];
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"You have clicked Quit Game");
        [[CCDirector sharedDirector] resume];
        CCScene *choiceScene = [CCBReader loadAsScene:@"GameScene"];
        CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
        [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
    }
}

- (void)trackInvist {
    _track1.visible = false;
    _track2.visible = false;
    _track3.visible = false;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair healthyCollision:(CCNode *)healthy junkCollision:(CCNode *)junk{
    [healthy stopAllActions];
    [junk stopAllActions];
    Soldier *healthySoldier, *junkSoldier;
    for( Soldier *s in _healthy_soldiers ){
        if( [s soldier] == healthy ){
            healthySoldier = s;
        }
    }
    //while (true) {
    [ healthySoldier attack: _junk_soldiers ];
        //sleep(1);
    //}
    //[self schedule:@selector(start_attack:) withObject:healthySoldier interval:1.0f];
    NSLog(@"Collision");
    return YES;
}

- (void)start_attack: (Soldier*) s{
    //NSLog(@"test");
    [ s attack: _junk_soldiers ];
}

@end
