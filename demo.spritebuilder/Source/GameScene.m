//
//  GameScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Level.h"

static GameScene* GameSceneInstance;

@implementation GameScene {
    CCScrollView *_selectscroll;
    CGPoint page1;
    CGPoint page2;
    CGPoint page3;
    CCNodeColor* _level1;
    CCNodeColor* _level2;
    CCNodeColor* _level3;
}

+(GameScene*)shareLayer{
    return GameSceneInstance;
}

-(id) init
{
    if( (self=[super init])) {
        GameSceneInstance=self;
        page1=CGPointMake(0, 0);
        page2=CGPointMake(524, 0);
        page3=CGPointMake(1032, 0);
    }

    return self;
}

- (void)didLoadFromCCB {
    _selectscroll.delegate = self;
   // self.userInteractionEnabled = TRUE;

    if ([[Levels getSelectedLevel] getLevel]==1) {
        [_selectscroll setScrollPosition:page1];
        NSLog(@"2");
    }
    if ([[Levels getSelectedLevel] getLevel]==2) {
        [_selectscroll setScrollPosition:page2];
        NSLog(@"2");
    }
    if ([[Levels getSelectedLevel] getLevel]==3) {
        [_selectscroll setScrollPosition:page3];
        NSLog(@"3");
    }
    if ([[Levels getSelectedLevel] getLevel]==Nil) {
        NSLog(@"nil");
    }
    [self setNodes];
}

- (void) setNodes {
    float x=[_selectscroll scrollPosition].x;
    if (x<250) {
        _level1.opacity=1;
        _level2.opacity=0.5;
        _level3.opacity=0.5;
    }
    if (x>=250&&x<774) {
        _level1.opacity=0.5;
        _level2.opacity=1;
        _level3.opacity=0.5;
    }
    if (x>=774) {
        _level1.opacity=0.5;
        _level2.opacity=0.5;
        _level3.opacity=1;
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    NSLog(@"running");
 //   [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
  //  [self performSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withObject:[_selectscroll:NO] afterDelay:0.5];
 //   [self performSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withObject:_selectscroll];
  
    
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
 
    //[self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
    [self setNodes];

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"stop animation");

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //CCActionMoveTo *move;
    float x=[_selectscroll scrollPosition].x;

    
    if(x<250){
        NSLog(@"level 1 scroll x:%f",x);
        NSLog(@"position ccp(%f,0)",-x);
      //  move = [CCActionMoveTo actionWithDuration:0.5f position:page1];
        [_selectscroll setScrollPosition:page1];
    }
    if (x>=250&&x<774) {
        NSLog(@"level 2 scroll x:%f",x);
        NSLog(@"position ccp(%f,0)",524-x);
     //   move = [CCActionMoveTo actionWithDuration:0.5f position:page2];
        [_selectscroll setScrollPosition:page2];
    }
    if (x>=774) {
        NSLog(@"level 3 scroll x:%f",x);
        NSLog(@"position ccp(%f,0)",1023-x);
       // move = [CCActionMoveTo actionWithDuration:0.5f position:page3];
        [_selectscroll setScrollPosition:page3];
    }
}
/*

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    decelerate=NO;
    CCActionMoveTo *move;
    float x=[_selectscroll scrollPosition].x;
    CGPoint page1=CGPointMake(0, 0);
    CGPoint page2=CGPointMake(524, 0);
    CGPoint page3=CGPointMake(1032, 0);
    
    if(x<250){
        move = [CCActionMoveBy actionWithDuration:0.5f position:ccp(-x,0)];
    }
    if (x>=250&&x<774) {
        move = [CCActionMoveBy actionWithDuration:0.5f position:ccp(524-x,0)];
    }
    if (x>=774) {
        move = [CCActionMoveBy actionWithDuration:0.5f position:ccp(1023-x,0)];
    }
    [_selectscroll runAction:move];

}
*/

/*
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    NSLog(@"running");

}
*/



- (void) back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionRight duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:trans];
}



@end
