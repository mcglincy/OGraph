//
//  HeuristicManhattan.m
//  Thorn
//
//  Created by Matthew McGlincy on 5/5/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "HeuristicManhattan.h"
#import "NavGraphNode.h"

@implementation HeuristicManhattan

- (double)calculateWithNodeA:(GraphNode *)a b:(GraphNode *)b {
    // TODO: this is a crappy and potentially dangerous downcast.
    // TODO: come up with a better way to handle this.
    NavGraphNode *node1 = (NavGraphNode *)a;
    NavGraphNode *node2 = (NavGraphNode *)b;
    
    // calculate manhattan distance
    NSInteger deltaX = node2.position.x - node1.position.x;
    NSInteger deltaY = node2.position.y - node1.position.y;
    double dist = abs(deltaX) + abs(deltaY);
    return dist;
}

@end
