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
    CCNode *_potatoMan;
    CCNode *_bananaMan;
    CCNode *_beanMan;
    CCNode *_cabbageBomb;
    CCNode *_scrollview;
    Scrollback *scroll;

    Soldier *man;           //save the final man
    Bomb *item;
    
    NSString *selected_soldier;
    NSString *selected_soldier_animation;
    
    CCLabelTTF *_timerLabel;
    CCLabelTTF *_gameoverLabel;
    CCLabelTTF *_money;

    int mTimeInSec;
    int timeFlag;
    CCSprite *_first;
    CCSprite *_second;
    CCSprite *_third;
    NSMutableArray *lineupArray;
}

- (id)init{
    self = [super init];
    if (!self) return(nil);
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];

    selected_soldier = NULL;
    man = NULL;
    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    mTimeInSec = 300;                              //intialize timer
    timeFlag = 0;
    [self schedule:@selector(tick) interval:1.0f];

}

- (void)onEnter {
    [super onEnter];
    //get the lineup soldier from dictionary and write to scene
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"healthy_food.plist"];
    CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableDictionary *soldiers = [SavedData lineupDictonary];
    NSMutableArray *spots = [[NSMutableArray alloc] init];
    lineupArray = [[NSMutableArray alloc] init];
    [spots addObject:_first];
    [spots addObject:_second];
    [spots addObject:_third];
    NSArray *keys = [soldiers allKeys];
    NSLog(@"length of lineup: %d", (int)keys.count);
    for (int i = 0; i < (int)keys.count; i++) {
        CCSprite *spot = [spots objectAtIndex:i];
        CCNode *soldier = [keys objectAtIndex:i];
        CCSpriteFrame* frame = [cache spriteFrameByName:[soldiers objectForKey:soldier]];
        spot.spriteFrame = frame;
        [lineupArray addObject:soldier];
        NSLog(@"%@", [soldiers objectForKey:soldier]);
    }
    
    for (int i = (int)keys.count; i < spots.count; i++) {
        CCSprite *spot = [spots objectAtIndex:i];
        spot.spriteFrame = NULL;
        NSLog(@"!!!!!!");
    }
}

-(void)updateMoney{
    [_money setString:[NSString stringWithFormat:@"%d", [SavedData money]]];
}

-(void)tick {
    if(timeFlag == 0){
        if((mTimeInSec--) == 0){
            timeFlag = 1;
        }
        [_timerLabel setString:[NSString stringWithFormat:@"%d", mTimeInSec]];
        [self updateMoney];

    } else if(timeFlag == 1){
        [[CCDirector sharedDirector] pause];
        _gameoverLabel.string = [NSString stringWithFormat:@"GameOver"];
        UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Menu"
                                                    message:@"Plese choose"
                                                    delegate:self
                                                    cancelButtonTitle:@"Restart"
                                                    otherButtonTitles: @"Quit",nil];
        [alert show];
        timeFlag = 2;
    } else{
        //do nothing
    }
}

// TODO add a showDialog function


