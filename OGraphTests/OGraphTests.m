//
//  OGraphTests.m
//  OGraphTests
//
//  Created by Matthew McGlincy on 5/6/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "GraphEdge.h"
#import "GraphNode.h"
#import "GraphSearchAStar.h"
#import "GraphSearchBFS.h"
#import "GraphSearchDFS.h"
#import "GraphSearchDijkstra.h"
#import "Heuristic.h"
#import "HeuristicEuclid.h"
#import "NavGraphNode.h"
#import "SparseGraph.h"
#import "OGraphTests.h"

@interface OGraphTests()
+ (SparseGraph *)minimalDigraph;
+ (SparseGraph *)sampleUndirectedGraph;
+ (SparseGraph *)twoRouteCostedDigraph;
+ (SparseGraph *)complicatedCostedDigraph;
+ (SparseGraph *)threeByThreeNavGraph;
@end

@implementation OGraphTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

+ (SparseGraph *)minimalDigraph {
    // simple digraph with 2 nodes and 1 edge
    SparseGraph *graph = [[SparseGraph alloc] initWithIsDigraph:YES];
    [graph addNodeWithIndex:0];
    [graph addNodeWithIndex:1];
    [graph addEdgeFrom:0 to:1];
    return [graph autorelease];
}

- (void)testSparseGraph {
    SparseGraph *graph = [OGraphTests minimalDigraph];
    
    // simple existence checks
    STAssertEquals(graph.numNodes, 2U, nil);
    STAssertEquals(graph.numActiveNodes, 2U, nil);
    STAssertEquals(graph.numEdges, 1U, nil);
    STAssertTrue([graph isNodePresentWithIndex:0], nil);
    STAssertTrue([graph isNodePresentWithIndex:1], nil);
    STAssertFalse([graph isNodePresentWithIndex:3], nil);
    STAssertTrue([graph isEdgePresentWithFrom:0 to:1], nil);    
    STAssertFalse([graph isEdgePresentWithFrom:1 to:0], nil);    
    
    // remove an edge
    [graph removeEdgeWithFrom:0 to:1];
    STAssertEquals(graph.numEdges, 0U, nil);
    STAssertFalse([graph isEdgePresentWithFrom:0 to:1], nil);    
    STAssertEquals(graph.numEdges, 0U, nil);
    
    // put it back
    GraphEdge *e0 = [[GraphEdge alloc] initWithFrom:0 to:1];
    [graph addEdge:e0];
    [e0 release];
    STAssertTrue([graph isEdgePresentWithFrom:0 to:1], nil);    
    STAssertEquals(graph.numEdges, 1U, nil);
    
    // remove a node, which should only deactivate the node
    [graph removeNodeWithIndex:1];
    STAssertEquals(graph.numNodes, 2U, nil);
    STAssertEquals(graph.numActiveNodes, 1U, nil);
    // but, it should nuke our edge, too
    STAssertEquals(graph.numEdges, 0U, nil);
    STAssertFalse([graph isEdgePresentWithFrom:0 to:1], nil);    
    
    // clear
    [graph clear];
    STAssertEquals(graph.numNodes, 0U, nil);
    STAssertEquals(graph.numActiveNodes, 0U, nil);
    STAssertEquals(graph.numEdges, 0U, nil);
    STAssertFalse([graph isNodePresentWithIndex:0], nil);
    STAssertFalse([graph isNodePresentWithIndex:1], nil);
    STAssertFalse([graph isEdgePresentWithFrom:0 to:1], nil);    
}

- (void)testSimpleDirectedDFS {
    // simple digraph with 2 nodes and 1 edge
    SparseGraph *graph = [OGraphTests minimalDigraph];
    
    GraphSearchDFS *dfs = [[GraphSearchDFS alloc] initWithGraph:graph sourceNodeIndex:0 targetNodeIndex:1];
    STAssertTrue(dfs.pathToTargetFound, nil);
    NSArray *path = [dfs getPathToTarget];
    // path should be of 2 elements, from node 0 (source) to node 1 (target)
    STAssertEquals([path count], 2U, nil);
    STAssertEqualObjects([path objectAtIndex:0], [NSNumber numberWithInt:0], nil);
    STAssertEqualObjects([path objectAtIndex:1], [NSNumber numberWithInt:1], nil);
    
    [graph release];
}

