//
//  GraphNode.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "GraphConstants.h"
#import "GraphNode.h"


@implementation GraphNode

@synthesize index;

- (id)init {
    return [self initWithIndex:kInvalidNodeIndex];
}

- (id)initWithIndex:(NSUInteger)anIndex {
    self = [super init];
    if (self) {
        index = anIndex;
    }
    return self;
}

@end
