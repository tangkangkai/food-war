//
//  ThirdScene.m
//  FireArm
//
//  Created by Luis Perez Cruz on 9/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ThirdScene.h"
#import <CCActionInterval.h>
#import <cocos2d.h>

@implementation ThirdScene
{
    CCNode *missile;
}

- (void)didLoadFromCCB
{
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    self.multipleTouchEnabled = TRUE;
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // we want to know the location of our touch in this scene
    CGPoint touchLocation = [touch locationInNode:self];
    
    
    
    //int posX = touchLocation.x;
    //int posY = touchLocation.y;
    
   // CGRect screen = [[UIScreen mainScreen] bounds];
   // CGFloat width = CGRectGetWidth(screen);
   
    //Bonus height.
   // CGFloat height = CGRectGetHeight(screen);
    
   // CGPoint newPosition = ccp(fmax(missile.position.x + width * 0.2f, width), missile.position.y);
   
    CCActionJumpBy* jumpUp = [CCActionJumpBy actionWithDuration:1.0f position:touchLocation
        height:touchLocation.y jumps:1];
    
    
    
    [missile runAction:jumpUp];
    
    // missile.position =  CGPointMake(touchLocation.x, touchLocation.y);
    
    // missile.position = touchLocation;
}

@end
