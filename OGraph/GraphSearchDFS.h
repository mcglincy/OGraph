//
//  GraphSearchDFS.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SparseGraph;

@interface GraphSearchDFS : NSObject {
    // graph to be searched
    SparseGraph *graph;
    // nodes we've visited
    NSMutableArray *visitedNodeIndexes;
    // the route we took
    NSMutableArray *routeNodeIndexes;
    // source and target node indexes
    NSUInteger sourceNodeIndex;
    NSUInteger targetNodeIndex;
    // YES is a path to the target has been found
    BOOL pathToTargetFound;
}

@property (nonatomic, retain) SparseGraph *graph;
@property (nonatomic, readonly) BOOL pathToTargetFound;

- (id)initWithGraph:(SparseGraph *)aGraph 
    sourceNodeIndex:(NSUInteger)aSourceNodeIndex
    targetNodeIndex:(NSUInteger)aTargetNodeIndex;

- (NSArray *)getPathToTarget;

@end
