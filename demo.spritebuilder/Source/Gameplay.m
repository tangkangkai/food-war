
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
    
    
    int mTimeInSec;
    int timeFlag;
    CCSprite *_first;
    CCSprite *_second;
    CCSprite *_third;
    CCSprite *_fourth;
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
    // tell this scene to accept touches
    scroll=[_scrollview children][0];
    // _energyPrompt opacity set to 0
    _energyPrompt.opacity = 0;
    _bombPrompt.opacity = 0;
    
    
    
    _scrollview.delegate = self;
    self.userInteractionEnabled = TRUE;
    mTimeInSec = [[Levels getSelectedLevel] time];                              //intialize timer
    timeFlag = 0;
    energyArray = [[NSMutableArray alloc] init];
    itArray = [[NSMutableArray alloc] init];
    [self schedule:@selector(tick) interval:1.0f];
    [self schedule:@selector(updateEnergy) interval:0.01f];
    //   [self schedule:@selector(collectEnergy) interval:0.1f];
    _audioIsOn = [SavedData audio];
    if (_audioIsOn) {
        [audio playBg:@"playBackground.mp3" loop:TRUE];
    } else {
        _musicoff.visible = TRUE;
        [audio playBg:@"playBackground.mp3" volume:0 pan:0 loop:TRUE];
        
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
    [scroll cleanup];
}

//-(void)updateMoney{
//    [_money setString:[NSString stringWithFormat:@"$ %d", [SavedData money]]];
//}

-(void)reduceEnergy:(int) amount {
    energy -= amount;
}

+(void)addEnergy:(int) amount {
    energy += amount;
}

+ (NSMutableArray*) getItArray{
    return itArray;
}

-(void)updateEnergy{
    [_energy setString:[NSString stringWithFormat:@"%d", energy]];
    //update bomb number as well
    [_bombnumber setString:[NSString stringWithFormat:@"%d", bombnumber]];
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
        [self updateEnergy];
        
        
        // check if energy is enough
        for (int i = (int)keys.count; i < spots.count; i++) {
        }
        
        // check if energy for bomb is enough
        
        
        
        
    } else if(timeFlag == 1 ){
        timeFlag = 2;
        [self gameover];
        
    } else{
        //do nothing
    }
}


// interface for bomb
- (void) addBombNumber {
    bombnumber++;
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
        [audio playBg:@"playBackground.mp3" volume:1 pan:0 loop:TRUE];
    }
    else
    {
        _audioIsOn = FALSE;
        [SavedData setAudio:FALSE];
        // _musicon.visible = FALSE;
        _musicoff.visible = TRUE;
        [audio playBg:@"playBackground.mp3" volume:0 pan:0 loop:TRUE];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"Button Index =%ld of tag %ld",(long)buttonIndex, (long)[alertView tag]);
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
            NSLog(@"currLevel:%d, maxLevel:%d", currLevel, [SavedData level]);
            if (currLevel != 3 && currLevel == [SavedData level]) {
                NSLog(@"===");
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
        NSLog(@"You have clicked Quit Game");
        [[CCDirector sharedDirector] resume];
        CCScene *choiceScene = [CCBReader loadAsScene:@"GameScene"];
        CCTransition *trans = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f];
        [[CCDirector sharedDirector] replaceScene:choiceScene withTransition:trans];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    int soldierLevel = 0;
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
            [self showBombMessage];
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
        CCSprite* title = [CCSprite spriteWithSpriteFrame:bombFrame];
        self.anibomb = title;
        self.anibomb.position = touchLocation;
        
        self.flashAction = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:flashAnim]];
        
        [self.anibomb runAction:self.flashAction];
        [spriteSheet addChild:self.anibomb];
        
        //bombRing
        CCSpriteFrame* bombRingFrame = [CCSpriteFrame frameWithImageNamed:@"bombRing.png"];
        bombRing = [CCSprite spriteWithSpriteFrame:bombRingFrame];
        bombRing.position = CGPointMake(touchLocation.x, touchLocation.y - 90);
        [self addChild:bombRing];
        
        
        return;
    } else if(CGRectContainsPoint(_iceBucket.boundingBox,touchLocation)){
        NSLog(@"IceBucket Clicked");
        selected_soldier = @"iceBucket";
        selected_soldier_animation=@"iceBucket";
        CCSpriteFrame* bucketFrame = [CCSpriteFrame frameWithImageNamed:@"iceBucket.png"];
        _aniIceBucket = [CCSprite spriteWithSpriteFrame:bucketFrame];
//        _aniIceBucket = (CCSprite*)[CCBReader load:@"iceBucket"];
        [self addChild:_aniIceBucket];
        return;
    }
    
    selected_soldier = soldier;
    selected_soldier_animation = soldier;
    soldierLevel = [[soldierLevelDict objectForKey:soldier] intValue];
    
    if (selected_soldier != NULL){
        // TODO Temperoray fix
        if( 75 + 25 * soldierLevel <= energy ){
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
        } else {
            [self showEnergyMessage];
        }
    }
}

