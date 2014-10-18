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
#import "CCAnimation.h"
#import <UIKit/UIKit.h>
#include <CCDirector.h>
#import "CCAction.h"

#define BURGER 1;
#define COKE 2;
#define FRIES 3;


@implementation Gameplay{
    CCPhysicsNode *_physicsWorld;
    CCNode *_potatoMan;
    CCNode *_bananaMan;
    CCNode *_beanMan;
    CCNode *_blackBomb;
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
    CCSprite *_fourth;
    NSMutableArray *lineupArray;
    
    OALSimpleAudio *audio;
}

- (id)init{
    self = [super init];
    if (!self) return(nil);
    _physicsWorld=[scroll scroll_physicsWorld];

    selected_soldier = NULL;
    man = NULL;
    
    audio = [OALSimpleAudio sharedInstance];
    return self;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    scroll=[_scrollview children][0];
    self.userInteractionEnabled = TRUE;
    mTimeInSec = 300;                              //intialize timer
    timeFlag = 0;
    [self schedule:@selector(tick) interval:1.0f];
  
    [audio playBg:@"playBackground.mp3" loop:TRUE];

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
    [spots addObject:_fourth];
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
    }
}

-(void)onExit{
    [super onExit];
    [audio stopBg];
}

-(void)updateMoney{
    [_money setString:[NSString stringWithFormat:@"$ %d", [SavedData money]]];
}

-(void)tick {
    if(timeFlag == 0){
        if( [[scroll healthBase] isDead]){
            [self gameover];
        }
        else if( [(Base*)[scroll junkBase] isDead] ){
            [self win];
        }
        
        if((mTimeInSec--) == 0){
            timeFlag = 1;
        }
        [_timerLabel setString:[NSString stringWithFormat:@"%d", mTimeInSec]];
        [self updateMoney];

    } else if(timeFlag == 1 ){
        timeFlag = 2;
        [self gameover];

    } else{
        //do nothing
    }
}

- (void)gameover{
    [[CCDirector sharedDirector] pause];
    _gameoverLabel.string = [NSString stringWithFormat:@"GameOver"];
    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Gameover"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"Restart"
                                            otherButtonTitles: @"Quit",nil];
    [alert show];
}

- (void)win{
    [[CCDirector sharedDirector] pause];
    _gameoverLabel.string = [NSString stringWithFormat:@"You win"];
    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"You win"
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles: nil];
    [alert setTag:2];
    [alert show];
}

