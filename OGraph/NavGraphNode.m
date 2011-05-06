//
//  NavGraphNode.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "NavGraphNode.h"


@implementation NavGraphNode

@synthesize position;

- (id)initWithIndex:(NSUInteger)anIndex position:(CGPoint)aPosition {
    self = [super initWithIndex:anIndex];
    if (self) {
        position = aPosition;
    }
    return self;
}

@end