-(void) showEnergyMessage {
    CCActionFadeTo* fadeIn = [CCActionFadeTo actionWithDuration:0.1f opacity:255];
    CCActionMoveTo *moveDown = [CCActionMoveTo actionWithDuration:0.4f position:ccp(120, 250)];
    
    CCActionFadeTo* fadeOut = [CCActionFadeTo actionWithDuration:0.2f opacity:0];
    CCActionMoveTo* moveBack = [CCActionMoveTo actionWithDuration:0.1f position:ccp(120, 270)];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveDown, fadeOut, moveBack]];
    [_energyPrompt runAction:sequence];
}

-(void) showBombMessage {
    CCActionFadeTo* fadeIn = [CCActionFadeTo actionWithDuration:0.1f opacity:255];
    CCActionMoveTo *moveUp = [CCActionMoveTo actionWithDuration:0.2f position:ccp(507, 70)];
    
    CCActionFadeTo* fadeOut = [CCActionFadeTo actionWithDuration:0.2f opacity:0];
    CCActionMoveTo* moveBack = [CCActionMoveTo actionWithDuration:0.1f position:ccp(507, 55)];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[fadeIn, moveUp, fadeOut, moveBack]];
    [_bombPrompt runAction:sequence];
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
        NSLog(@"iceBucketMoved");
        _aniIceBucket.position = touchLocation;
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
    NSLog(@"touch end");
    
    scroll=[_scrollview children][0];
    CGPoint touchLocation = [touch locationInNode:self];
    int laneNum = [[Levels getSelectedLevel] laneNum];
    
    if([selected_soldier_animation isEqualToString:@"blackBomb"]) {
        NSLog(@"release BOMB!");
        [self removeChild: bombRing];
        bombnumber--;
        CGPoint scrollPos = CGPointMake([_scrollview scrollPosition].x+touchLocation.x, touchLocation.y);
        [self launchBomb:scrollPos];
        if (_audioIsOn) {
            [audio playEffect:@"missle_launch.mp3"];
        }
    } else if([selected_soldier isEqualToString:@"iceBucket"]){
        NSLog(@"release Bucket!");
        
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
        [self removeChild:[man soldier]];
    }
    
    
    man = NULL;
    selected_soldier = NULL;
    [scroll showTrack:0];
    
}

- (void) cooldown:(int) num {
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
        [self schedule:@selector(update1) interval:0.9];
    }
    else if (num==2&&lock2==0){
        lock2=1;
        x2=1;
        [_cooldown2 setVisible:1];
        [_cooldown2 setContentSize:CGSizeMake(100, 100)];
        [self schedule:@selector(update2) interval:1.1];
    }
    else if (num==3&&lock3==0){
        lock3=1;
        x3=1;
        [_cooldown3 setVisible:1];
        [_cooldown3 setContentSize:CGSizeMake(100, 100)];
        [self schedule:@selector(update3) interval:1.5];
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
    
    [_aniIceBucket removeFromParent];
    
    if(touchLocation.y < 70)
        return;
    Bomb *newBomb = [[Bomb alloc] initBomb:@"blackBomb" animation:self.anibomb startPosition:touchLocation endPosition:touchLocation enemyArr:[scroll junk_soldiers] flyingItemsArray:_flyingItems];
    [scroll addChild: [newBomb item]];
    [newBomb drop:touchLocation];
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
        [self reduceEnergy:[newSoldier getValue]];
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


-(void)itemAutoBuild {
    //    int type = arc4random_uniform(100) % 2;
    NSLog(@"autoBuilding items!!!!");
    int type = 0;
    int x = arc4random_uniform(300) + 100;
    CGPoint rndPosi = CGPointMake(x, 480);
    [self dropItem:type position:rndPosi];
    
}


- (void)dropItem: (int) type position: (CGPoint) location{
    
    if( type == 0 ){
        
//        CCSpriteFrame* itemFrame = [CCSpriteFrame frameWithImageNamed:@"parachuteBox.png"];
//        CCNode *flyingItem = [CCSprite spriteWithSpriteFrame:itemFrame];
        CCNode *flyingItem = [CCBReader load:@"parachuteBox"];
        Bomb *newBomb = [[Bomb alloc] initBomb:@"blackBomb" animation:flyingItem startPosition:location endPosition:location enemyArr:[scroll junk_soldiers] flyingItemsArray:itArray];
//        [self addChild: [newBomb item]];
        CGPoint scrollPos = CGPointMake([_scrollview scrollPosition].x+location.x, location.y);
        [scroll addChild:[newBomb item]];
        [newBomb fly2:location];
//        [_flyingItems addObject:newBomb];
        [itArray addObject:newBomb];
        
        CGRect boundingBox = flyingItem.boundingBox;
        NSLog(@"bounding width: %f", boundingBox.size.width);
        NSLog(@"bounding height: %f", boundingBox.size.height);
    }
}

@end