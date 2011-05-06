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

- (double)calculateWithNodeA:(GraphNode *)a b:(GraphNode *)b {
    // TODO: the original C++ Heuristic hierarchy takes advantage
    // of templates for the SparseGraph's node type, to allow proper
    // type safety.
    // We don't have templates, do just dynamically check the type
    // of the nodes we're given.
    
    // TODO: commenting this out until we decide how much
    // safety-checking we want, if any.
//    if (![a isKindOfClass:[NavGraphNode class]] || 
//        ![b isKindOfClass:[NavGraphNode class]]) {
//        // not NavGraphNodes, so just return 0.
//        // This effectively makes A* into Dijkstra's.
//        return 0.0;
//    }
        
    // now that we know we have NavGraphNodes, downcast.
    NavGraphNode *ngnA = (NavGraphNode *)a;
    NavGraphNode *ngnB = (NavGraphNode *)b;
    
    // use the pythagorean theorem to calculate distance
    CGFloat deltaX = ngnB.position.x - ngnA.position.x;
    CGFloat deltaY = ngnB.position.y - ngnB.position.y;
    double dist = sqrt((deltaX * deltaX) + (deltaY * deltaY));
    return dist;
}

@end