+ (SparseGraph *)sampleUndirectedGraph {
    // create the undirected graph from The Secret Life of Graphs chapter
    SparseGraph *graph = [[SparseGraph alloc] initWithIsDigraph:NO];
    [graph addNodeWithIndex:0];
    [graph addNodeWithIndex:1];
    [graph addNodeWithIndex:2];
    [graph addNodeWithIndex:3];
    [graph addNodeWithIndex:4];
    [graph addNodeWithIndex:5];
    [graph addEdgeFrom:0 to:1];
    [graph addEdgeFrom:0 to:2];
    [graph addEdgeFrom:1 to:4];
    [graph addEdgeFrom:2 to:3];
    [graph addEdgeFrom:3 to:4];
    [graph addEdgeFrom:3 to:5];
    [graph addEdgeFrom:4 to:5];
    return [graph autorelease];
}

- (void)testUndirectedDFS {
    SparseGraph *graph = [OGraphTests sampleUndirectedGraph];
    GraphSearchDFS *dfs = [[GraphSearchDFS alloc] initWithGraph:graph sourceNodeIndex:4 targetNodeIndex:2];
    
    STAssertTrue(dfs.pathToTargetFound, nil);
    NSArray *path = [dfs getPathToTarget];
    // note that the order we add edges will affect the order edges are pushed 
    // onto our search stack, and thus ultimately the order of the DFS.
    // With the edge-adding order above, we end up with 4=>5=>3=>2
    STAssertEquals([path count], 4U, nil);
    STAssertEqualObjects([path objectAtIndex:0], [NSNumber numberWithInt:4], nil);
    STAssertEqualObjects([path objectAtIndex:1], [NSNumber numberWithInt:5], nil);
    STAssertEqualObjects([path objectAtIndex:2], [NSNumber numberWithInt:3], nil);
    STAssertEqualObjects([path objectAtIndex:3], [NSNumber numberWithInt:2], nil);
    
    [dfs release];
}

- (void)testUndirectedBFS {
    SparseGraph *graph = [OGraphTests sampleUndirectedGraph];
    GraphSearchBFS *bfs = [[GraphSearchBFS alloc] initWithGraph:graph sourceNodeIndex:4 targetNodeIndex:2];
    
    STAssertTrue(bfs.pathToTargetFound, nil);
    NSArray *path = [bfs getPathToTarget];
    // BFS path is 4=>3=>2
    STAssertEquals([path count], 3U, nil);
    STAssertEqualObjects([path objectAtIndex:0], [NSNumber numberWithInt:4], nil);
    STAssertEqualObjects([path objectAtIndex:1], [NSNumber numberWithInt:3], nil);
    STAssertEqualObjects([path objectAtIndex:2], [NSNumber numberWithInt:2], nil);
    
    [bfs release];
}

+ (SparseGraph *)twoRouteCostedDigraph {
    // simple digraph with 4 nodes, with a "cheaper" way to get from
    // source n0 to target n3
    SparseGraph *graph = [[SparseGraph alloc] initWithIsDigraph:YES];
    [graph addNodeWithIndex:0];
    [graph addNodeWithIndex:1];
    [graph addNodeWithIndex:2];
    [graph addNodeWithIndex:3];
    [graph addEdgeFrom:0 to:1 cost:1.0];
    [graph addEdgeFrom:0 to:2 cost:1.0];
    [graph addEdgeFrom:1 to:3 cost:0.5];
    [graph addEdgeFrom:2 to:3 cost:1.0];
    return [graph autorelease];
}

+ (SparseGraph *)complicatedCostedDigraph {
    // a more complicated digraph, as used in the chapter
    // The Secret Life of Graphs, pg233.
    SparseGraph *graph = [[SparseGraph alloc] initWithIsDigraph:YES];
    [graph addNodeWithIndex:0];
    [graph addNodeWithIndex:1];
    [graph addNodeWithIndex:2];
    [graph addNodeWithIndex:3];
    [graph addNodeWithIndex:4];
    [graph addNodeWithIndex:5];
    [graph addEdgeFrom:0 to:4 cost:2.9];
    [graph addEdgeFrom:0 to:5 cost:1.0];
    [graph addEdgeFrom:1 to:2 cost:3.1];
    [graph addEdgeFrom:2 to:4 cost:0.8];
    [graph addEdgeFrom:3 to:2 cost:3.7];
    [graph addEdgeFrom:4 to:1 cost:1.9];
    [graph addEdgeFrom:4 to:5 cost:3.0];
    [graph addEdgeFrom:5 to:3 cost:1.1];
    return [graph autorelease];
}

- (void)testEasyDijkstra {
    SparseGraph *graph = [OGraphTests twoRouteCostedDigraph];
    GraphSearchDijkstra *dij = [[GraphSearchDijkstra alloc] initWithGraph:graph sourceNodeIndex:0 targetNodeIndex:3];
    NSArray *path = [dij getPathToTarget];
    // our test digraph has 2 routes from 0=>3: 0=>2=>3 costing 2.0, and 0=>1=>3 costing 1.5.
    // Make sure our search picks the cheaper route of 1.5.
    STAssertEquals([path count], 3U, nil);
    STAssertEqualObjects([path objectAtIndex:0], [NSNumber numberWithInt:0], nil);
    STAssertEqualObjects([path objectAtIndex:1], [NSNumber numberWithInt:1], nil);
    STAssertEqualObjects([path objectAtIndex:2], [NSNumber numberWithInt:3], nil);
    STAssertEquals([dij getCostToTarget], 1.5, nil);
    [dij release];
}

