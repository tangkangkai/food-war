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

    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    [self schedule:@selector(enemy_autobuild:) interval:1.5];
}


-(void)enemy_autobuild:(CCTime)dt{

    NSArray *soldier_image=@[@"burgerMan",@"cokeMan",@"friesMan"];
    int i=0;
    Soldier* enemy_soldier_track1= [[Soldier alloc] init];
    Soldier* enemy_soldier_track2= [[Soldier alloc] init];
    Soldier* enemy_soldier_track3= [[Soldier alloc] init];
    
    i=arc4random()%3;
    [enemy_soldier_track1 loadSolider:soldier_image[i] group:@"enemyGroup" collisionType:@"junkCollision" startPos:_house4.position];
    i=arc4random()%3;
    [enemy_soldier_track2 loadSolider:soldier_image[i] group:@"enemyGroup" collisionType:@"junkCollision" startPos:_house5.position];
    i=arc4random()%3;
    [enemy_soldier_track3 loadSolider:soldier_image[i]group:@"enemyGroup" collisionType:@"junkCollision" startPos:_house6.position];
    
    [enemy_soldier_track1 soldier].scaleX *= -1; // TODO remove this after we have more models
    [enemy_soldier_track2 soldier].scaleX *= -1; // TODO remove this after we have more models
    [enemy_soldier_track3 soldier].scaleX *= -1; // TODO remove this after we have more models
    [_scroll_physicsWorld addChild: [enemy_soldier_track1 soldier]];
    [_scroll_physicsWorld addChild: [enemy_soldier_track2 soldier]];
    [_scroll_physicsWorld addChild: [enemy_soldier_track3 soldier]];
    [enemy_soldier_track1 move:_house1.position];
    [enemy_soldier_track2 move:_house2.position];
    [enemy_soldier_track3 move:_house3.position];





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
    NSLog(@"Collision");
    return YES;
}


@end
