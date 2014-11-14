//
//  Energy.m
//  demo
//
//  Created by dqlkx on 11/13/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Energy.h"


@implementation Energy{
    
}



-(id)initEnergy:(int) value pos:(CGPoint) position bgNode:(CCNode*)bgNode
{
    _deadBody=[CCBReader load:@"energy"];
    _deadBody.position=position;
    [bgNode addChild:_deadBody];
    _engergyValue=value;
    return self;
}

-(CCNode*)getDeadBody{
    return _deadBody;
}

-(void) move{

}

@end