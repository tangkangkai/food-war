//
//  Energy.h
//  demo
//
//  Created by dqlkx on 11/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Energy : CCNode {
    
}

@property int engergyValue;
@property CCNode* deadBody;
@property int touch;

-(id)initEnergy:(int) value pos:(CGPoint) position bgNode:(CCNode*)bgNode;
-(CCNode*)getDeadBody;
-(void) collect:(CCNode*)Icon Gameplay:(CCScrollView*)c;
-(void) arrive;
-(void) disappear;
-(void) setTouch;
@end
