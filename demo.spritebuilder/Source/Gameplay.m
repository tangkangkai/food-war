
//  Gameplay.m
//  manmove
//
//  Created by dqlkx on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Soldier.h"
#import "Bomb.h"
#import "IceBucket.h"
#import "SavedData.h"
#import "Scrollback.h"
#import "CCAnimation.h"
#import <UIKit/UIKit.h>
#include <CCDirector.h>
#import "CCAction.h"
#import "Level.h"

#define BURGER 1;
#define COKE 2;
#define FRIES 3;


static int energy;
static BOOL _audioIsOn;
static NSMutableArray *itArray;

@implementation Gameplay{
    CCNode *_potatoMan;
    CCNode *_bananaMan;
    CCNode *_beanMan;
    CCNode *_blackBomb;
    CCNode *_iceBucket;
    CCScrollView *_scrollview;
    Scrollback *scroll;
    
    Soldier *man;           //save the final man
    Bomb *bomb;
    CCNode *bombRing;
    
    NSString *selected_soldier;
    NSString *selected_soldier_animation;
    
    CCLabelTTF *_timerLabel;
    CCLabelTTF *_gameoverLabel;
    //CCLabelTTF *_money;
    CCLabelTTF *_energy;
    
    CCTextField *_energyPrompt;
    CCTextField *_bombPrompt;
    CCTextField *_messagePrompt;
    
    
    int mTimeInSec;
    int timeFlag;
    CCSprite *_first;
    CCSprite *_second;
    CCSprite *_third;
    CCSprite *_fourth;
    CCNode *_firstCost;
    CCNode *_secondCost;
    CCNode *_thirdCost;
    CCNode *_fourthCost;
    NSMutableArray *lineupArray;
    NSMutableArray *spots;
    NSMutableArray* energyArray;
    NSArray *keys;
    
    OALSimpleAudio *audio;
    CCNode *_musicon;
    CCNode *_musicoff;
    
    //bomb number
    CCTextField *_bombnumber;
    int bombnumber;
    
    //ice bucket number
    CCTextField *_bucketnumber;
    int bucketnumber;
    
    
    int _soldiertype;
    CCNodeColor *_cooldown0;
    int x0;
    int lock0;
    
    CCNodeColor *_cooldown1;
    int x1;
    int lock1;
    
    CCNodeColor *_cooldown2;
    int x2;
    int lock2;
    
    CCNodeColor *_cooldown3;
    int x3;
    int lock3;
    
    int _iscooldown;
}

- (id)init{
    self = [super init];
    if (!self) return(nil);
    
    selected_soldier = NULL;
    man = NULL;
    
    audio = [OALSimpleAudio sharedInstance];
    return self;
}

- (void)didLoadFromCCB {
    //initiate energy
    energy = [[Levels getSelectedLevel] energy];
    //get bomb number
    bombnumber = 1;
    _soldiertype=-1;
    //get bucket number
    bucketnumber = 1;
    // tell this scene to accept touches
    scroll=[_scrollview children][0];
    // _energyPrompt opacity set to 0
    _messagePrompt.opacity = 0;
    
    
    _scrollview.delegate = self;
    self.userInteractionEnabled = TRUE;
    mTimeInSec = [[Levels getSelectedLevel] time];                              //intialize timer
    timeFlag = 0;
    _iscooldown=1;
    energyArray = [[NSMutableArray alloc] init];
    itArray = [[NSMutableArray alloc] init];
    [self schedule:@selector(tick) interval:1.0f];
    [self schedule:@selector(updateEnergy) interval:0.01f];
    //   [self schedule:@selector(collectEnergy) interval:0.1f];
    _audioIsOn = [SavedData audio];
    if (_audioIsOn) {
        [audio playBg:@"bgHp.mp3" loop:TRUE];
    } else {
        _musicoff.visible = TRUE;
        [audio playBg:@"bgHp.mp3" volume:0 pan:0 loop:TRUE];
        
    }
    
//    [self schedule:@selector(itemAutoBuild) interval:10];
}

