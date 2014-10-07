//
//  GameScene.m
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "SavedData.h"
#import "Selectscroll.h"

static GameScene* GameSceneInstance;

@implementation GameScene {
    //CCTextField *_text;
   // NSMutableArray *levelArray;
 //   BOOL ifLocked;
    
}

+(GameScene*)sharelayer{
    return GameSceneInstance;
}

-(id) init
{
    if( (self=[super init])) {
        GameSceneInstance=self;
    //    Selectscroll* sl=[[Selectscroll alloc] init];
     //   [self addChild:sl z:100];
    }
    return self;
}

/*
- (void) didLoadFromCCB {
    NSLog(@"Enter Game Level Scene");
    self.userInteractionEnabled = TRUE;
    if ([SavedData level]) {
        _text.string = [NSString stringWithFormat:@"Level %d", [SavedData level]];
    } else {
        _text.string = @"Please choose your level";
    }
    levelArray = [SavedData levelArray];
}

*/
- (void) back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionRight duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:trans];
}

/*
- (void) store {
    CCScene *storeScene = [CCBReader loadAsScene:@"StoreScene"];
    CCTransition *trans = [CCTransition transitionPushWithDirection: CCTransitionDirectionUp duration:0.5f];
    [[CCDirector sharedDirector] replaceScene:storeScene withTransition:trans];
}
*/


/*
- (void)level1 {
    NSLog(@"level1 button");
    [self changeLevel:1];
}

- (void)level2 {
    NSLog(@"level2 button");
    [self changeLevel:2];
}

- (void)level3 {
    NSLog(@"level3 button");
    [self changeLevel:3];
    
}

- (void)level4 {
    NSLog(@"level4 button");
    [self changeLevel:4];
}
*/


@end
