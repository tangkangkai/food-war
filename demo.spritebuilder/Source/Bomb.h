//
//  Bomb.h
//  demo
//
//  Created by Yaning Wu on 10/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

@interface Bomb : CCNode {
    
}

@property CCSprite* bomb;
@property CGPoint startPosi;
@property CGPoint destPosi;
@property int power;
@property NSMutableArray* enemies;


-(void)drop:(CGPoint)start;

-(id)initBomb:(NSString*) img
              animation:(CCSprite*)ani
              startPosition:(CGPoint) start
              endPosition:(CGPoint) end
              enemyArr:(NSMutableArray*) enemyArray;
@end