- (void)testComplicatedDijkstra {
    SparseGraph *graph = [OGraphTests complicatedCostedDigraph];
    GraphSearchDijkstra *dij = [[GraphSearchDijkstra alloc] initWithGraph:graph sourceNodeIndex:4 targetNodeIndex:2];
    NSArray *path = [dij getPathToTarget];
    // cheapest path from 4=>2 is 4=>1=>2, with a total cost of 5.0
    STAssertEquals([path count], 3U, nil);
    STAssertEqualObjects([path objectAtIndex:0], [NSNumber numberWithInt:4], nil);
    STAssertEqualObjects([path objectAtIndex:1], [NSNumber numberWithInt:1], nil);
    STAssertEqualObjects([path objectAtIndex:2], [NSNumber numberWithInt:2], nil);
    STAssertEquals([dij getCostToTarget], 5.0, nil);
    [dij release];
}

+ (SparseGraph *)threeByThreeNavGraph {
    // make a small 3x3 grid of nodes
    // 0 - 1 - 2
    // | X | X |
    // 3 - 4 - 5
    // | X | X |
    // 6 - 7 - 8
    SparseGraph *graph = [[SparseGraph alloc] initWithIsDigraph:NO];
    NSUInteger idx = 0;
    for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
            // give then positions, assuming 50px grid tile size
            CGPoint pos = CGPointMake(col * 50.0, row * 50.0);
            NavGraphNode *n = [[NavGraphNode alloc] initWithIndex:idx position:pos];
            [graph addNode:n];
            [n release];
            idx++;
        }
    }
    [graph addEdgeFrom:0 to:1];
    [graph addEdgeFrom:0 to:3];
    [graph addEdgeFrom:0 to:4];
    [graph addEdgeFrom:1 to:2];
    [graph addEdgeFrom:1 to:3];
    [graph addEdgeFrom:1 to:4];
    [graph addEdgeFrom:1 to:4];
    [graph addEdgeFrom:2 to:4];
    [graph addEdgeFrom:2 to:5];
    [graph addEdgeFrom:3 to:4];
    [graph addEdgeFrom:3 to:6];
    [graph addEdgeFrom:3 to:7];
    [graph addEdgeFrom:4 to:6];
    [graph addEdgeFrom:4 to:7];
    [graph addEdgeFrom:4 to:8];
    [graph addEdgeFrom:5 to:7];
    [graph addEdgeFrom:5 to:8];
    [graph addEdgeFrom:6 to:7];
    [graph addEdgeFrom:7 to:8];
    return [graph autorelease];
}

- (void)testAStar {
    SparseGraph *graph = [OGraphTests threeByThreeNavGraph];
    HeuristicEuclid *heuristic = [[HeuristicEuclid alloc] init];
    // find a path from our bottom center node (7) to our top center (1)
    GraphSearchAStar *aStar = [[GraphSearchAStar alloc] initWithGraph:graph 
                                                      sourceNodeIndex:7 
                                                      targetNodeIndex:1 
                                                            heuristic:heuristic];
    NSArray *path = [aStar getPathToTarget];
    // best path will be straight up the middle column: 7=>4=>1
    STAssertEquals([path count], 3U, nil);
    STAssertEqualObjects([path objectAtIndex:0], [NSNumber numberWithInt:7], nil);
    STAssertEqualObjects([path objectAtIndex:1], [NSNumber numberWithInt:4], nil);
    STAssertEqualObjects([path objectAtIndex:2], [NSNumber numberWithInt:1], nil);
    
    // do another search
    [aStar release];
    // find a path from our lower-left (6) to our upper right (2)
    aStar = [[GraphSearchAStar alloc] initWithGraph:graph 
                                    sourceNodeIndex:6 
                                    targetNodeIndex:2 
                                          heuristic:heuristic];
    path = [aStar getPathToTarget];
    // best path will be the diagonal: 6=>4=>2
    STAssertEquals([path count], 3U, nil);
    STAssertEqualObjects([path objectAtIndex:0], [NSNumber numberWithInt:6], nil);
    STAssertEqualObjects([path objectAtIndex:1], [NSNumber numberWithInt:4], nil);
    STAssertEqualObjects([path objectAtIndex:2], [NSNumber numberWithInt:2], nil);
    
    [heuristic release];
    [aStar release];
}


@end
