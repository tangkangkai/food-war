//
//  GameScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"

static GameScene* GameSceneInstance;

@implementation GameScene {
    
}

+(GameScene*)shareLayer{
    return GameSceneInstance;
}

-(id) init
{
    if( (self=[super init])) {
        GameSceneInstance=self;
    }
    return self;
}

- (void) back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionRight duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:trans];
}



@end