- (void)menu {
    [[CCDirector sharedDirector] pause];
    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Pause"
                                                message:@""
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
            [[CCDirector sharedDirector] resume];
        }
        else if(tag==2){
            [[CCDirector sharedDirector] resume];
            CCScene *choiceScene = [CCBReader loadAsScene:@"GameScene"];
            CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
            [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
        }
        else{
            [[CCDirector sharedDirector] resume];
            CCScene *playScene = [CCBReader loadAsScene:@"Gameplay"];
            CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
            [[CCDirector sharedDirector] replaceScene:playScene withTransition:trans];
        }
    }
    else if(buttonIndex == 1){
        NSLog(@"You have clicked Quit Game");
        [[CCDirector sharedDirector] resume];
        CCScene *choiceScene = [CCBReader loadAsScene:@"GameScene"];
        CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
        [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:self];
    int soldierLevel = 0;
    NSString *soldier = NULL;
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    if (_first.spriteFrame!=NULL && CGRectContainsPoint(_first.boundingBox,touchLocation)) {
        soldier = [lineupArray objectAtIndex:0];
    } else if (_second.spriteFrame!=NULL && CGRectContainsPoint(_second.boundingBox,touchLocation)) {
        soldier = [lineupArray objectAtIndex:1];
    } else if (_third.spriteFrame!=NULL && CGRectContainsPoint(_third.boundingBox,touchLocation)) {
        soldier = [lineupArray objectAtIndex:2];
    } else if (_third.spriteFrame!=NULL && CGRectContainsPoint(_fourth.boundingBox,touchLocation)) {
        soldier = [lineupArray objectAtIndex:3];
    
    } else if(CGRectContainsPoint(_blackBomb.boundingBox,touchLocation)) {
        selected_soldier = @"blackBomb";
        selected_soldier_animation=@"blackBomb";
        
        ///////////////test animation
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bombAni.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bombAni.png"];
        [self addChild:spriteSheet];
        NSMutableArray *flashAnimFrames = [NSMutableArray array];
        for (int i=1; i<=2; i++) {
            [flashAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"bomb%d.png",i]]];
        }
        
        CCAnimation *flashAnim = [CCAnimation
                                  animationWithSpriteFrames:flashAnimFrames delay:0.1f];
        
        CCSpriteFrame* bombFrame = [CCSpriteFrame frameWithImageNamed:@"bomb1.png" ];
        CCSprite* title = [CCSprite spriteWithSpriteFrame:bombFrame];
        self.anibomb = title;
        self.anibomb.position = touchLocation;
        
        self.flashAction = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:flashAnim]];
        
        [self.anibomb runAction:self.flashAction];
        //    [self addChild:self.anibomb];
        [spriteSheet addChild:self.anibomb];

        
        ///////////////
        /*
        Bomb* newBomb = [[Bomb alloc] initBomb:@"blackBombRing" animation:self.anibomb startPosition:touchLocation endPosition:touchLocation enemyArr:NULL];
        item = newBomb;
        // TODO possible memory leak
        [self addChild: [newBomb bomb]];*/
        return;
    }
    
    selected_soldier = soldier;
    selected_soldier_animation = soldier;
    soldierLevel = [soldierLevelDict objectForKey:soldier];
    
    if (selected_soldier != NULL){
        Soldier* newSolider = [[Soldier alloc] initSoldier:selected_soldier
                                               group:-1
                                               lane_num:-1
                                               startPos:touchLocation
                                               destPos:touchLocation
                                               ourArr:NULL enemyArr:NULL level:soldierLevel];
        man = newSolider;
        // TODO possible memory leak
        [self addChild: [newSolider soldier]];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    if([selected_soldier isEqualToString:@"blackBomb"]){
//        if(item == NULL) return;
        
        _anibomb.position = touchLocation;
        return;
    }
    
    if( man == NULL ){
        return;
    }
    [man soldier].position = touchLocation;
    if (CGRectContainsPoint(CGRectMake([scroll track1].boundingBox.origin.x, [scroll track1].boundingBox.origin.y+40, [scroll track1].boundingBox.size.width, [scroll track1].boundingBox.size.height),touchLocation)) {
        [scroll showTrack:1];
        
    } else if (CGRectContainsPoint(CGRectMake([scroll track2].boundingBox.origin.x, [scroll track2].boundingBox.origin.y+30, [scroll track2].boundingBox.size.width, [scroll track2].boundingBox.size.height),touchLocation)) {
        [scroll showTrack:2];

    } else if (CGRectContainsPoint(CGRectMake([scroll track3].boundingBox.origin.x, [scroll track3].boundingBox.origin.y+20, [scroll track3].boundingBox.size.width, [scroll track3].boundingBox.size.height),touchLocation)) {
        [scroll showTrack:3];

    } else {
        [scroll showTrack:0];
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
 //   OALSimpleAudio *blop = [OALSimpleAudio sharedInstance];  // play sound effect
    [audio playEffect:@"blop.mp3"];
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    if([selected_soldier_animation isEqualToString:@"blackBomb"]) {
        NSLog(@"release BOMB!");
        [self launchBomb:touchLocation];
    } else if (CGRectContainsPoint(CGRectMake([scroll track1].boundingBox.origin.x, [scroll track1].boundingBox.origin.y+20, [scroll track1].boundingBox.size.width, [scroll track1].boundingBox.size.height),touchLocation)) {
        NSLog(@"located in track 1");
        [self launchmovingman:[scroll house1] dest:[scroll house4] lane_num:0];
    } else if (CGRectContainsPoint(CGRectMake([scroll track2].boundingBox.origin.x, [scroll track2].boundingBox.origin.y+20, [scroll track2].boundingBox.size.width, [scroll track2].boundingBox.size.height),touchLocation)) {
        NSLog(@"located in track 2");
        [self launchmovingman: [scroll house2] dest:[scroll house5] lane_num:1];
    } else if (CGRectContainsPoint(CGRectMake([scroll track3].boundingBox.origin.x, [scroll track3].boundingBox.origin.y+20, [scroll track3].boundingBox.size.width, [scroll track3].boundingBox.size.height),touchLocation)) {
        NSLog(@"located in track 3");
        [self launchmovingman:[scroll house3] dest:[scroll house6] lane_num:2];
    } else {
        [self removeChild:[man soldier]];
    }
    man = NULL;
    selected_soldier = NULL;
    [scroll showTrack:0];
}


- (void)launchBomb: (CGPoint)touchLocation {
    scroll=[_scrollview children][0];
//    if(item== NULL ){
//        return;
//    }
//    [self removeChild: [item bomb]];
    [self removeChild: [item bomb]];
    [_anibomb removeFromParent];
    
    /*
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bombAni.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bombAni.png"];
    [self addChild:spriteSheet];
    NSMutableArray *flashAnimFrames = [NSMutableArray array];
    for (int i=1; i<=2; i++) {
        [flashAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"bomb%d.png",i]]];
    }

    CCAnimation *flashAnim = [CCAnimation
                             animationWithSpriteFrames:flashAnimFrames delay:0.1f];
    
    CCSpriteFrame* bombFrame = [CCSpriteFrame frameWithImageNamed:@"bomb1.png" ];
    CCSprite* title = [CCSprite spriteWithSpriteFrame:bombFrame];
    self.anibomb = title;
    self.anibomb.position = ccp(300, 300);
    
    self.flashAction = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:flashAnim]];
    
    [self.anibomb runAction:self.flashAction];
//    [self addChild:self.anibomb];
    [spriteSheet addChild:self.anibomb];*/
    
    
    if(touchLocation.y < 70) return;
    Bomb *newBomb = [[Bomb alloc] initBomb:@"blackBomb" animation:self.anibomb  startPosition:touchLocation endPosition:touchLocation enemyArr:[scroll junk_soldiers]];
    [scroll addChild: [newBomb bomb]];
    [newBomb drop:touchLocation];
}


- (void)launchmovingman: (CCNode *)sourcehouse dest:(CCNode *)desthouse lane_num:(int) lane_num {
    scroll=[_scrollview children][0];
    if( man == NULL ){
        return;
    }
    [self removeChild: [man soldier]];
    
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    
    // Avoid the physic confliction with the new born enemy
    CGPoint destination = CGPointMake(desthouse.position.x-20, desthouse.position.y);
    if( [selected_soldier  isEqual: @"potatoMan"] ){
        int potatoLevel = [[soldierLevelDict objectForKey:@"potato"] intValue];
        PotatoMan *newSoldier = [[PotatoMan alloc] initPotato: lane_num
                                                  startPos:sourcehouse.position
                                                   destPos: destination
                                                    ourArr:[scroll healthy_soldiers]
                                                  enemyArr:[scroll junk_soldiers]
                                 level:potatoLevel];
        [scroll addChild: [newSoldier soldier]];
        [newSoldier move];
    } else if( [selected_soldier  isEqual: @"bean"]  ){
        BeanMan *newSoldier = [[BeanMan alloc] initBean: lane_num
                                               startPos:sourcehouse.position
                                               destPos: destination
                                               ourArr:[scroll healthy_soldiers]
                                               enemyArr:[scroll junk_soldiers]
                               level:[[soldierLevelDict objectForKey:selected_soldier] intValue]];
        [scroll addChild: [newSoldier soldier]];
        [newSoldier move];
    } else if( [selected_soldier  isEqual: @"banana"]  ){
        BananaMan *newSoldier = [[BananaMan alloc] initBanana: lane_num
                                                   startPos:sourcehouse.position
                                                   destPos: destination
                                                   ourArr:[scroll healthy_soldiers]
                                                   enemyArr:[scroll junk_soldiers]
                                 level:[[soldierLevelDict objectForKey:selected_soldier] intValue]];
        [scroll addChild: [newSoldier soldier]];
        [newSoldier move];
    } else if( [selected_soldier  isEqual: @"corn"]  ){
        CornMan *newSoldier = [[CornMan alloc] initCorn: lane_num
                                                     startPos:sourcehouse.position
                                                      destPos: destination
                                                       ourArr:[scroll healthy_soldiers]
                                                     enemyArr:[scroll junk_soldiers]
                                            level:[[soldierLevelDict objectForKey:selected_soldier] intValue]];
        [scroll addChild: [newSoldier soldier]];
        [newSoldier move];
    }
}

- (void)addBombExplosion:(CGPoint) posi{
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explode"];
    explosion.autoRemoveOnFinish = YES;
    explosion.position = posi;
    [self addChild:explosion];
    return;
}

@end
