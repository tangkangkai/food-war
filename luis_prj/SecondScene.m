//
//  SecondScene.m
//  FireArm
//
//  Created by Luis Perez Cruz on 9/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SecondScene.h"
#import "CCDragSprite.h"

@implementation SecondScene
{
    CCPhysicsNode *_physicsNode;
    CCDragSprite *_gun;
}

int a = 0;
bool mv = false;

    // it is called when ccb has completed loading.
- (void)didLoadFromCCB
{
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    self.multipleTouchEnabled = TRUE;
}


-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    a++;
   
    
    CGPoint touchLocation = [touch locationInNode:_physicsNode];
    
    if((a >= 2) && (CGRectContainsPoint(_gun.boundingBox, touchLocation)))
    {
        mv = true;
        [self launchBullet];
    }
    
   
    
    
    
    // [self launchBullet];
    
//    for(UITouch *touches in touch)
//    {
//        
//    }
    
//    NSUInteger numTaps = [[touches anyObject] tapCount];
//    
//    if(numTaps > 1)
//    {
//        [self launchBullet];
//    }
    
    //CGPoint touchLocation = [touch locationInNode:_physicsNode];
    
    
   // _gun = [CCDragSprite spriteWithImageNamed:@"FireArmAssets/resources-phone/gun.png"];
    
    // [_physicsNode addChild:_gun];
    //_gun.position = touchLocation;
    
    
   // if(CG)
    
    // [self launchBullet];
    
    // Gets the location of our touch.
   // CGPoint touchLocation = [touch locationInNode:self];
    
   // if(CGPointEqualToPoint(_gun.position, touchLocation))
    //{
//        CCNode *_bullet = [CCBReader load:@"Bullet"];
//        
//        // position the penguin at the bowl of the catapult
//    _bullet.position = ccpAdd(_gun.position, _gun.position);
//    
//        // add the penguin to the physicsNode of this scene (because it has physics enabled)
//        [_physicsNode addChild:_bullet];
//        
//        // manually create & apply a force to launch the penguin
//        CGPoint launchDirection = ccp(1, 0);
//        CGPoint force = ccpMult(launchDirection, 800);
//        [_bullet.physicsBody applyForce:force];

}





- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // mv = false;
//    NSUInteger numTaps=[[touch anyObject] tapCount];
//   
//    if([touch count] == 2)
//    {
//        
//    }
//    
//    if([touchArray count] > 1)
//    {
//        [_physicsNode launchBullet];
//    }
    
   // else
   // {
        CGPoint touchLocation = [touch locationInNode:self];
        _gun.position = touchLocation;
    //}
    a = 0;
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
   // _gun = nil;
  //  a = 0;
    
    //if(a == 2)
      //  a = 0;
    
    
}
- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // _gun = nil;
    //a = 0;
  //  if(a == 2)
    //    a = 0;
}

-(void) launchBullet
{
    CCNode *_bullet = [CCBReader load:@"Bullet1"];
    
    // position the penguin at the bowl of the catapult
    _bullet.position = ccpAdd(_gun.position, ccp(24,7));
    
    // add the penguin to the physicsNode of this scene (because it has physics enabled)
    [_physicsNode addChild:_bullet];
    
    // manually create & apply a force to launch the penguin
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [_bullet.physicsBody applyForce:force];
    
    
}


   // }
//
//
////    UITouch *touch = [touches anyObject];
////    CGPoint positionInScene = [touch locationInNode:self];
////    [self selectNodeForTouch:positionInScene];
//}

//- (void)selectNodeForTouch:(CGPoint)touchLocation
//{
//    
//    SKSpriteNode *touchedNode = (SKSpriteNode *)[[self nodeAtPoint:touchLocation];
//    
//    //2
//    if(![_selectedNode isEqual:touchedNode]) {
//        [_selectedNode removeAllActions];
//        [_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
//        
//        _selectedNode = touchedNode;
//        //3
//        if([[touchedNode name] isEqualToString:kAnimalNodeName]) {
//            SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
//                                                      [SKAction rotateByAngle:0.0 duration:0.1],
//                                                      [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
//            [_selectedNode runAction:[SKAction repeatActionForever:sequence]];
//        }
//    }
//    
//}

@end
