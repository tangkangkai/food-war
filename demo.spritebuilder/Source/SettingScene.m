//
//  SettingScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SettingScene.h"

@implementation SettingScene

- (void)onEnter {
    [super onEnter];
    NSLog(@"enter setting scene");
}

- (void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionDown duration: 0.5f];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:trans];
}

@end
