//
//  HeuristicEuclid.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "HeuristicEuclid.h"
#import "NavGraphNode.h"
#import "SparseGraph.h"

@implementation HeuristicEuclid

- (double)calculateWithGraph:(SparseGraph *)graph node1Index:(NSUInteger)node1Index node2Index:(NSUInteger)node2Index {
    // TODO: this is a crappy and potentially dangerous downcast.
    // TODO: come up with a better way to handle this.
    // The original code is C++ and uses templates.
    NavGraphNode *node1 = (NavGraphNode *)[graph getNodeWithIndex:node1Index];
    NavGraphNode *node2 = (NavGraphNode *)[graph getNodeWithIndex:node2Index];
    
    // use the pythagorean theorem
    CGFloat deltaX = node2.position.x - node1.position.x;
    CGFloat deltaY = node2.position.y - node1.position.y;
    double dist = sqrt((deltaX * deltaX) + (deltaY * deltaY));
    return dist;
}

@end