- (void)onEnter {
    [super onEnter];
    
    
    
    //get the lineup soldier from dictionary and write to scene
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"healthy_food.plist"];
    CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableDictionary *soldiers = [SavedData lineupDictonary];
    spots = [[NSMutableArray alloc] init];
    lineupArray = [[NSMutableArray alloc] init];
    [spots addObject:_first];
    [spots addObject:_second];
    [spots addObject:_third];
    [spots addObject:_fourth];
    keys = [soldiers allKeys];
    for (int i = 0; i < (int)keys.count; i++) {
        CCSprite *spot = [spots objectAtIndex:i];
        NSString *soldier = [keys objectAtIndex:i];
        CCSpriteFrame* frame = [cache spriteFrameByName:[soldiers objectForKey:soldier]];
        spot.spriteFrame = frame;
        [lineupArray addObject:soldier];

        NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
        int level;
        if( [soldier isEqualToString:@"potatoMan"] ){
            level = [[soldierLevelDict objectForKey:@"potato"] intValue];
        }
        else{
            level = [[soldierLevelDict objectForKey:soldier] intValue];
        }
        int energyCost = [self getEnergy: soldier
                             soldier_lvl:level];
        [self updateEnergy:i energy:energyCost];
    }
    
    for (int i = (int)keys.count; i < spots.count; i++) {
        CCSprite *spot = [spots objectAtIndex:i];
        spot.spriteFrame = NULL;
    }
}

- (void)updateEnergy: (int)spot
                      energy: (int)energy{
    if( spot == 0){
        [[_firstCost children][0] setString:[NSString stringWithFormat:@"%d", energy]];
        [_firstCost setVisible:true];
    }
    if( spot == 1){
        [[_secondCost children][0] setString:[NSString stringWithFormat:@"%d", energy]];
        [_secondCost setVisible:true];
    }
    if( spot == 2){
        [[_thirdCost children][0] setString:[NSString stringWithFormat:@"%d", energy]];
        [_thirdCost setVisible:true];
    }
    if( spot == 3){
        [[_fourthCost children][0] setString:[NSString stringWithFormat:@"%d", energy]];
        [_fourthCost setVisible:true];

    }
}

-(void)onExit{
    [super onExit];
    [audio stopBg];
    [scroll cleanup];
}


-(void)reduceEnergy:(int) amount {
    energy -= amount;
}

+(void)addEnergy:(int) amount {
    energy += amount;
}

// interface for items
-(void)addItem:(int) item {
    if (item == 1) { // 1: add bomb number and its effect
        OALSimpleAudio *itemAudio = [OALSimpleAudio sharedInstance];
        [itemAudio playEffect:@"bell1.mp3"];
        bombnumber++;
    } else if (item == 2) { // 2: add ice bucket number and its effect
        OALSimpleAudio *itemAudio = [OALSimpleAudio sharedInstance];
        [itemAudio playEffect:@"bell1.mp3"];
        bucketnumber++;
    }
}


+ (NSMutableArray*) getItArray{
    return itArray;
}

-(void)updateEnergy{
    [_energy setString:[NSString stringWithFormat:@"%d", energy]];
    //update bomb number, bucket number as well
    [_bombnumber setString:[NSString stringWithFormat:@"%d", bombnumber]];
    [_bucketnumber setString:[NSString stringWithFormat:@"%d", bucketnumber]];
}

-(void)tick {
    energy++;
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
        [self updateEnergy];
        
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
    [audio stopBg];
}

- (void)win{
    NSString* promptStr = [NSString stringWithFormat:@"You win!\nYou get $%d rewards!", ([[Levels getSelectedLevel] getAward] + mTimeInSec + energy / 100) / 10];
    [[CCDirector sharedDirector] pause];
    //_gameoverLabel.string = [NSString stringWithFormat:@"You win"];
    UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:promptStr
                                                      message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles: nil];
    [alert setTag:2];
    [alert show];
    [audio stopBg];
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
    [audio stopBg];
    
    
}

