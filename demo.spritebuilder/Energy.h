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

-(id)initEnergy:(int) value pos:(CGPoint) position bgNode:(CCNode*)bgNode;
-(CCNode*)getDeadBody;
@end
