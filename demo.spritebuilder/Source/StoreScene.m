//
//  StoreScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StoreScene.h"

@implementation StoreScene {
    CCTextField *_total;
    int total;
}

-(void) onEnter {
    [super onEnter];
    total = 100;
}

-(void)back {
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}

-(void)button1 {
    [self reduceTotalMoney:10];
}

-(void)button2 {
    [self reduceTotalMoney:8];
}

-(void)button3 {
    [self reduceTotalMoney:6];
}

-(void)button4 {
    [self reduceTotalMoney:4];
}

-(void)reduceTotalMoney: (int)value {
    NSLog(@"hehe");
    CCActionMoveTo *moveDown = [CCActionMoveTo actionWithDuration:0.1f position:ccp(99, 270)];
    CCActionMoveTo *moveUp = [CCActionMoveTo actionWithDuration:0.1f position:ccp(99, 286)];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveDown, moveUp]];
    [_total runAction:sequence];
    total -= value;
    _total.string = [NSString stringWithFormat:@"Total: %d", total];
}
@end