- (void)voice {
    if (!_audioIsOn)
    {
        _audioIsOn = TRUE;
        [SavedData setAudio:TRUE];
        _musicoff.visible = FALSE;
        // _musicon.visible = TRUE;
        [audio playBg:@"bgHp.mp3" volume:1 pan:0 loop:TRUE];
    }
    else
    {
        _audioIsOn = FALSE;
        [SavedData setAudio:FALSE];
        // _musicon.visible = FALSE;
        _musicoff.visible = TRUE;
        [audio playBg:@"bgHp.mp3" volume:0 pan:0 loop:TRUE];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    long tag =[alertView tag];
    if (buttonIndex == 0) {
        if(tag == 1) {
            [audio playBg];
            [[CCDirector sharedDirector] resume];
        }
        else if(tag==2) {
            //add money due to the energy
            [SavedData addMoney:([[Levels getSelectedLevel] getAward] + mTimeInSec + energy / 100) / 10];
            [SavedData saveMoney];
            
            //set unlocked game level to the next level
            int currLevel = [[Levels getSelectedLevel] getLevel];
            if (currLevel != 3 && currLevel == [SavedData level]) {
                [SavedData setLevel:++currLevel];
                [SavedData saveLevel];
            }
            
            [[CCDirector sharedDirector] resume];
            [Levels setSelectedLevel:[[Levels getSelectedLevel] getLevel] + 1];
            CCScene *choiceScene = [CCBReader loadAsScene:@"GameScene"];
            CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
            [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
        }
        else {
            [[CCDirector sharedDirector] resume];
            CCScene *playScene = [CCBReader loadAsScene:@"ChoiceScene"];
            CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f];
            [[CCDirector sharedDirector] replaceScene:playScene withTransition:trans];
            
        }
    }
    else if(buttonIndex == 1) {
        [[CCDirector sharedDirector] resume];
        CCScene *choiceScene = [CCBReader loadAsScene:@"GameScene"];
        CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
        [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    int soldierLevel = 0;
    _anibomb = nil;
    bombRing = nil;
    NSString *soldier = NULL;
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    if (_first.spriteFrame!=NULL && CGRectContainsPoint(_first.boundingBox,touchLocation)) {
        if (lock0==0) {
            soldier = [lineupArray objectAtIndex:0];
            _soldiertype=0;
        }
    } else if (_second.spriteFrame!=NULL && CGRectContainsPoint(_second.boundingBox,touchLocation)) {
        if (lock1==0) {
            soldier = [lineupArray objectAtIndex:1];
            _soldiertype=1;
        }
    } else if (_third.spriteFrame!=NULL && CGRectContainsPoint(_third.boundingBox,touchLocation)) {
        if (lock2==0) {
            soldier = [lineupArray objectAtIndex:2];
            _soldiertype=2;
        }
        
    } else if (_third.spriteFrame!=NULL && CGRectContainsPoint(_fourth.boundingBox,touchLocation)) {
        if (lock3==0) {
            soldier = [lineupArray objectAtIndex:3];
            _soldiertype=3;
        }
    } else if(CGRectContainsPoint(_blackBomb.boundingBox,touchLocation)) {
        if (bombnumber < 1) {
            selected_soldier = NULL;
            selected_soldier_animation = NULL;
            [self showMessage:[NSString stringWithFormat:@"No Bomb"]];
            return;
        }
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
        //CCSprite* title = [CCSprite spriteWithSpriteFrame:bombFrame];
        _anibomb = [CCSprite spriteWithSpriteFrame:bombFrame];
        _anibomb.position = touchLocation;
        
        self.flashAction = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:flashAnim]];
        
        [_anibomb runAction:self.flashAction];
        [spriteSheet addChild:_anibomb];
        
        //bombRing
        CCSpriteFrame* bombRingFrame = [CCSpriteFrame frameWithImageNamed:@"bombRing.png"];
        bombRing = [CCSprite spriteWithSpriteFrame:bombRingFrame];
        bombRing.position = CGPointMake(touchLocation.x, touchLocation.y - 90);
        [self addChild:bombRing];
        
        
        return;
    } else if(CGRectContainsPoint(_iceBucket.boundingBox,touchLocation)){
        if (bucketnumber < 1) {
            selected_soldier = NULL;
            selected_soldier_animation = NULL;
            [self showMessage:[NSString stringWithFormat:@"No Ice Bucket"]];
            return;
        }
        selected_soldier = @"iceBucket";
        selected_soldier_animation=@"iceBucket";
        CCSpriteFrame* bucketFrame = [CCSpriteFrame frameWithImageNamed:@"iceBucket.png"];
        _anibomb = [CCSprite spriteWithSpriteFrame:bucketFrame];
//        _aniIceBucket = (CCSprite*)[CCBReader load:@"iceBucket"];
        _anibomb.position = CGPointMake(touchLocation.x, touchLocation.y);
        [self addChild:_anibomb];
        return;
    }
    
    selected_soldier = soldier;
    selected_soldier_animation = soldier;
    if( [soldier isEqualToString:@"potatoMan"] ){
        soldierLevel = [[soldierLevelDict objectForKey:@"potato"] intValue];
    }
    else{
        soldierLevel = [[soldierLevelDict objectForKey:soldier] intValue];
    }
    if (selected_soldier != NULL){
        int energyCost = [self getEnergy: selected_soldier
                                          soldier_lvl:soldierLevel];
        if( energyCost <= energy ){
            Soldier* newSolider = [[Soldier alloc] initSoldier:selected_soldier
                                                         group:-1
                                                      lane_num:-1
                                                      startPos:touchLocation
                                                       destPos:touchLocation
                                                        ourArr:NULL
                                                      enemyArr:NULL
                                                         level:soldierLevel
                                                        bgNode:self];
            man = newSolider;
            _iscooldown=1;
        } else {
            [self showMessage:[NSString stringWithFormat:@"No Energy"]];
            _iscooldown=0;
        }
    }
}

-(int) getEnergy:(NSString*) soldier
                 soldier_lvl:(int)lvl{
    int energyCost = 0;
    if( [soldier  isEqual: @"banana"]){
        energyCost = [BananaMan getEnergy: lvl];
    }
    if( [soldier  isEqual: @"bean"]){
        energyCost = [BeanMan getEnergy: lvl];
    }
    if( [soldier  isEqual: @"potatoMan"]){
        energyCost = [PotatoMan getEnergy: lvl];
    }
    if( [soldier  isEqual: @"corn"]){
        energyCost = [CornMan getEnergy: lvl];
    }
    return energyCost;
}

-(void) showMessage: (NSString*) message {
    _messagePrompt.string = message;
    CCActionFadeTo* fadeIn = [CCActionFadeTo actionWithDuration:0.1f opacity:255];
    CCActionMoveTo *moveDown = [CCActionMoveTo actionWithDuration:0.5f position:ccp(300, 288)];
    
    CCActionFadeTo* fadeOut = [CCActionFadeTo actionWithDuration:0.2f opacity:0];
    CCActionMoveTo* moveBack = [CCActionMoveTo actionWithDuration:0.1f position:ccp(200, 288)];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveDown, fadeOut, moveBack]];
    [_messagePrompt runAction:sequence];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    if([selected_soldier isEqualToString:@"blackBomb"]){
        _anibomb.position = touchLocation;
        bombRing.position = CGPointMake(touchLocation.x, touchLocation.y - 90);
        return;
    }
    if([selected_soldier isEqualToString:@"iceBucket"]){
        _anibomb.position = touchLocation;
        return;
    }
    if( man == NULL ){
        return;
    }
    [man soldier].position = touchLocation;
    int laneNum = [[Levels getSelectedLevel] laneNum];
    
    if( laneNum!=1 && CGRectContainsPoint(CGRectMake([scroll lane1].boundingBox.origin.x, [scroll lane1].boundingBox.origin.y+30, [scroll lane1].boundingBox.size.width, [scroll lane1].boundingBox.size.height),touchLocation)) {
        [scroll showTrack:1];
        
    } else if(CGRectContainsPoint(CGRectMake([scroll lane2].boundingBox.origin.x, [scroll lane2].boundingBox.origin.y+35, [scroll lane2].boundingBox.size.width, [scroll lane2].boundingBox.size.height),touchLocation)) {
        [scroll showTrack:2];
        
    } else if( laneNum==3 && CGRectContainsPoint(CGRectMake([scroll lane3].boundingBox.origin.x, [scroll lane3].boundingBox.origin.y+40, [scroll lane3].boundingBox.size.width, [scroll lane3].boundingBox.size.height),touchLocation)) {
        [scroll showTrack:3];
        
    } else {
        [scroll showTrack:0];
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    int laneNum = [[Levels getSelectedLevel] laneNum];
    
    if([selected_soldier_animation isEqualToString:@"blackBomb"] && touchLocation.y > 120) {
        [self removeChild: bombRing];
        bombnumber--;
        CGPoint scrollPos = CGPointMake([_scrollview scrollPosition].x+touchLocation.x, touchLocation.y);
        [self launchBomb:scrollPos];
        if (_audioIsOn) {
            [audio playEffect:@"missle_launch.mp3"];
            [self launchBomb:scrollPos];
        }
    } else if([selected_soldier isEqualToString:@"iceBucket"] && touchLocation.y > 120){
        bucketnumber--;
        CGPoint scrollPos = CGPointMake([_scrollview scrollPosition].x+touchLocation.x, touchLocation.y);
        [self launchBucket:scrollPos];
        
    } else if( laneNum!=1 &&  CGRectContainsPoint(CGRectMake([scroll lane1].boundingBox.origin.x, [scroll lane1].boundingBox.origin.y+30, [scroll lane1].boundingBox.size.width, [scroll lane1].boundingBox.size.height),touchLocation)) {
        [self launchmovingman:[scroll house1] dest:[scroll house4] lane_num:0];
        [self cooldown:_soldiertype];
    } else if( CGRectContainsPoint(CGRectMake([scroll lane2].boundingBox.origin.x, [scroll lane2].boundingBox.origin.y+35, [scroll lane2].boundingBox.size.width, [scroll lane2].boundingBox.size.height),touchLocation)) {
        [self launchmovingman: [scroll house2] dest:[scroll house5] lane_num:1];
        [self cooldown:_soldiertype];
    } else if( laneNum==3 && CGRectContainsPoint(CGRectMake([scroll lane3].boundingBox.origin.x, [scroll lane3].boundingBox.origin.y+40, [scroll track3].boundingBox.size.width, [scroll lane3].boundingBox.size.height),touchLocation)) {
        [self launchmovingman:[scroll house3] dest:[scroll house6] lane_num:2];
        [self cooldown:_soldiertype];
    } else {
        if( _anibomb != nil){
            [_anibomb removeFromParent];
            if( bombRing != nil)
                [self removeChild: bombRing];
        }
        if( man != nil){
            [self removeChild:[man soldier]];
        }
    }
    
    
    man = NULL;
    selected_soldier = NULL;
    [scroll showTrack:0];
    
}

