//
//  GraphSearchDijkstra.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "GraphEdge.h"
#import "GraphNode.h"
#import "GraphSearchDijkstra.h"
#import "IndexedPriorityQLow.h"
#import "SparseGraph.h"

static NSNull *kNull;

@interface GraphSearchDijkstra() 
- (void)search;
@end

@implementation GraphSearchDijkstra

@synthesize graph;

+ (void)initialize {
    static bool initialized = FALSE;
    if (!initialized) {
        kNull = [NSNull null];
    }
}

- (id)initWithGraph:(SparseGraph *)aGraph
    sourceNodeIndex:(NSUInteger)aSourceNodeIndex    
    targetNodeIndex:(NSUInteger)aTargetNodeIndex {
    self = [super init];
    if (self) {
        self.graph = aGraph;
        sourceNodeIndex = aSourceNodeIndex;
        targetNodeIndex = aTargetNodeIndex;
        // TODO: use arrays?
        shortestPathTree = [[NSMutableArray alloc] initWithCapacity:graph.numNodes];
        searchFrontier = [[NSMutableArray alloc] initWithCapacity:graph.numNodes];
        costToThisNode = (double *)calloc(graph.numNodes, sizeof(double));
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
    [graph release];
    [searchFrontier release];
    [shortestPathTree release];
    free(costToThisNode);
    [super dealloc];
}

- (void)search {
    // create an indexed priority queue that sorts smallest
    // to largest (front to back). Note that the maximum
    // number of elements the iPQ may contain is numNodes.
    // This is because no node can be represented on the 
    // queue more than once.
    IndexedPriorityQLow *pq = [[IndexedPriorityQLow alloc] initWithKeys:costToThisNode
                                                                maxSize:graph.numNodes];
    
    // put the source node on the queue
    [pq insert:sourceNodeIndex];
    
    // while the queue is not empty
    while (![pq empty]) {
        // get the lowest cost node from the queue (aka the one in front).
        // Don't forget, the return value is a *node index*, not the node
        // itself. This node is the node not already on the SPT that is the 
        // closest to the source node.
        NSUInteger nextClosestNodeIndex = [pq pop];
        
        // move this edge from the search frontier to the shortest path tree
        [shortestPathTree replaceObjectAtIndex:nextClosestNodeIndex 
                                    withObject:[searchFrontier objectAtIndex:nextClosestNodeIndex]];
        
        // if the target has been found, exit
        if (nextClosestNodeIndex == targetNodeIndex) {
            return;
        }
        
        // now to relax the edges, 
        // for each edger connected to the next closest node.
        NSArray *edges = [graph getEdgesForNodeWithIndex:nextClosestNodeIndex];
        for (GraphEdge *edge in edges) {
            // the total cost to the node this edge points to is the cost
            // to the current node plus the cost of the edge connecting them
            double currentCost = costToThisNode[nextClosestNodeIndex];
            double newCost = currentCost + edge.cost;
            
            // if this edge has never been on the frontier, make a note of the cost
            // to reach the node it points to, then add the edge to the frontier
            // and the destination node to the PQ
            // TODO: the pq in the book uses an initialized vector of Edge pointers, 
            // and then checks them for == 0.
            if ([searchFrontier objectAtIndex:edge.to] == kNull) {
                costToThisNode[edge.to] = newCost;
                [pq insert:edge.to];
                [searchFrontier replaceObjectAtIndex:edge.to withObject:edge];
            } 
            // else test to see if the cost to reach the destination node via the
            // current node is cheaper than the cheapest cost found so far.
            // If this path is cheaper, we assign the new cost to the destination
            // node, update its entry in PQ to reflect the change, and add the
            // edge to the frontier.            
            else if (newCost < costToThisNode[edge.to] &&
                     [shortestPathTree objectAtIndex:edge.to] == kNull) {
                costToThisNode[edge.to] = newCost;
                
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
    return costToThisNode[idx];    
}

- (double)getCostToTarget {
    return [self getCostToNodeIndex:targetNodeIndex];
}

@end
