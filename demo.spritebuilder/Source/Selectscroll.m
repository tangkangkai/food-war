//
//  Selectscroll.m
//  demo
//
//  Created by dqlkx on 10/7/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Selectscroll.h"
#import "GameScene.h"

@implementation Selectscroll


- (void)level1 {
    NSLog(@"level1 button");
    GameScene *a=[GameScene sharelayer];
    a.text.string = @"Level Locked, please choose again";
    NSLog(@"text is : %@",a.text);
    
}

- (void)level2 {
    NSLog(@"level2 button");
    
}

- (void)level3 {
    NSLog(@"level3 button");
    
    
}

@end