- (void) cooldown:(int) num {
    if (_iscooldown==1) {
        if (num==0&&lock0==0) {
            lock0=1;
            x0=1;
            [_cooldown0 setVisible:1];
            [_cooldown0 setContentSize:CGSizeMake(100, 100)];
            [self schedule:@selector(update0) interval:0.7];
        }
        else if (num==1&&lock1==0){
            lock1=1;
            x1=1;
            [_cooldown1 setVisible:1];
            [_cooldown1 setContentSize:CGSizeMake(100, 100)];
            [self schedule:@selector(update1) interval:0.7];
        }
        else if (num==2&&lock2==0){
            lock2=1;
            x2=1;
            [_cooldown2 setVisible:1];
            [_cooldown2 setContentSize:CGSizeMake(100, 100)];
            [self schedule:@selector(update2) interval:0.7];
        }
        else if (num==3&&lock3==0){
            lock3=1;
            x3=1;
            [_cooldown3 setVisible:1];
            [_cooldown3 setContentSize:CGSizeMake(100, 100)];
            [self schedule:@selector(update3) interval:0.7];
        }
        _soldiertype=-1;
    }
    else{
        return;
    }
}

- (void) update0{
    int y=100-10*x0;
    [_cooldown0 setContentSize:CGSizeMake(100, y)];
    x0++;
    if (y==0) {
        [self unschedule:@selector(update0)];
      //  x0=0;
        lock0=0;
        [_cooldown0 setVisible:0];
        return;
    }
}

