//
//  GameScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"

static GameScene* GameSceneInstance;

@implementation GameScene {
    CCScrollView *_selectscroll;
}

+(GameScene*)shareLayer{
    return GameSceneInstance;
}

-(id) init
{
    if( (self=[super init])) {
        GameSceneInstance=self;
    }
    return self;
}

- (void)didLoadFromCCB {
    _selectscroll.delegate = self;
   // self.userInteractionEnabled = TRUE;
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withObject:nil afterDelay:0.5];
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    float x=[_selectscroll scrollPosition].x;
    CGPoint page1=CGPointMake(0, 0);
    CGPoint page2=CGPointMake(524, 0);
    CGPoint page3=CGPointMake(1032, 0);
    
    if(x<250){
        [_selectscroll setScrollPosition:page1];
    }
    if (x>=250&&x<774) {
        [_selectscroll setScrollPosition:page2];
    }
    if (x>=774) {
        [_selectscroll setScrollPosition:page3];
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    decelerate=NO;
    float x=[_selectscroll scrollPosition].x;
    CGPoint page1=CGPointMake(0, 0);
    CGPoint page2=CGPointMake(524, 0);
    CGPoint page3=CGPointMake(1032, 0);
    
    if(x<250){
        [_selectscroll setScrollPosition:page1];
    }
    if (x>=250&&x<774) {
        [_selectscroll setScrollPosition:page2];
    }
    if (x>=774) {
        [_selectscroll setScrollPosition:page3];
    }


}

- (void) back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionRight duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:trans];
}



@end
