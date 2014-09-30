//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void)shoot
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"SecondScene"];
    
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void) missileLaunch
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"ThirdScene"];
    
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