- (void) update1{
    int y=100-10*x1;
    [_cooldown1 setContentSize:CGSizeMake(100, y)];
    x1++;
    if (y==0) {
        [self unschedule:@selector(update1)];
       // x1=0;
        lock1=0;
        [_cooldown1 setVisible:0];
        return;
    }
}

- (void) update2{
    int y=100-10*x2;
    [_cooldown2 setContentSize:CGSizeMake(100, y)];
    x2++;
    if (y==0) {
        [self unschedule:@selector(update2)];
      //  x2=0;
        lock2=0;
        [_cooldown2 setVisible:0];
        return;
    }
}

- (void) update3{
    int y=100-10*x3;
    [_cooldown3 setContentSize:CGSizeMake(100, y)];
    x3++;
    if (y==0) {
        [self unschedule:@selector(update3)];
     //   x3=0;
        lock3=0;
        [_cooldown3 setVisible:0];
        return;
    }
}

- (void)launchBomb: (CGPoint)touchLocation {
    scroll=[_scrollview children][0];
    
    [self removeChild: [bomb item]];
    [_anibomb removeFromParent];

    if(touchLocation.y < 70)
        return;
    Bomb *newBomb = [[Bomb alloc] initBomb:@"blackBomb" animation:self.anibomb startPosition:touchLocation endPosition:touchLocation enemyArr:[scroll junk_soldiers] flyingItemsArray:_flyingItems];
    [scroll addChild: [newBomb item]];
    [newBomb drop:touchLocation];

}

