//
//  GraphEdge.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "GraphEdge.h"
#import "GraphConstants.h"

@implementation GraphEdge

@synthesize from, to, cost;

- (id)init {
    return [self initWithFrom:kInvalidNodeIndex to:kInvalidNodeIndex cost:kDefaultEdgeCost];
}

- (id)initWithFrom:(NSUInteger)aFrom to:(NSUInteger)aTo {
    return [self initWithFrom:aFrom to:aTo cost:kDefaultEdgeCost];
}

- (id)initWithFrom:(NSUInteger)aFrom to:(NSUInteger)aTo cost:(double)aCost {
    self = [super init];
    if (self) {
        from = aFrom;
        to = aTo;
        cost = aCost;
    }
    return self;
}

@end
