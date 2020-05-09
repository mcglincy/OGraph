OGraph, an Objective-C graph library for iOS
============================================

Where it comes from
-------------------
This is basically an Objective-C port of Mat Buckland's C++ graph classes, as
described in his excellent book *Programming Game AI by Example*. More info on Mat Buckland's book and sample C++ files are available at https://www.jblearning.com/catalog/productdetails/9781556220784.

OGraph lets you model directed and undirected graphs with nodes and edges, and perform a variety of search algorithms on them, including BFS, DFS, Dijkstra, and A* (AStar).

How to use it
-------------
In a nutshell:

    // make a graph
    SparseGraph *graph = [[SparseGraph alloc] init];
    
    // add some nodes
    [graph addNodeWithIndex:0];
    [graph addNodeWithIndex:1];
    [graph addNodeWithIndex:2];

    // add some edges
    [graph addEdgeFrom:0 to:1];
    [graph addEdgeFrom:1 to:2];

    // search it using a search class
    GraphSearchDFS *dfs = [[GraphSearchDFS alloc] initWithGraph:graph sourceNodeIndex:0 targetNodeIndex:2];
    NSArray *pathOfNodeIndexes = [dfs getPathToTarget];

    ... 

Check out [the unit tests](https://github.com/mcglincy/OGraph/blob/master/OGraphTests/OGraphTests.m) for more examples.

