//
//  GraphSearchDijkstra.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SparseGraph;

@interface GraphSearchDijkstra : NSObject {
    // graph we're searching
    SparseGraph *graph;
    
    // this array contains the edges that comprise the shortest path 
    // tree - a directed subtree of the graph that encapsulates the 
    // best paths from every node on the SPT to the source node.
    NSMutableArray *shortestPathTree;
    
    // this is indexed into by node index and holds the total cost
    // of the best path found so far to the given node. For example,
    // costToThisNode idx 5 will hold the total cost of all the edges
    // that comprise the best path to node 5 found so far in the
    // search (if node 5 is present and has been visited)
    double *costToThisNode;
    
    // this is an indexed (by node) list of "parent" edges leading
    // to nodes connected to the SPT but that have not been added
    // to the SPT yet
    NSMutableArray *searchFrontier;
    
    // source node for the search
    NSUInteger sourceNodeIndex;
    
    // target node for the search
    NSUInteger targetNodeIndex;
}

@property (nonatomic, retain) SparseGraph *graph;

- (id)initWithGraph:(SparseGraph *)aGraph
    sourceNodeIndex:(NSUInteger)aSourceNodeIndex    
    targetNodeIndex:(NSUInteger)aTargetNodeIndex;

// returns the vector of edges that defines the SPT. If a target was given
// in the constructor then this will be an SPT comprising of all the nodes
// examined before the target was found, else it will contain all the nodes
// in the graph.
- (NSArray *)getSPT;

// returns the list of node indexes comprising the shortest path
// from the source to the target.  It calculates the path by working
// backward through the SPT from the target node.
- (NSArray *)getPathToTarget;

// returns the total cost to the given node
- (double)getCostToNodeIndex:(NSUInteger)idx;

// returns the total cost to the target
- (double)getCostToTarget;

@end
