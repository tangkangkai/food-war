//
//  Gameplay.m
//  manmove
//
//  Created by dqlkx on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Soldier.h"
#import "Bomb.h"
#import "SavedData.h"
#import "Scrollback.h"

#define BURGER 1;
#define COKE 2;
#define FRIES 3;


@implementation Gameplay{
    CCPhysicsNode *_physicsWorld;
    CCNode *_burgerman;
    CCNode *_cokeman;
    CCNode *_friesman;
    CCNode *_potato;
    
    Soldier *man;           //save the final man
    Scrollback *scroll;
    NSString *selected_soldier;
    NSString *selected_soldier_animation;
    CCNode *_scrollview;
    CCLabelTTF *_timerLabel;
    CCLabelTTF *_gameoverLabel;
    int mTimeInSec;
    int timeFlag;
//    CCTimer *_timer;


}

- (id)init{
    self = [super init];
    if (!self) return(nil);
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];

    selected_soldier = NULL;
    man = NULL;
    
//    _timer = [[CCTimer alloc] init];

    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    mTimeInSec = 300;                              //intialize timer
    timeFlag = 0;
    [self schedule:@selector(tick) interval:1.0f];
}

-(void)tick {
    if(timeFlag == 0){
        mTimeInSec -= 1;
        _timerLabel.string = [NSString stringWithFormat:@"%d", mTimeInSec];
        if(mTimeInSec == 0) timeFlag = 1;
    } else if(timeFlag == 1){
        _gameoverLabel.string = [NSString stringWithFormat:@"GameOver"];
        UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Menu"
                                                          message:@"Plese choose"
                                                         delegate:self
                                                cancelButtonTitle:@"Restart"
                                                otherButtonTitles: nil];
        [alert addButtonWithTitle:@"Quit Game"];
        [alert show];
        timeFlag = 2;
    } else{
        //do nothing
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0){
        NSLog(@"You have clicked Restart");
        [[CCDirector sharedDirector] resume];
        CCScene *playScene = [CCBReader loadAsScene:@"Gameplay"];
        CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
        [[CCDirector sharedDirector] replaceScene:playScene withTransition:trans];
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

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Received a touch");
    CGPoint touchLocation = [touch locationInNode:self];
    
    if (CGRectContainsPoint(_burgerman.boundingBox,touchLocation)) {
        selected_soldier = @"burger";
        selected_soldier_animation=@"burger";
    } else if(CGRectContainsPoint(_cokeman.boundingBox,touchLocation)) {
        selected_soldier = @"coke";
        selected_soldier_animation=@"coke";
    } else if(CGRectContainsPoint(_friesman.boundingBox,touchLocation)) {
        selected_soldier = @"fries";
        selected_soldier_animation=@"fries";
    } else if(CGRectContainsPoint(_potato.boundingBox,touchLocation)) {
        selected_soldier = @"potato";
        selected_soldier_animation=@"potato";
        Bomb* newSolider = [[Bomb alloc] initSoldier:selected_soldier
                                                     group:@"noGroup"
                                             collisionType:@"noCollision"
                                                  startPos:touchLocation
                                                    destPos:touchLocation
                                                       ourArr:NULL
                                                     enemyArr:NULL];
        man = newSolider;
        // TODO possible memory leak
        [self addChild: [newSolider soldier]];
        return;
        
    }
    
    if (selected_soldier != NULL){
        Soldier* newSolider = [[Soldier alloc] initSoldier:selected_soldier
                                               group:@"noGroup"
                                               collisionType:@"noCollision"
                                               startPos:touchLocation
                                               destPos:touchLocation
                                               ourArr:NULL enemyArr:NULL ];
        man = newSolider;
        // TODO possible memory leak
        [self addChild: [newSolider soldier]];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    scroll=[_scrollview children][0];
    if( man == NULL ){
        return;
    }
    CCLOG(@"Touch Moved");
    CGPoint touchLocation = [touch locationInNode:self];
    [man soldier].position = touchLocation;
    if (CGRectContainsPoint(CGRectMake([scroll track1].boundingBox.origin.x, [scroll track1].boundingBox.origin.y+20, [scroll track1].boundingBox.size.width, [scroll track1].boundingBox.size.height),touchLocation)) {
        NSLog(@"moved into track 1");
     //   NSLog(@"touchLocation (x: %f, y: %f)",touchLocation.x,touchLocation.y);
     //   NSLog(@"track 1 origin (x: %f, y : %f)",[scroll track1].boundingBox.origin.x,[scroll track1].boundingBox.origin.y);
        
        [scroll track1].visible = true;
    } else if (CGRectContainsPoint(CGRectMake([scroll track2].boundingBox.origin.x, [scroll track2].boundingBox.origin.y+20, [scroll track2].boundingBox.size.width, [scroll track2].boundingBox.size.height),touchLocation)) {
        NSLog(@"moved into track 2");
        [scroll track2].visible = true;
    } else if (CGRectContainsPoint(CGRectMake([scroll track3].boundingBox.origin.x, [scroll track3].boundingBox.origin.y+20, [scroll track3].boundingBox.size.width, [scroll track3].boundingBox.size.height),touchLocation)) {
        NSLog(@"moved into track 3");
        [scroll track3].visible = true;
    } else {
        [scroll trackInvist];
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Ended");
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    if (CGRectContainsPoint(CGRectMake([scroll track1].boundingBox.origin.x, [scroll track1].boundingBox.origin.y+20, [scroll track1].boundingBox.size.width, [scroll track1].boundingBox.size.height),touchLocation)) {
        NSLog(@"located in track 1");
        [self launchmovingman:[scroll house1] dest:[scroll house4]];
    } else if (CGRectContainsPoint(CGRectMake([scroll track2].boundingBox.origin.x, [scroll track2].boundingBox.origin.y+20, [scroll track2].boundingBox.size.width, [scroll track2].boundingBox.size.height),touchLocation)) {
        NSLog(@"located in track 2");
        [self launchmovingman: [scroll house2] dest:[scroll house5]];
    } else if (CGRectContainsPoint(CGRectMake([scroll track3].boundingBox.origin.x, [scroll track3].boundingBox.origin.y+20, [scroll track3].boundingBox.size.width, [scroll track3].boundingBox.size.height),touchLocation)) {
        NSLog(@"located in track 3");
        [self launchmovingman:[scroll house3] dest:[scroll house6]];
    } else {
        [self removeChild:[man soldier]];
    }
    man = NULL;
    selected_soldier = NULL;
    [scroll trackInvist];
}


- (void)launchmovingman: (CCNode *)sourcehouse dest:(CCNode *)desthouse {
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];
    if( man == NULL ){
        return;
    }
    [self removeChild: [man soldier]];
    
    Soldier *newSoldier = nil;
    if([selected_soldier_animation isEqualToString:@"potato"]) {
        
        CGPoint dest;
        dest.x = 0;
        dest.y = 0;
        newSoldier = [[Bomb alloc] initSoldier:selected_soldier
                                   group:@"myGroup"
                                   collisionType:@"healthyCollision"
                                   startPos:sourcehouse.position
                                   destPos:dest
                                   ourArr:[scroll healthy_soldiers]
                                   enemyArr:[scroll junk_soldiers]];
        CGPoint destination;

        destination.x = 0;
        destination.y = 0;
        [_physicsWorld addChild: [newSoldier soldier]];
        [newSoldier move];
        return;
    } else {
        newSoldier = [[Soldier alloc] initSoldier:selected_soldier
                                       group:@"myGroup"
                                       collisionType:@"healthyCollision"
                                       startPos:sourcehouse.position
                                       destPos: desthouse.position
                                       ourArr:[scroll healthy_soldiers]
                                       enemyArr:[scroll junk_soldiers]];
    }

    [_physicsWorld addChild: [newSoldier soldier]];
    [newSoldier move];
}

- (void)addjunk {
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];
    Soldier* test_junk = [[Soldier alloc] initSoldier:@"burgerMan"
                                          group:@"enemyGroup"
                                          collisionType:@"junkCollision"
                                          startPos:[scroll house4].position
                                          destPos:[scroll house1].position
                                          ourArr:[scroll junk_soldiers]
                                          enemyArr:[scroll junk_soldiers]];
    [_physicsWorld addChild: [test_junk soldier]];
    [test_junk move];
}
@end
