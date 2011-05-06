//
//  SparseGraph.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "GraphConstants.h"
#import "GraphEdge.h"
#import "GraphNode.h"
#import "SparseGraph.h"

@interface SparseGraph()
// returns true if the edge is not present in the graph. 
// Used when adding edges to prevent duplication
- (BOOL)isEdgeUniqueWithFrom:(NSUInteger)from to:(NSUInteger)to;
// iterates through all the edges in the graph and removes any that point
// to an invalidated node
- (void)cullInvalidEdges;
@end

@implementation SparseGraph

@synthesize isDigraph;

- (id)init {
    return [self initWithIsDigraph:YES];
}

- (id)initWithIsDigraph:(BOOL)anIsDigraph {
    self = [super init];
    if (self) {
        isDigraph = anIsDigraph;
        nextNodeIndex = 0;
        nodes = [[NSMutableArray alloc] init];
        nodeEdges = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [nodes release];
    [nodeEdges release];
    [super dealloc];
}

- (NSUInteger)numNodes {
    return [nodes count];
}

- (NSUInteger)numActiveNodes {
    // TODO: cache this number for performance
    NSUInteger count = 0;
    for (GraphNode *node in nodes) {
        if (node.index != kInvalidNodeIndex) {
            count++;
        }
    }
    return count;
}

- (NSUInteger)numEdges {
    // TODO: cache this number for performance
    NSUInteger count = 0;
    for (NSArray *edges in nodeEdges) {
        count += [edges count];
    }
    return count;
}

- (BOOL)isEmpty {
    return [nodes count] == 0;
}

- (GraphNode *)getNodeWithIndex:(NSUInteger)index {
    if (index >= [nodes count]) {
        // out of bounds
        // TODO: raise error?
        return nil;
    }
    return [nodes objectAtIndex:index];
}

- (GraphEdge *)getEdgeWithFrom:(NSUInteger)from to:(NSUInteger)to {
    if (from >= [nodes count] || to >= [nodes count]) {
        // out of bounds
        return nil;
    }
    
    // look through the from-node's edges
    NSMutableArray *edges = [nodeEdges objectAtIndex:from];
    for (GraphEdge *edge in edges) {
        if (edge.to == to) {
            // found it
            return edge;
        }
    }
    
    // didn't find it
    return nil;
}

- (NSUInteger)getNextFreeNodeIndex {
    // TODO: redundant. eliminate w/ property?
    return nextNodeIndex;
}

- (NSUInteger)addNodeWithIndex:(NSUInteger)index {
    GraphNode *node = [[GraphNode alloc] initWithIndex:index];
    NSUInteger retVal = [self addNode:node];
    [node release];
    return retVal;
}

/**
 * Given a node this method first checks to see if the node has been added
 * previously but is now inactive. If it is, it is reactivated.
 * 
 * If the node has not been added previously, it is checked to make sure its
 * index matches the next node index before being added to the graph.
 */
- (NSUInteger)addNode:(GraphNode *)node {
    if (node.index < [nodes count]) {
        // make sure the client is not trying to add a node with the same index as
        // a currently active node   
        GraphNode *existingNode = [nodes objectAtIndex:node.index];
        NSAssert(existingNode.index == kInvalidNodeIndex, @"addNode: attempting to add a node with a duplicate index");
        [nodes replaceObjectAtIndex:node.index withObject:node];
        return nextNodeIndex;
    } else {
        // make sure the new node has been indexed correctly
        NSAssert(node.index == nextNodeIndex, @"addNode: invalid index");
        [nodes addObject:node];
        NSMutableArray *edges = [[NSMutableArray alloc] init];
        [nodeEdges addObject:edges];
        [edges release];
        return nextNodeIndex++;
    }
}

// Removes a node from the graph and removes any links to neighbouring nodes
- (void)removeNodeWithIndex:(NSUInteger)index {
    NSAssert(index < [nodes count], @"removeNodeWithIndex: invalid node index");
    
    GraphNode *node = [nodes objectAtIndex:index];
    // mark this node as invalid
    node.index = kInvalidNodeIndex;
    // if the graph is not directed remove all edges leading to this node and then
    // clear the edges leading from the node
    if (!isDigraph) {
        NSMutableArray *edges = [nodeEdges objectAtIndex:index];
        // visit each neighbour and erase any edges leading to this node
        // ...
        // finally, clear this node's edges
        [edges removeAllObjects];
    } else {
        // if we're a digraph, remove the edges the slow way
        [self cullInvalidEdges];
    }
}

- (void)cullInvalidEdges {
    // separate array to avoid concurrent modification
    NSMutableArray *toCull = [[NSMutableArray alloc] init];
    for (NSMutableArray *edges in nodeEdges) {
        for (GraphEdge *edge in edges) {
            GraphNode *fromNode = [nodes objectAtIndex:edge.from];
            GraphNode *toNode = [nodes objectAtIndex:edge.to];
            if (fromNode.index == kInvalidNodeIndex || 
                toNode.index == kInvalidNodeIndex) {
                [toCull addObject:edge];
            }
        }
        if ([toCull count] > 0) {
            [edges removeObjectsInArray:toCull];
            [toCull removeAllObjects];
        }
    }
    [toCull release];
}

// convenience method to add an edge
- (void)addEdgeFrom:(NSUInteger)from to:(NSUInteger)to {
    GraphEdge *edge = [[GraphEdge alloc] initWithFrom:from to:to];
    [self addEdge:edge];
    [edge release];
}

- (void)addEdgeFrom:(NSUInteger)from to:(NSUInteger)to cost:(double)cost {
    GraphEdge *edge = [[GraphEdge alloc] initWithFrom:from to:to cost:cost];
    [self addEdge:edge];
    [edge release];    
}

/**
 * Use this to add an edge to the graph. The method will ensure that the
 * edge passed as a parameter is valid before adding it to the graph. If the
 * graph is a digraph then a similar edge connecting the nodes in the opposite
 * direction will be automatically added.
 */
- (void)addEdge:(GraphEdge *)edge {
    // first make sure the from and to nodes exist within the graph 
    NSAssert(edge.from < nextNodeIndex && edge.to < nextNodeIndex, @"addEdge: invalid node index");
    // TODO: check vs. nodes count?
    
    GraphNode *fromNode = [nodes objectAtIndex:edge.from];
    GraphNode *toNode = [nodes objectAtIndex:edge.to];
    
    // make sure both nodes are active before adding the edge
    if (fromNode.index == kInvalidNodeIndex || toNode.index == kInvalidNodeIndex) {
        return;
    }
    
    // add the edge, first making sure it is unique
    if ([self isEdgeUniqueWithFrom:edge.from to:edge.to]) {
        [[nodeEdges objectAtIndex:edge.from] addObject:edge];
    }
    
    // if the graph is undirected we must add another connection in the opposite
    // direction
    if (!isDigraph) {
        // check to make sure the edge is unique before adding
        if ([self isEdgeUniqueWithFrom:edge.to to:edge.from]) {
            GraphEdge *oppositeEdge = [[GraphEdge alloc] initWithFrom:edge.to to:edge.from];
            [[nodeEdges objectAtIndex:edge.to] addObject:oppositeEdge];
            [oppositeEdge release];
        }
    }
}

- (void)removeEdgeWithFrom:(NSUInteger)from to:(NSUInteger)to {
    NSAssert(from < [nodes count] && to < [nodes count],
             @"removeEdgeWithFrom: invalid node index");
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    if (!isDigraph) {
        // handle backpointing to=>from edges
        NSMutableArray *edges = [nodeEdges objectAtIndex:to];
        for (GraphEdge *edge in edges) {
            if (edge.to == from) {
                [toRemove addObject:edge];
            }
        }
        if ([toRemove count] > 0) {
            [edges removeObjectsInArray:toRemove];
            [toRemove removeAllObjects];
        }
    }
    
    // handle from=>to edges
    NSMutableArray *edges = [nodeEdges objectAtIndex:from];
    for (GraphEdge *edge in edges) {
        if (edge.to == to) {
            [toRemove addObject:edge];
        }
    }
    if ([toRemove count] > 0) {
        [edges removeObjectsInArray:toRemove];
        [toRemove removeAllObjects];
    }
    
    [toRemove release];
}

- (BOOL)isNodePresentWithIndex:(NSUInteger)index {
    if (index >= [nodes count]) {
        // out of bounds
        return FALSE;
    }
    GraphNode *node = [nodes objectAtIndex:index];
    if (node.index == kInvalidNodeIndex) {
        // node was invalidated
        return FALSE;
    }
    return TRUE;
}

- (BOOL)isEdgePresentWithFrom:(NSUInteger)from to:(NSUInteger)to {
    // both nodes must exist in our graph
    if ([self isNodePresentWithIndex:from] && [self isNodePresentWithIndex:to]) {
        // then check the actual edges emanating from the from node
        NSMutableArray *edges = [nodeEdges objectAtIndex:from];
        for (GraphEdge *edge in edges) {
            if (edge.to == to) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)isEdgeUniqueWithFrom:(NSUInteger)from to:(NSUInteger)to {
    // shorthand, unsafe internal version of isEdgePresentWithFrom
    NSMutableArray *edges = [nodeEdges objectAtIndex:from];
    for (GraphEdge *edge in edges) {
        if (edge.to == to) {
            return NO;
        }
    }    
    return TRUE;
}

- (void)clear {
    [nodes removeAllObjects];
    [nodeEdges removeAllObjects];
}

- (NSArray *)getEdgesForNodeWithIndex:(NSUInteger)index {
    if (index > [nodes count]) {
        return nil;
    }
    return [nodeEdges objectAtIndex:index];
}

- (void)print {
    NSUInteger count = 0;
    for (NSArray *edges in nodeEdges) {
        NSLog(@"node %d", count);
        for (GraphEdge *edge in edges) {
            NSLog(@"%d=>%d", edge.from, edge.to);
        }
        count++;
    }
}

@end