- (void)launchBucket: (CGPoint)touchLocation {
    scroll=[_scrollview children][0];
    
    [_anibomb removeFromParent];

    if(touchLocation.y < 70)
        return;
    IceBucket *newBucket = [[IceBucket alloc] initIceBucket:@"iceBucket" animation:_anibomb startPosition:touchLocation endPosition:touchLocation enemyArr:[scroll junk_soldiers] flyingItemsArray:_flyingItems];
    [scroll addChild: [newBucket item]];
    [newBucket dropBucket];
}


- (void)launchmovingman: (CCNode *)sourcehouse dest:(CCNode *)desthouse lane_num:(int) lane_num {
    scroll=[_scrollview children][0];
    if( man == NULL ){
        return;
    }
    [self removeChild: [man soldier]];
    
    NSMutableDictionary *soldierLevelDict = [SavedData soldierLevel];
    Soldier *newSoldier = NULL;
    // Avoid the physic confliction with the new born enemy
    CGPoint destination = CGPointMake(desthouse.position.x-20, desthouse.position.y);
    if( [selected_soldier  isEqual: @"potatoMan"] ){
        int potatoLevel = [[soldierLevelDict objectForKey:@"potato"] intValue];
        newSoldier = [[PotatoMan alloc] initPotato: lane_num
                                          startPos:sourcehouse.position
                                           destPos: destination
                                            ourArr:[scroll healthy_soldiers]
                                          enemyArr:[scroll junk_soldiers]
                                             level:potatoLevel
                                            bgNode:scroll];
        [newSoldier move];
    } else if( [selected_soldier  isEqual: @"bean"]  ){
        newSoldier = [[BeanMan alloc] initBean: lane_num
                                      startPos:sourcehouse.position
                                       destPos: destination
                                        ourArr:[scroll healthy_soldiers]
                                      enemyArr:[scroll junk_soldiers]
                                         level:[[soldierLevelDict objectForKey:selected_soldier] intValue]
                                        bgNode:scroll];
        [newSoldier move];
    } else if( [selected_soldier  isEqual: @"banana"]  ){
        newSoldier = [[BananaMan alloc] initBanana: lane_num
                                          startPos:[sourcehouse position]
                                           destPos: destination
                                            ourArr:[scroll healthy_soldiers]
                                          enemyArr:[scroll junk_soldiers]
                                             level:[[soldierLevelDict objectForKey:selected_soldier] intValue]
                                            bgNode:scroll];
        
    } else if( [selected_soldier  isEqual: @"corn"]  ){
        newSoldier = [[CornMan alloc] initCorn: lane_num
                                      startPos:sourcehouse.position
                                       destPos: destination
                                        ourArr:[scroll healthy_soldiers]
                                      enemyArr:[scroll junk_soldiers]
                                         level:[[soldierLevelDict objectForKey:selected_soldier] intValue]
                                        bgNode:scroll];
        
    }
    if (newSoldier != NULL) {
        [newSoldier move];
        
        if (_audioIsOn) {
            [audio playEffect:@"blop.mp3"];
        }
        [self reduceEnergy:[newSoldier getEnergy]];
    }
}

