//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "SavedData.h"
#import "Level.h"

@implementation MainScene

- (void)onEnter {
    [super onEnter];
    [Levels initLevels];
}

- (void)start {
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionLeft  duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}

- (void)setting {
    CCScene *settingScene = [CCBReader loadAsScene:@"SettingScene"];

    
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionUp  duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:settingScene withTransition:trans];

}

- (void)quit {
    exit(0);
}
@end
