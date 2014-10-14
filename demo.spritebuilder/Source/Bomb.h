//
//  Bomb.h
//  demo
//
//  Created by Yaning Wu on 10/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

@interface Bomb : CCNode {
    
}

@property CCNode* bomb;
@property CGPoint startPosi;
@property CGPoint destPosi;
@property int power;

-(void)drop:(CGPoint)start;

-(id)initBomb:(NSString*) img startPosition:(CGPoint) start endPosition:(CGPoint) end;
@end