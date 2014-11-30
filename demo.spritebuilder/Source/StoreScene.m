//
//  StoreScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StoreScene.h"
#import "SavedData.h"
#import "Soldier.h"

@implementation StoreScene {
    CCTextField *_total;
    CCTextField *_message;
    int total;
    CCScrollView *_selectscroll;
    CCNodeColor* _upgrade1;
    CCNodeColor* _upgrade2;
    CCNodeColor* _upgrade3;
    CCNodeColor* _upgrade4;
}

- (void) didLoadFromCCB {
    NSLog(@"enter store scene");
    _selectscroll.delegate = self;
    _message.string = [NSString stringWithFormat:@"You need more money to update"];
    _message.opacity = 0;
    _upgrade1.opacity=1;
    total = [SavedData money];
    
    //set the state(atkPower, health, defense value)
    _total.string = [NSString stringWithFormat:@" %d", total];
}

- (void) setNodes {
    float x=[_selectscroll scrollPosition].x;
    if (x<250) {
        _upgrade1.opacity=1;
        _upgrade2.opacity=0.5;
        _upgrade3.opacity=0.5;
        _upgrade4.opacity=0.5;
    }
    if (x>=250&&x<774) {
        _upgrade1.opacity=0.5;
        _upgrade2.opacity=1;
        _upgrade3.opacity=0.5;
        _upgrade4.opacity=0.5;
    }
    if (x>=774&&x<1298) {
        _upgrade1.opacity=0.5;
        _upgrade2.opacity=0.5;
        _upgrade3.opacity=1;
        _upgrade4.opacity=0.5;
    }
    if (x>=1298) {
        _upgrade1.opacity=0.5;
        _upgrade2.opacity=0.5;
        _upgrade3.opacity=0.5;
        _upgrade4.opacity=1;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    [self setNodes];
}

- (void)back {
    
    CCScene *gameScene = [CCBReader loadAsScene:@"ChoiceScene"];
    
    CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:trans];
}

-(void)updateTotal:(int)totalMoney {
    _total.string = [NSString stringWithFormat:@" %d", totalMoney];
}

-(void) showMessage {
    CCActionFadeTo* fadeIn = [CCActionFadeTo actionWithDuration:0.1f opacity:255];
    CCActionMoveTo *moveLeft = [CCActionMoveTo actionWithDuration:0.05f position:ccp(258, 293)];
    CCActionMoveTo *moveRight = [CCActionMoveTo actionWithDuration:0.05f position:ccp(298, 293)];
    CCActionMoveTo *moveBack = [CCActionMoveTo actionWithDuration:0.1f position:ccp(278, 293)];
    
    CCActionFadeTo* fadeOut = [CCActionFadeTo actionWithDuration:1.0f opacity:0];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveLeft, moveRight, moveLeft, moveRight, moveBack, fadeOut]];
    [_message runAction:sequence];
}

-(void)reduceTotalMoney: (int)value {
    CCActionMoveTo *moveDown = [CCActionMoveTo actionWithDuration:0.1f position:ccp(496, 270)];
    CCActionMoveTo *moveUp = [CCActionMoveTo actionWithDuration:0.1f position:ccp(496, 292)];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveDown, moveUp]];
    [_total runAction:sequence];
    total -= value;
    _total.string = [NSString stringWithFormat:@"%d", total];
    [SavedData setMoney:total];
    [SavedData saveMoney];
}

@end
