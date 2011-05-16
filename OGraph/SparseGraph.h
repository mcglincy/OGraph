//
//  SparseGraph.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GraphEdge;
@class GraphNode;

@interface SparseGraph : NSObject <NSCoding> {
    // the nodes that comprise this graph
    NSMutableArray *nodes;
    
    // array of adjacency edge lists.
    // each node index keys into the list of edges associated with that node
    NSMutableArray *nodeEdges;
    
    // is this a directed graph?
    BOOL isDigraph;
    
    // index of the next node to be added
    NSUInteger nextNodeIndex;    
}

// number of active + inactive nodes present in the graph
@property (nonatomic, readonly) NSUInteger numNodes;
// number of active nodes present in the graph
@property (nonatomic, readonly) NSUInteger numActiveNodes;
// number of edges present in the graph
@property (nonatomic, readonly) NSUInteger numEdges;
// YES if the graph is directed
@property (nonatomic, readonly) BOOL isDigraph;
// YES if the graph contains no nodes
@property (nonatomic, readonly) BOOL isEmpty;

- (id)init;
- (id)initWithIsDigraph:(BOOL)anIsDigraph;
// returns the node at the given index
- (GraphNode *)getNodeWithIndex:(NSUInteger)index;
// returns the edge with the given from/to
- (GraphEdge *)getEdgeWithFrom:(NSUInteger)from to:(NSUInteger)to;
// returns the next free node index
- (NSUInteger)getNextFreeNodeIndex;
// adds a node to the graph and returns its index
- (NSUInteger)addNode:(GraphNode *)node;
// convenience method to add a node
- (NSUInteger)addNodeWithIndex:(NSUInteger)index;
// removes a node by setting its index to kInvalidNodeIndex
- (void)removeNodeWithIndex:(NSUInteger)index;
// add an edge to the graph
- (void)addEdge:(GraphEdge *)edge;
// convenience method to add an edge
- (void)addEdgeFrom:(NSUInteger)from to:(NSUInteger)to;
- (void)addEdgeFrom:(NSUInteger)from to:(NSUInteger)to cost:(double)cost;
// remove an edge from the graph
- (void)removeEdgeWithFrom:(NSUInteger)from to:(NSUInteger)to;
// returns YES if a node with the given index is present in the graph
- (BOOL)isNodePresentWithIndex:(NSUInteger)index;
// returns YES if an edge connecting the given node indexes is present in the graph
- (BOOL)isEdgePresentWithFrom:(NSUInteger)from to:(NSUInteger)to;
// clear the graph; ready for new node insertions
- (void)clear;
- (NSArray *)getEdgesForNodeWithIndex:(NSUInteger)index;
- (void)print;


- (void)archiveToFile:(NSString*)path;
+ (SparseGraph *)newFromFile:(NSString*)path;

@end
