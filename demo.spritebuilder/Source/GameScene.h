//
//  GameScene.h
//  demo
//
//  Created by Kangkai Tang on 9/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameScene : CCNode

+(GameScene*)shareLayer;
@property CCTextField *text;

@end
