OGraph, an objective-c graph library for iOS
============================================

Where it comes from
-------------------
This is basically an obj-c port of Mat Buckland's C++ graph classes, as
described in his excellent book "Programming Game AI by Example."

More info on Mat Buckland's book and sample C++ files are available at 
http://www.wordware.com/ai

How to use it
-------------
In a nutshell:

    // make a graph
    SparseGraph *graph = [[SparseGraph alloc] initWithIsDigraph:NO];
    
    // add some nodes
    [graph addNodeWithIndex:0];
    [graph addNodeWithIndex:1];

    // add some edges
    graph addEdgeFrom:0 to:1];
    [graph addEdgeFrom:0 to:1];

    // search it using a search class
    GraphSearchDFS *dfs = [[GraphSearchDFS alloc] initWithGraph:graph sourceNodeIndex:0 targetNodeIndex:1];
    NSArray *pathOfNodeIndexes = [dfs getPathToTarget];
    ... 

Check out [the unit tests](https://github.com/mcglincy/OGraph/blob/master/OGraphTests/OGraphTests.m) for more examples.