- (void)menu {
    [[CCDirector sharedDirector] pause];
    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Menu"
                                                message:@"Plese choose"
                                                delegate:self
                                                cancelButtonTitle:@"Resume"
                                                otherButtonTitles: @"Quit", nil];
    [alert setTag:1];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    NSLog(@"Button Index =%ld of tag %ld",(long)buttonIndex, (long)[alertView tag]);
    long tag =[alertView tag];
    if (buttonIndex == 0){
        if(tag == 1){
            NSLog(@"You have clicked Cancel");
            [[CCDirector sharedDirector] resume];
        }
        else{
            NSLog(@"You have clicked Restart");
            [[CCDirector sharedDirector] resume];
            CCScene *playScene = [CCBReader loadAsScene:@"Gameplay"];
            CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
            [[CCDirector sharedDirector] replaceScene:playScene withTransition:trans];
        }
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
    CGPoint touchLocation = [touch locationInNode:self];
    
    if (_first.spriteFrame!=NULL && CGRectContainsPoint(_first.boundingBox,touchLocation)) {
        selected_soldier = [lineupArray objectAtIndex:0];
        selected_soldier_animation=[lineupArray objectAtIndex:0];
    } else if (_second.spriteFrame!=NULL && CGRectContainsPoint(_second.boundingBox,touchLocation)) {
        selected_soldier = [lineupArray objectAtIndex:1];
        selected_soldier_animation=[lineupArray objectAtIndex:1];
    } else if (_third.spriteFrame!=NULL && CGRectContainsPoint(_third.boundingBox,touchLocation)) {
        selected_soldier = [lineupArray objectAtIndex:2];
        selected_soldier_animation=[lineupArray objectAtIndex:2];
    } else if(CGRectContainsPoint(_cabbageBomb.boundingBox,touchLocation)) {
        selected_soldier = @"cabbageBomb";
        selected_soldier_animation=@"cabbageBomb";
        Bomb* newBomb = [[Bomb alloc] initBomb:selected_soldier startPosition:touchLocation endPosition:touchLocation];
        item = newBomb;
        // TODO possible memory leak
        [self addChild: [newBomb bomb]];
        return;
    }
    
    if (selected_soldier != NULL){
        Soldier* newSolider = [[Soldier alloc] initSoldier:selected_soldier
                                               group:-1
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
    CGPoint touchLocation = [touch locationInNode:self];
    if([selected_soldier isEqualToString:@"cabbageBomb"]){
        if(item == NULL) return;
        
        [item bomb].position = touchLocation;
        return;
    }
    
    if( man == NULL ){
        return;
    }
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
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    if([selected_soldier_animation isEqualToString:@"cabbageBomb"]) {
        NSLog(@"release BOMB!");
        [self launchBomb:touchLocation];
    } else if (CGRectContainsPoint(CGRectMake([scroll track1].boundingBox.origin.x, [scroll track1].boundingBox.origin.y+20, [scroll track1].boundingBox.size.width, [scroll track1].boundingBox.size.height),touchLocation)) {
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


- (void)launchBomb: (CGPoint)touchLocation {
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];
    if(item== NULL ){
        return;
    }
    [self removeChild: [item bomb]];
    
    Bomb *newBomb = nil;
    newBomb = [[Bomb alloc] initBomb:selected_soldier startPosition:touchLocation endPosition:touchLocation];
    [_physicsWorld addChild: [newBomb bomb]];
    [newBomb drop:touchLocation];
    
}


- (void)launchmovingman: (CCNode *)sourcehouse dest:(CCNode *)desthouse {
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];
    if( man == NULL ){
        return;
    }
    [self removeChild: [man soldier]];
    
    Soldier *newSoldier = nil;

        // Avoid the physic confliction with the new born enemy
    CGPoint destination = CGPointMake(desthouse.position.x-50, desthouse.position.y);
    newSoldier = [[Soldier alloc] initSoldier:selected_soldier
                                    group:0
                                    startPos:sourcehouse.position
                                    destPos: destination
                                    ourArr:[scroll healthy_soldiers]
                                    enemyArr:[scroll junk_soldiers]];
    

    [_physicsWorld addChild: [newSoldier soldier]];
    [newSoldier move];
}


- (void)addjunk {
    scroll=[_scrollview children][0];
    _physicsWorld=[scroll scroll_physicsWorld];
    CGPoint destination = CGPointMake([scroll house1].position.x+50,
                                      [scroll house1].position.y);
    Soldier* test_junk = [[Soldier alloc] initSoldier:@"burgerMan"
                                          group:1
                                          startPos:[scroll house4].position
                                          destPos:destination
                                          ourArr:[scroll junk_soldiers]
                                          enemyArr:[scroll junk_soldiers]];

    [_physicsWorld addChild: [test_junk soldier]];
    [test_junk move];
}
@end
