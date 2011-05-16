//
//  GraphSearchAStar.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Heuristic.h"
@class SparseGraph;


@interface GraphSearchAStar : NSObject {
    // graph we're searching
    SparseGraph *graph;

    // indexed into by node index.
    // Contains the "real" cumulative cost to that node.
    double *gCosts;
    
    // indexed into by node index.
    // Contains the cost from adding gCosts[n] to the heuristic
    // cost from n to the target node.  This is the array the
    // iPQ indexes into.
    double *fCosts;
    
    // this array contains the edges that comprise the shortest path 
    // tree - a directed subtree of the graph that encapsulates the 
    // best paths from every node on the SPT to the source node.
    NSMutableArray *shortestPathTree;
    
    // this is an indexed (by node) list of "parent" edges leading
    // to nodes connected to the SPT but that have not been added
    // to the SPT yet
    NSMutableArray *searchFrontier;
    
    // source node for the search
    NSUInteger sourceNodeIndex;
    
    // target node for the search
    NSUInteger targetNodeIndex;
    
    // AStar heuristic
    id<Heuristic> heuristic;
}

@property (nonatomic, retain) SparseGraph *graph;

- (id)initWithGraph:(SparseGraph *)aGraph
    sourceNodeIndex:(NSUInteger)aSourceNodeIndex    
    targetNodeIndex:(NSUInteger)aTargetNodeIndex
          heuristic:(id<Heuristic>)aHeuristic;

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
