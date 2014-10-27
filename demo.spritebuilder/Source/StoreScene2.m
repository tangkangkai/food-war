//
//  StoreScene2.m
//  demo
//
//  Created by dqlkx on 10/27/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "StoreScene2.h"


@implementation StoreScene2

- (void)back{
    
    CCScene *gameScene = [CCBReader loadAsScene:@"StoreScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.01f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}
@end
