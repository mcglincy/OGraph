//
//  GraphSearchBFS.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "GraphSearchBFS.h"
#import "GraphEdge.h"
#import "GraphNode.h"
#import "SparseGraph.h"

NSNumber *kVisited;
NSNumber *kUnvisited;
NSNumber *kNoParentAssigned;

@interface GraphSearchBFS()
// perform the DFS search
- (BOOL)search;
@end

@implementation GraphSearchBFS

@synthesize graph, pathToTargetFound;

+ (void)initialize {
    static bool initialized = FALSE;
    if (!initialized) {
        kVisited = [[NSNumber alloc] initWithInt:0];
        kUnvisited = [[NSNumber alloc] initWithInt:1];
        kNoParentAssigned = [[NSNumber alloc] initWithInt:2];
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
        visitedNodeIndexes = [[NSMutableArray alloc] initWithCapacity:graph.numNodes];
        routeNodeIndexes = [[NSMutableArray alloc] initWithCapacity:graph.numNodes];
        for (int i = 0; i < graph.numNodes; i++) {
            [visitedNodeIndexes addObject:kUnvisited];
            [routeNodeIndexes addObject:kNoParentAssigned];
        }
        
        // do the search
        pathToTargetFound = [self search];
    }
    return self;
}

- (void)dealloc {
    [graph release];
    [super dealloc];
}

- (BOOL)search {
    // FIFO queue of edges
    NSMutableArray *queue = [[[NSMutableArray alloc] init] autorelease];
    
    // create a dummy edge and put it on the stack
    GraphEdge *dummy = [[GraphEdge alloc] initWithFrom:sourceNodeIndex to:sourceNodeIndex];
    [queue addObject:dummy];
    [dummy release];
    
    // while there are edges on the stack keep searching
    while ([queue count] > 0) {
        // take from the front of the queue
        GraphEdge *next = [queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
        //NSLog(@"popping edge %d=>%d", next.from, next.to);
        
        // make a note of the parent of the node this edge points to
        [routeNodeIndexes replaceObjectAtIndex:next.to withObject:[NSNumber numberWithInt:next.from]];
        
        // and mark it as visited
        [visitedNodeIndexes replaceObjectAtIndex:next.to withObject:kVisited];
        
        // if the target has been found, the method can return success
        if (next.to == targetNodeIndex) {
            return YES;
        }
        
        // push the edges leading the the node this edge points to onto
        // the stack (provided the edge does not point to a previously
        // visited node
        NSArray *edges = [graph getEdgesForNodeWithIndex:next.to];
        for (GraphEdge *edge in edges) {
            if ([visitedNodeIndexes objectAtIndex:edge.to] == kUnvisited) {
                //NSLog(@"pushing edge %d=>%d", edge.from, edge.to);
                [queue addObject:edge];
            }
        }
    } // while
    
    // no path to target
    return NO;
}

- (NSArray *)getPathToTarget {
    if (!pathToTargetFound) {
        return nil;
    }
    // start at the target node
    NSMutableArray *path = [[NSMutableArray alloc] init];
    NSUInteger nd = targetNodeIndex;
    [path addObject:[NSNumber numberWithUnsignedInteger:nd]];
    
    // and then work our way backwards through the parents, until
    // we get to our source
    while (nd != sourceNodeIndex) {
        nd = [[routeNodeIndexes objectAtIndex:nd] unsignedIntegerValue];
        // note that we prepend the next parent, as we're working backwards
        // from the target
        [path insertObject:[NSNumber numberWithUnsignedInteger:nd] atIndex:0];
    }
    return path;
}

@end