- (void)addBombExplosion:(CGPoint) posi{
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"explode"];
    explosion.autoRemoveOnFinish = YES;
    explosion.position = posi;
    [self addChild:explosion];
    return;
}

-(void) collectEnergy{
    energyArray=[Scrollback getEnergyArray];
    if (energyArray==nil) {
        return;
    }
    
    for (CCNode* energy in energyArray) {
        CCActionMoveTo *collectEnergy = [CCActionMoveTo actionWithDuration:1.0f position:[_energyIcon position]];
        [energy runAction:collectEnergy];
    }
}


-(void)itemAutoBuild:(int) itemType {
    //    int type = arc4random_uniform(100) % 2;
    int x = arc4random_uniform(300) + 100;
    CGPoint rndPosi = CGPointMake(x, 480);
    [self dropItem:itemType position:rndPosi];
    
}


- (void)dropItem: (int) type position: (CGPoint) location{
    
    if( type == 1 ){
        
        CCNode *flyingItem = [CCBReader load:@"parachuteBox"];
        Bomb *newBomb = [[Bomb alloc] initBomb:@"blackBomb" animation:flyingItem startPosition:location endPosition:location enemyArr:[scroll junk_soldiers] flyingItemsArray:itArray];
        CGPoint scrollPos = CGPointMake([_scrollview scrollPosition].x+location.x, location.y);
        [scroll addChild:[newBomb item]];
        [newBomb fly2:location];
        [itArray addObject:newBomb];
        
        CGRect boundingBox = flyingItem.boundingBox;
    } else {
        CCNode *flyingItem = [CCBReader load:@"parachuteBox"];
        IceBucket *newBucket = [[IceBucket alloc] initIceBucket:@"iceBucket" animation:flyingItem startPosition:location endPosition:location enemyArr:[scroll junk_soldiers] flyingItemsArray:itArray];
        
        CGPoint scrollPos = CGPointMake([_scrollview scrollPosition].x+location.x, location.y);
        [scroll addChild:[newBucket item]];
        [newBucket fly2:location];

        [itArray addObject:newBucket];
        
        CGRect boundingBox = flyingItem.boundingBox;
    }
}

@end