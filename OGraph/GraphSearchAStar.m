//
//  GraphSearchAStar.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "GraphEdge.h"
#import "GraphNode.h"
#import "GraphSearchAStar.h"
#import "Heuristic.h"
#import "IndexedPriorityQLow.h"
#import "SparseGraph.h"

static NSNull *kNull;

@interface GraphSearchAStar() 
- (void)search;
@end

@implementation GraphSearchAStar


@synthesize graph;

+ (void)initialize {
    static bool initialized = FALSE;
    if (!initialized) {
        kNull = [NSNull null];
    }
}

- (id)initWithGraph:(SparseGraph *)aGraph
    sourceNodeIndex:(NSUInteger)aSourceNodeIndex    
    targetNodeIndex:(NSUInteger)aTargetNodeIndex 
    heuristic:(id<Heuristic>)aHeuristic {
    self = [super init];
    if (self) {
        self.graph = aGraph;
        sourceNodeIndex = aSourceNodeIndex;
        targetNodeIndex = aTargetNodeIndex;
        heuristic = aHeuristic;
        gCosts = (double *)calloc(graph.numNodes, sizeof(double));
        fCosts = (double *)calloc(graph.numNodes, sizeof(double));
        shortestPathTree = [[NSMutableArray alloc] initWithCapacity:graph.numNodes];
        searchFrontier = [[NSMutableArray alloc] initWithCapacity:graph.numNodes];
        for (int i = 0; i < graph.numNodes; i++) {
            [shortestPathTree addObject:kNull];
            [searchFrontier addObject:kNull];
        }
        // do the search
        [self search];
    }
    return self;
}

- (void)dealloc {
    free(gCosts);
    free(fCosts);
    [graph release];
    [shortestPathTree release];
    [searchFrontier release];
    [super dealloc];
}

- (void)search {
    // create an indexed priority queue of nodes.
    // The queue will give priority to nodes with low F costs (F=G+H)
    IndexedPriorityQLow *pq = [[IndexedPriorityQLow alloc] initWithKeys:fCosts
                                                                maxSize:graph.numNodes];
    
    // put the source node on the queue
    [pq insert:sourceNodeIndex];
    
    // while the queue is not empty
    while (![pq empty]) {
        // get the lowest cost node from the queue
        NSUInteger nextClosestNodeIndex = [pq pop];
        
        // move this edge from the search frontier to the shortest path tree
        [shortestPathTree replaceObjectAtIndex:nextClosestNodeIndex 
                                    withObject:[searchFrontier objectAtIndex:nextClosestNodeIndex]];
        
        // if the target has been found, exit
        if (nextClosestNodeIndex == targetNodeIndex) {
            return;
        }
        
        // now to relax the edges, 
        // for each edge connected to the next closest node.
        NSArray *edges = [graph getEdgesForNodeWithIndex:nextClosestNodeIndex];
        for (GraphEdge *edge in edges) {
            // calculate the heuristic cost from this node to the target (H)
            GraphNode *nodeA = [graph getNodeWithIndex:targetNodeIndex];
            GraphNode *nodeB = [graph getNodeWithIndex:edge.to];
            double hCost = [heuristic calculateWithNodeA:nodeA b:nodeB];
            
            // calculate the "real" cost to this node from the source (G)
            double currentCost = gCosts[nextClosestNodeIndex];
            double gCost = currentCost + edge.cost;

            // if the node has not been added to the frontier,
            // add it and update the G and F costs            
            if ([searchFrontier objectAtIndex:edge.to] == kNull) {
                gCosts[edge.to] = gCost;
                fCosts[edge.to] = gCost + hCost;
                [pq insert:edge.to];
                [searchFrontier replaceObjectAtIndex:edge.to withObject:edge];
            } 
            // if this node is already on the frontier but the cost to get here this 
            // way is cheaper than has been found previously, update the node costs
            // and frontier accordingly
            else if (gCost < gCosts[edge.to] &&
                     [shortestPathTree objectAtIndex:edge.to] == kNull) {
                gCosts[edge.to] = gCost;
                fCosts[edge.to] = gCost + hCost;
                
                // because the cost is less than it was previously, the PQ must
                // be resorted to account for this.
                [pq changePriority:edge.to];
                
                [searchFrontier replaceObjectAtIndex:edge.to withObject:edge];
            }
        }
    }
    [pq release];
}

- (NSArray *)getSPT {
    return shortestPathTree;
}

- (NSArray *)getPathToTarget {
    NSMutableArray *path = [[NSMutableArray alloc] init];
    
    //just return an empty path if no target or no path found
    //    if (targetNodeIndex < 0) {
    //        return path;
    //    }
    
    NSUInteger nd = targetNodeIndex;
    [path insertObject:[NSNumber numberWithUnsignedInt:nd] atIndex:0];
    
    while (nd != sourceNodeIndex && 
           [shortestPathTree objectAtIndex:nd] != kNull) {
        GraphEdge *edge = [shortestPathTree objectAtIndex:nd];
        nd = edge.from;
        [path insertObject:[NSNumber numberWithUnsignedInt:nd] atIndex:0];
    }
    
    return [path autorelease];
}

- (double)getCostToNodeIndex:(NSUInteger)idx {
    return gCosts[idx];    
}

- (double)getCostToTarget {
    return [self getCostToNodeIndex:targetNodeIndex];
}

@end

